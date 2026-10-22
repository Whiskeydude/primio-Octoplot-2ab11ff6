import 'package:flutter/material.dart';

import '../../models/vault_models.dart';
import '../../theme/theme.dart';
import '../common/glass_panel.dart';

class SecretCard extends StatelessWidget {
  final int number;
  final VaultLayer layer;
  final VaultLayerState state;
  final VoidCallback onPeel;

  const SecretCard({
    super.key,
    required this.number,
    required this.layer,
    required this.state,
    required this.onPeel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final peeled = state == VaultLayerState.peeled;
    final current = state == VaultLayerState.current;

    return GlassPanel(
      highlighted: current,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                peeled
                    ? Icons.check_circle_rounded
                    : current
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                size: AppTheme.iconMd,
                color: peeled
                    ? colors.tertiary
                    : current
                        ? colors.primary
                        : appColors.subtleText,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text('Layer $number: ${layer.title}', style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          if (peeled) Text(layer.secret, style: theme.textTheme.bodyMedium),
          if (current) ...[
            Text('Clue: ${layer.clue}',
                style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
            const SizedBox(height: AppTheme.spacingMd),
            FilledButton.icon(
              onPressed: onPeel,
              icon: const Icon(Icons.layers_clear_rounded),
              label: const Text('Peel this layer'),
            ),
          ],
          if (state == VaultLayerState.sealed)
            Text('Sealed. Peel the layer above first.',
                style: theme.textTheme.bodySmall?.copyWith(color: appColors.subtleText)),
        ],
      ),
    );
  }
}
