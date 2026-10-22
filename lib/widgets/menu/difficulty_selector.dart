import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';

class DifficultySelector extends StatelessWidget {
  final Difficulty selected;
  final ValueChanged<Difficulty> onChanged;
  final String? error;

  const DifficultySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<Difficulty>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
          ),
          segments: [
            for (final d in Difficulty.values)
              ButtonSegment(
                value: d,
                label: Text(d.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
          selected: {selected},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          '${selected.description}\n${selected.summary}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
        if (error != null) ...[
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            error!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: appColors.danger),
          ),
        ],
      ],
    );
  }
}
