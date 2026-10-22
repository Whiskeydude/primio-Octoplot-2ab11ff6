import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';
import 'intel_log_item.dart';

class IntelLogList extends StatelessWidget {
  final List<LogEntry> entries;

  const IntelLogList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Text(
                  'No intel yet. Make your first move.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              itemCount: entries.length,
              separatorBuilder: (_, __) => Divider(height: AppTheme.spacingLg, color: colors.outlineVariant),
              itemBuilder: (_, i) => IntelLogItem(entry: entries[i]),
            ),
    );
  }
}
