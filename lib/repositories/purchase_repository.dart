import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/purchase_models.dart';
import 'purchase_catalog.dart';

class PurchaseRepository {
  static const _ownedKey = 'octoplot_clearance_owned';
  static const _grantKey = 'octoplot_clearance_grant';

  final StreamController<PurchaseOutcome> _outcomes = StreamController.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _sub;
  ProductDetails? _product;
  Completer<bool>? _restore;

  // The plugin is only touched on Android and iOS; the web preview has no store.
  InAppPurchase get _iap => InAppPurchase.instance;

  bool get supported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  Stream<PurchaseOutcome> get outcomes => _outcomes.stream;

  Future<bool> loadCachedOwned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_ownedKey) ?? false;
  }

  /// Subscribes to the purchase stream; must run before any query or purchase.
  void start() {
    if (!supported || _sub != null) return;
    _sub = _iap.purchaseStream.listen(
      _onBatch,
      onError: (Object e) => _emit(PurchaseOutcomeKind.failed, 'The store reported an error: $e'),
    );
  }

  Future<StoreProduct> loadProduct() async {
    if (!await _iap.isAvailable()) {
      throw const StoreException('The store is not available on this device.');
    }
    final response = await _iap.queryProductDetails({clearanceProductId});
    if (response.error != null) throw StoreException(response.error!.message);
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      throw const StoreException(
        'The store does not list "$clearanceProductId" yet. Create this product in Google Play Console and App Store Connect.',
      );
    }
    final product = response.productDetails.first;
    _product = product;
    return StoreProduct(id: product.id, title: product.title, price: product.price);
  }

  Future<bool> buy() async {
    final product = _product;
    if (product == null) throw const StoreException('The product has not loaded yet.');
    return _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  /// Refreshes entitlements from the store; true when the clearance is owned.
  Future<bool> restore() async {
    if (!supported) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final addition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      if (response.error != null) throw StoreException(response.error!.message);
      final found = response.pastPurchases.any((p) => p.productID == clearanceProductId && _isPaid(p));
      await _handle(response.pastPurchases);
      if (!found) await _revoke();
      return found;
    }
    final completer = Completer<bool>();
    _restore = completer;
    try {
      await _iap.restorePurchases();
      return await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw const StoreException('Restoring timed out. Check your connection and try again.'),
      );
    } finally {
      _restore = null;
    }
  }

  Future<void> _onBatch(List<PurchaseDetails> batch) async {
    final waiter = _restore;
    final isRestoreBatch =
        waiter != null && !waiter.isCompleted && batch.every((p) => p.status == PurchaseStatus.restored);
    await _handle(batch);
    if (isRestoreBatch) {
      waiter.complete(batch.any((p) => p.productID == clearanceProductId));
    }
  }

  Future<void> _handle(List<PurchaseDetails> batch) async {
    for (final details in batch) {
      if (details.productID != clearanceProductId) continue;
      try {
        final status = details.status;
        if (status == PurchaseStatus.pending) {
          _emit(PurchaseOutcomeKind.pending);
        } else if (status == PurchaseStatus.purchased || status == PurchaseStatus.restored) {
          if (!_isPaid(details)) {
            _emit(PurchaseOutcomeKind.pending);
            continue;
          }
          await _grant(details);
          _emit(PurchaseOutcomeKind.granted);
          await _finish(details);
        } else if (status == PurchaseStatus.error) {
          _emit(PurchaseOutcomeKind.failed, details.error?.message ?? 'The purchase failed.');
          await _finish(details);
        } else {
          _emit(PurchaseOutcomeKind.canceled);
          await _finish(details);
        }
      } catch (e) {
        _emit(PurchaseOutcomeKind.failed, 'Could not complete the purchase: $e');
      }
    }
  }

  bool _isPaid(PurchaseDetails details) {
    if (details is GooglePlayPurchaseDetails) {
      return details.billingClientPurchase.purchaseState == PurchaseStateWrapper.purchased;
    }
    return true;
  }

  // Grant durably first, keyed by the store's purchase token or ID.
  Future<void> _grant(PurchaseDetails details) async {
    final prefs = await SharedPreferences.getInstance();
    final key = defaultTargetPlatform == TargetPlatform.android
        ? details.verificationData.serverVerificationData
        : (details.purchaseID ?? '');
    await prefs.setString(_grantKey, key);
    await prefs.setBool(_ownedKey, true);
  }

  Future<void> _revoke() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_ownedKey) ?? false) {
      await prefs.setBool(_ownedKey, false);
      await prefs.remove(_grantKey);
      _emit(PurchaseOutcomeKind.revoked);
    }
  }

  Future<void> _finish(PurchaseDetails details) async {
    if (details.pendingCompletePurchase) await _iap.completePurchase(details);
  }

  void _emit(PurchaseOutcomeKind kind, [String? message]) {
    if (!_outcomes.isClosed) _outcomes.add(PurchaseOutcome(kind, message));
  }

  void dispose() {
    unawaited(_sub?.cancel());
    unawaited(_outcomes.close());
  }
}
