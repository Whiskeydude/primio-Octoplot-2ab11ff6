import 'package:flutter/material.dart';

import '../../models/vault_models.dart';
import '../../theme/theme.dart';
import 'onion_rings.dart';
import 'secret_card.dart';

class OnionView extends StatelessWidget {
  final List<VaultLayer> layers;
  final int peeled;
  final String? error;
  final VoidCallback onPeel;

  const OnionView({
    super.key,
    required this.layers,
    required this.peeled,
    required this.error,
    required this.onPeel,
  });

  VaultLayerState _stateOf(int i) {
    if (i < peeled) return VaultLayerState.peeled;
    if (i == peeled) return VaultLayerState.current;
    return VaultLayerState.sealed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnionRings(layers: layers.length, peeled: peeled),
        const SizedBox(height: AppTheme.spacingMd),
        Text(
          peeled >= layers.length
              ? 'Every layer peeled. You know it all.'
              : '$peeled of ${layers.length} layers peeled',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge,
        ),
        if (error != null) ...[
          const SizedBox(height: AppTheme.spacingSm),
          Text(error!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: appColors.danger)),
        ],
        const SizedBox(height: AppTheme.spacingMd),
        for (var i = 0; i < layers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
            child: SecretCard(number: i + 1, layer: layers[i], state: _stateOf(i), onPeel: onPeel),
          ),
      ],
    );
  }
}
