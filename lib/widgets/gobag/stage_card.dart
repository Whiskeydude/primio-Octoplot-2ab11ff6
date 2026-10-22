import 'package:flutter/material.dart';

import '../../models/gobag_models.dart';
import '../../theme/theme.dart';
import '../common/glass_panel.dart';
import 'tag_style.dart';

class StageCard extends StatelessWidget {
  final EscapeStage stage;
  final int have;
  final StageStatus status;

  const StageCard({super.key, required this.stage, required this.have, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final label = bagTagLabel(stage.tag);
    final enough = have >= stage.need;

    final (color, icon) = switch (status) {
      StageStatus.passed => (appColors.success, Icons.check_circle_rounded),
      StageStatus.failed => (appColors.danger, Icons.cancel_rounded),
      StageStatus.unreached => (appColors.subtleText, Icons.remove_circle_outline_rounded),
      StageStatus.planning =>
        enough ? (appColors.success, Icons.shield_rounded) : (colors.onSurfaceVariant, bagTagIcon(stage.tag)),
    };

    final detail = switch (status) {
      StageStatus.passed => 'Cleared with $label $have (needed ${stage.need}).',
      StageStatus.failed => 'Not enough $label: needed ${stage.need}, carried $have.',
      StageStatus.unreached => 'Never reached.',
      StageStatus.planning => 'Needs $label ${stage.need} · packed $have',
    };

    return GlassPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppTheme.iconMd, color: color),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stage.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppTheme.spacingXs),
                Text(stage.story, style: theme.textTheme.bodySmall),
                const SizedBox(height: AppTheme.spacingXs),
                Text(detail, style: theme.textTheme.labelLarge?.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
