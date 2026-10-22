import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../common/glass_panel.dart';
import 'paywall_benefit.dart';

class ClearancePaywall extends StatelessWidget {
  final String? price;
  final bool supported;
  final bool loading;
  final bool busy;
  final bool pending;
  final bool restoring;
  final String? error;
  final String? notice;
  final VoidCallback onBuy;
  final VoidCallback onRestore;
  final VoidCallback onRetry;

  const ClearancePaywall({
    super.key,
    required this.price,
    required this.supported,
    required this.loading,
    required this.busy,
    required this.pending,
    required this.restoring,
    required this.error,
    required this.notice,
    required this.onBuy,
    required this.onRestore,
    required this.onRetry,
  });

  String get _label {
    if (pending) return 'Waiting for payment approval...';
    if (busy) return 'Waiting for the store...';
    if (price != null) return 'Unlock for $price';
    if (loading) return 'Contacting the store...';
    return 'Unavailable right now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final canBuy = supported && price != null && !busy && !pending;

    return GlassPanel(
      highlighted: true,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.verified_user_rounded, size: AppTheme.iconXl, color: colors.tertiary),
          const SizedBox(height: AppTheme.spacingMd),
          Text('Top Secret Clearance',
              textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(color: colors.primary)),
          const SizedBox(height: AppTheme.spacingSm),
          Text('One purchase. No subscription. Yours for good.',
              textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppTheme.spacingLg),
          const PaywallBenefit(
            icon: Icons.layers_rounded,
            text: 'Opens the Vault: five layers of secrets, each hiding the next.',
          ),
          const PaywallBenefit(
            icon: Icons.visibility_rounded,
            text: 'Peel the onion to the core and learn who really runs Octoplot.',
          ),
          const PaywallBenefit(
            icon: Icons.restore_rounded,
            text: 'Restore it any time with the same Google Play or App Store account.',
          ),
          const SizedBox(height: AppTheme.spacingMd),
          FilledButton(onPressed: canBuy ? onBuy : null, child: Text(_label)),
          const SizedBox(height: AppTheme.spacingSm),
          TextButton(
            onPressed: supported && !restoring && !busy ? onRestore : null,
            child: Text(restoring ? 'Restoring...' : 'Restore purchases'),
          ),
          if (!supported) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Prices and purchases are available in the Android and iOS app. This preview cannot take payments.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Text(error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: appColors.danger)),
            if (price == null && !loading) TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
          if (notice != null) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Text(notice!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: appColors.success)),
          ],
        ],
      ),
    );
  }
}
