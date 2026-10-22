import 'package:flutter/material.dart';

import '../../models/gobag_models.dart';
import '../../theme/theme.dart';
import 'bag_item_tile.dart';
import 'capacity_meter.dart';
import 'stage_card.dart';

class PackTab extends StatelessWidget {
  final List<EscapeStage> route;
  final List<BagItem> items;
  final int capacity;
  final int weight;
  final int Function(BagTag) powerFor;
  final bool Function(String) isPacked;
  final bool Function(BagItem) canPack;
  final ValueChanged<BagItem> onToggle;
  final VoidCallback onDepart;

  const PackTab({
    super.key,
    required this.route,
    required this.items,
    required this.capacity,
    required this.weight,
    required this.powerFor,
    required this.isPacked,
    required this.canPack,
    required this.onToggle,
    required this.onDepart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: AppTheme.spacingMd, bottom: AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Exposed!', style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'The world knows your name. Pack light, cover every stage of the route, and vanish underground.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text('The route underground', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingSm),
          for (final stage in route)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: StageCard(stage: stage, have: powerFor(stage.tag), status: StageStatus.planning),
            ),
          const SizedBox(height: AppTheme.spacingSm),
          CapacityMeter(used: weight, capacity: capacity),
          const SizedBox(height: AppTheme.spacingMd),
          Text('Your gear', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingSm),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: BagItemTile(
                item: item,
                packed: isPacked(item.id),
                enabled: canPack(item),
                onTap: () => onToggle(item),
              ),
            ),
          const SizedBox(height: AppTheme.spacingSm),
          FilledButton.icon(
            onPressed: weight > 0 ? onDepart : null,
            icon: const Icon(Icons.visibility_off_rounded),
            label: const Text('Go underground'),
          ),
        ],
      ),
    );
  }
}
