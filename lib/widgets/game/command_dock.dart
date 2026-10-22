import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';
import '../common/glass_panel.dart';
import 'operation_button.dart';
import 'tentacle_node.dart';

class CommandDock extends StatelessWidget {
  final Tentacle? selected;
  final List<Operation> operations;
  final int funds;
  final ValueChanged<Operation> onOperation;
  final VoidCallback onLieLow;
  final VoidCallback onDossier;
  final int lieLowAmount;

  const CommandDock({
    super.key,
    required this.selected,
    required this.operations,
    required this.funds,
    required this.onOperation,
    required this.onLieLow,
    required this.onDossier,
    required this.lieLowAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final t = selected;

    return GlassPanel(
      highlighted: t != null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: t == null
                ? Text(
                    'Tap a tentacle to plot your next move.',
                    key: const ValueKey('hint'),
                    style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  )
                : Row(
                    key: ValueKey(t.id),
                    children: [
                      Icon(tentacleIcon(t.iconKey), color: colors.tertiary),
                      const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(t.domain, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Text('${t.control}%', style: theme.textTheme.titleLarge?.copyWith(color: colors.tertiary)),
                      IconButton(
                        onPressed: onDossier,
                        tooltip: 'Open dossier',
                        icon: const Icon(Icons.assignment_ind_rounded),
                      ),
                    ],
                  ),
          ),
          if (t != null) ...[
            const SizedBox(height: AppTheme.spacingSm),
            if (t.isSeized)
              Text('Fully seized. This tentacle now works for you.', style: theme.textTheme.bodySmall)
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < operations.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: OperationButton(
                          operation: operations[i],
                          enabled: funds >= operations[i].cost,
                          onTap: () => onOperation(operations[i]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
          const SizedBox(height: AppTheme.spacingSm),
          OutlinedButton.icon(
            onPressed: onLieLow,
            icon: const Icon(Icons.nightlight_round),
            label: Text('Lie low  (-$lieLowAmount suspicion)'),
          ),
        ],
      ),
    );
  }
}
