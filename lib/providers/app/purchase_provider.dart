import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/purchase_models.dart';
import '../../services/purchase_service.dart';

class PurchaseProvider extends ChangeNotifier {
  final PurchaseService _service;
  StreamSubscription<PurchaseOutcome>? _sub;

  bool _owned = false;
  bool _loading = true;
  bool _busy = false;
  bool _pending = false;
  bool _restoring = false;
  StoreProduct? _product;
  String? _error;
  String? _notice;

  PurchaseProvider({required PurchaseService service}) : _service = service {
    _sub = _service.outcomes.listen(_onOutcome);
  }

  bool get owned => _owned;
  bool get loading => _loading;
  bool get busy => _busy;
  bool get pending => _pending;
  bool get restoring => _restoring;
  bool get supported => _service.supported;
  String? get price => _product?.price;
  String? get error => _error;
  String? get notice => _notice;
  bool get canBuy => supported && _product != null && !_owned && !_busy && !_pending;

  Future<void> load() async {
    try {
      _owned = await _service.loadOwned();
    } catch (e) {
      _error = 'Could not read your saved clearance: $e';
    }
    if (!supported) {
      _loading = false;
      notifyListeners();
      return;
    }
    notifyListeners();
    _service.start();
    await _loadProduct();
    try {
      await _service.restore();
    } catch (e) {
      _error ??= _describe(e);
    }
    notifyListeners();
  }

  Future<void> retry() => _loadProduct();

  Future<void> buy() async {
    if (!canBuy) return;
    _busy = true;
    _error = null;
    _notice = null;
    notifyListeners();
    try {
      final started = await _service.buyClearance();
      if (!started) {
        _busy = false;
        _error = 'The store could not start the purchase. Please try again.';
      }
    } catch (e) {
      _busy = false;
      _error = 'Purchase failed: ${_describe(e)}';
    }
    notifyListeners();
  }

  Future<void> restore() async {
    if (_restoring || !supported) return;
    _restoring = true;
    _error = null;
    _notice = null;
    notifyListeners();
    try {
      final found = await _service.restore();
      _notice = found ? 'Clearance restored.' : 'No previous purchases found.';
    } catch (e) {
      _error = 'Restore failed: ${_describe(e)}';
    }
    _restoring = false;
    notifyListeners();
  }

  Future<void> _loadProduct() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _product = await _service.loadProduct();
    } catch (e) {
      _error = _describe(e);
    }
    _loading = false;
    notifyListeners();
  }

  void _onOutcome(PurchaseOutcome outcome) {
    switch (outcome.kind) {
      case PurchaseOutcomeKind.granted:
        _owned = true;
        _busy = false;
        _pending = false;
        _error = null;
        _notice = 'Clearance granted. Welcome to the vault.';
      case PurchaseOutcomeKind.pending:
        _busy = false;
        _pending = true;
      case PurchaseOutcomeKind.canceled:
        _busy = false;
        _pending = false;
      case PurchaseOutcomeKind.failed:
        _busy = false;
        _pending = false;
        _error = outcome.message ?? 'The purchase failed.';
      case PurchaseOutcomeKind.revoked:
        _owned = false;
    }
    notifyListeners();
  }

  String _describe(Object e) => e is StoreException ? e.message : e.toString();

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _service.dispose();
    super.dispose();
  }
}
