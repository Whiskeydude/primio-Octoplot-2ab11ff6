import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/app/purchase_provider.dart';
import '../providers/vault/vault_provider.dart';
import '../theme/responsive_layout.dart';
import '../theme/theme.dart';
import '../widgets/common/abyss_background.dart';
import '../widgets/common/screen_header.dart';
import '../widgets/vault/clearance_paywall.dart';
import '../widgets/vault/onion_view.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final purchases = context.watch<PurchaseProvider>();
    final vault = context.watch<VaultProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: AnnotatedRegion(
        value: theme.appBarTheme.systemOverlayStyle!,
        child: Stack(
          children: [
            const Positioned.fill(child: AbyssBackground()),
            SafeArea(
              child: Padding(
                padding: ResponsiveLayout.getPadding(context),
                child: ResponsiveLayout.constrain(
                  Column(
                    children: [
                      ScreenHeader(title: 'Top Secret Vault', onBack: () => context.pop()),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
                          child: purchases.owned
                              ? OnionView(
                                  layers: vault.layers,
                                  peeled: vault.peeled,
                                  error: vault.error,
                                  onPeel: vault.peelNext,
                                )
                              : ClearancePaywall(
                                  price: purchases.price,
                                  supported: purchases.supported,
                                  loading: purchases.loading,
                                  busy: purchases.busy,
                                  pending: purchases.pending,
                                  restoring: purchases.restoring,
                                  error: purchases.error,
                                  notice: purchases.notice,
                                  onBuy: purchases.buy,
                                  onRestore: purchases.restore,
                                  onRetry: purchases.retry,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
