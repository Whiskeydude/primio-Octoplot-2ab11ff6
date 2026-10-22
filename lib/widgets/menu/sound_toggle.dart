import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class SoundToggle extends StatelessWidget {
  final bool muted;
  final String? error;
  final VoidCallback onToggle;
  final VoidCallback onRetry;

  const SoundToggle({
    super.key,
    required this.muted,
    required this.onToggle,
    required this.onRetry,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Column(
      children: [
        TextButton.icon(
          onPressed: onToggle,
          icon: Icon(muted ? Icons.volume_off_rounded : Icons.volume_up_rounded),
          label: Text(muted ? 'Sound & vibration: off' : 'Sound & vibration: on'),
        ),
        if (error != null)
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Sound off: $error Tap to retry.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: appColors.danger),
            ),
          ),
      ],
    );
  }
}
