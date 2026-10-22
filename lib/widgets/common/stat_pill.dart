import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;

  const StatPill({super.key, required this.icon, required this.label, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: AppTheme.spacingXs),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppTheme.iconSm, color: colors.tertiary),
            const SizedBox(width: AppTheme.spacingXs),
            Text(label, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
