import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/responsive_layout.dart';
import '../../theme/theme.dart';
import 'dossier_bonus_card.dart';
import 'dossier_target_row.dart';
import 'tentacle_node.dart';

class DossierSheet extends StatelessWidget {
  final Tentacle tentacle;
  final Dossier dossier;

  const DossierSheet({super.key, required this.tentacle, required this.dossier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final count = dossier.targets.length;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        0,
        AppTheme.spacingMd,
        AppTheme.spacingMd + MediaQuery.paddingOf(context).bottom,
      ),
      child: ResponsiveLayout.constrain(
        maxWidth: AppTheme.dialogMaxWidth,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(tentacleIcon(tentacle.iconKey), size: AppTheme.iconLg, color: colors.tertiary),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tentacle.name, style: theme.textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(tentacle.domain, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Text('${tentacle.control}%', style: theme.textTheme.titleLarge?.copyWith(color: colors.tertiary)),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              child: LinearProgressIndicator(
                value: tentacle.control / 100,
                minHeight: AppTheme.meterHeight,
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text('LORE', style: theme.textTheme.labelMedium),
            const SizedBox(height: AppTheme.spacingXs),
            Text(dossier.lore, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppTheme.spacingMd),
            Text('INFILTRATION TARGETS', style: theme.textTheme.labelMedium),
            const SizedBox(height: AppTheme.spacingXs),
            for (var i = 0; i < count; i++)
              DossierTargetRow(
                label: dossier.targets[i],
                threshold: ((i + 1) * 100 / count).round(),
                reached: tentacle.control >= ((i + 1) * 100 / count).round(),
              ),
            const SizedBox(height: AppTheme.spacingMd),
            Text('SEIZED BONUS', style: theme.textTheme.labelMedium),
            const SizedBox(height: AppTheme.spacingSm),
            DossierBonusCard(
              name: dossier.bonusName,
              text: dossier.bonusText,
              active: tentacle.isSeized,
            ),
          ],
        ),
      ),
    );
  }
}
