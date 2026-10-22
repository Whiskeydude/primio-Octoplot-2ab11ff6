import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../common/glass_panel.dart';

class DossierBonusCard extends StatelessWidget {
  final String name;
  final String text;
  final bool active;

  const DossierBonusCard({
    super.key,
    required this.name,
    required this.text,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GlassPanel(
      highlighted: active,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: active ? colors.tertiary : colors.onSurfaceVariant),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(child: Text(name, style: theme.textTheme.titleMedium)),
              Text(
                active ? 'ACTIVE' : 'LOCKED',
                style: theme.textTheme.labelMedium?.copyWith(color: active ? colors.tertiary : null),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(text, style: theme.textTheme.bodyMedium),
          if (!active) ...[
            const SizedBox(height: AppTheme.spacingXs),
            Text('Unlocks when this tentacle is fully seized.', style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
