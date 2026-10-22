import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class DossierTargetRow extends StatelessWidget {
  final String label;
  final int threshold;
  final bool reached;

  const DossierTargetRow({
    super.key,
    required this.label,
    required this.threshold,
    required this.reached,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXs),
      child: Row(
        children: [
          Icon(
            reached ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: AppTheme.iconMd,
            color: reached ? colors.tertiary : colors.outline,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: reached ? colors.onSurface : colors.onSurfaceVariant,
              ),
            ),
          ),
          Text('$threshold%', style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}
