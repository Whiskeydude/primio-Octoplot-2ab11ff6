import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../common/glass_panel.dart';
import '../common/stat_pill.dart';

class HudBar extends StatelessWidget {
  final int turn;
  final int funds;
  final int income;
  final int suspicion;
  final int seized;
  final int total;
  final VoidCallback onBack;

  const HudBar({
    super.key,
    required this.turn,
    required this.funds,
    required this.income,
    required this.suspicion,
    required this.seized,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final value = (suspicion / 100).clamp(0.0, 1.0);
    final meterColor = Color.lerp(appColors.warning, appColors.danger, value)!;

    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spacingXs, AppTheme.spacingXs, AppTheme.spacingMd, AppTheme.spacingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: onBack, tooltip: 'Back to menu', icon: const Icon(Icons.arrow_back_rounded)),
              Expanded(
                child: Text('Night $turn',
                    style: theme.textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              StatPill(icon: Icons.payments_rounded, label: '$funds +$income', tooltip: 'Funds and income per night'),
              const SizedBox(width: AppTheme.spacingSm),
              StatPill(icon: Icons.hub_rounded, label: '$seized/$total', tooltip: 'Tentacles fully seized'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility_rounded, size: AppTheme.iconSm, color: meterColor),
                    const SizedBox(width: AppTheme.spacingXs),
                    Expanded(child: Text('Public suspicion', style: theme.textTheme.labelMedium)),
                    Text('$suspicion%', style: theme.textTheme.labelLarge?.copyWith(color: meterColor)),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: value),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: AppTheme.meterHeight,
                      color: meterColor,
                      backgroundColor: colors.surfaceContainerHighest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
