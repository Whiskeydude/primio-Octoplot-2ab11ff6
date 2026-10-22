import 'package:flutter/material.dart';

import '../../models/gobag_models.dart';
import '../../theme/theme.dart';
import '../common/glass_panel.dart';
import 'stage_card.dart';

class UndergroundTab extends StatelessWidget {
  final EscapeResult? result;
  final VoidCallback onRetry;
  final VoidCallback onMenu;

  const UndergroundTab({
    super.key,
    required this.result,
    required this.onRetry,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final r = result;

    if (r == null) {
      return Center(
        child: GlassPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_off_rounded, size: AppTheme.iconXl, color: appColors.subtleText),
              const SizedBox(height: AppTheme.spacingSm),
              Text('Nobody has gone underground yet.\nPack the bag and depart first.',
                  textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    final accent = r.vanished ? colors.tertiary : appColors.danger;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: AppTheme.spacingMd, bottom: AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            highlighted: true,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              children: [
                Icon(r.vanished ? Icons.nightlight_round : Icons.gavel_rounded, size: AppTheme.iconXl, color: accent),
                const SizedBox(height: AppTheme.spacingSm),
                Text(r.vanished ? 'You vanished' : 'Caught',
                    style: theme.textTheme.headlineSmall?.copyWith(color: accent)),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  r.vanished
                      ? 'The underground swallowed you whole. The octopus will plot again from the dark.'
                      : 'The net closed in before you reached safety. A better bag might have saved you.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          for (final leg in r.legs)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: StageCard(stage: leg.stage, have: leg.have, status: leg.status),
            ),
          const SizedBox(height: AppTheme.spacingSm),
          FilledButton(onPressed: onRetry, child: const Text('Pack a new bag')),
          const SizedBox(height: AppTheme.spacingSm),
          OutlinedButton(onPressed: onMenu, child: const Text('Main menu')),
        ],
      ),
    );
  }
}
