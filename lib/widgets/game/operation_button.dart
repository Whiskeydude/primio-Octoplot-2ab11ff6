import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';

class OperationButton extends StatelessWidget {
  final Operation operation;
  final bool enabled;
  final VoidCallback onTap;

  const OperationButton({super.key, required this.operation, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final muted = colors.onSurface.withValues(alpha: AppTheme.opacityDisabled);

    Widget stat(IconData icon, String value, Color color) => Row(
          children: [
            Icon(icon, size: AppTheme.iconSm, color: enabled ? color : muted),
            const SizedBox(width: AppTheme.spacingXs),
            Flexible(
              child: Text(value,
                  style: theme.textTheme.labelMedium?.copyWith(color: enabled ? colors.onSurface : muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        );

    return Tooltip(
      message: operation.description,
      child: Material(
        color: enabled ? colors.surfaceContainerHighest : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(operation.name,
                    style: theme.textTheme.labelLarge?.copyWith(color: enabled ? colors.onSurface : muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppTheme.spacingXs),
                stat(Icons.trending_up_rounded, '+${operation.gain}', colors.tertiary),
                stat(Icons.local_fire_department_rounded, '+${operation.heat}', appColors.danger),
                stat(Icons.payments_rounded, operation.cost == 0 ? 'Free' : '${operation.cost}', appColors.warning),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
