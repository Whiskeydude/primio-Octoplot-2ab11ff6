import 'package:flutter/material.dart';

import '../../models/gobag_models.dart';
import '../../theme/theme.dart';
import '../common/glass_panel.dart';
import 'tag_style.dart';

class BagItemTile extends StatelessWidget {
  final BagItem item;
  final bool packed;
  final bool enabled;
  final VoidCallback onTap;

  const BagItemTile({
    super.key,
    required this.item,
    required this.packed,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final fg = enabled ? colors.onSurface : colors.onSurface.withValues(alpha: AppTheme.opacityDisabled);
    final detail = item.power == 0
        ? 'Sentimental only · weight ${item.weight}'
        : '${bagTagLabel(item.tag)} +${item.power} · weight ${item.weight}';

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: GlassPanel(
        highlighted: packed,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingSm),
        child: Row(
          children: [
            Icon(bagTagIcon(item.tag), size: AppTheme.iconMd, color: packed ? colors.tertiary : fg),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: theme.textTheme.titleMedium?.copyWith(color: fg)),
                  Text(detail, style: theme.textTheme.bodySmall?.copyWith(color: fg)),
                ],
              ),
            ),
            Icon(
              packed ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
              color: packed ? colors.tertiary : fg,
            ),
          ],
        ),
      ),
    );
  }
}
