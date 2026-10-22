import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../common/glass_panel.dart';

class IntelLogHeader extends StatelessWidget {
  final String label;
  final int count;
  final bool open;
  final VoidCallback onToggle;

  const IntelLogHeader({
    super.key,
    required this.label,
    required this.count,
    required this.open,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingXs),
      highlighted: open,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              Icon(Icons.newspaper_rounded, size: AppTheme.iconMd, color: colors.tertiary),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (count > 0) Text('$count', style: theme.textTheme.labelMedium),
              AnimatedRotation(
                turns: open ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.expand_more_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
