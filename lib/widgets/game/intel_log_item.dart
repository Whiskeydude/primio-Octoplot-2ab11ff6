import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';

class IntelLogItem extends StatelessWidget {
  final LogEntry entry;

  const IntelLogItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final toneColor = switch (entry.tone) {
      LogTone.good => appColors.success,
      LogTone.bad => appColors.danger,
      LogTone.neutral => colors.primary,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NIGHT ${entry.turn} · ${entry.title}',
          style: theme.textTheme.labelLarge?.copyWith(color: toneColor),
        ),
        if (entry.headline.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            '“${entry.headline}”',
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: AppTheme.spacingXs),
        Text(entry.detail, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
