import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  static const _rules = [
    (Icons.touch_app_rounded, 'Tap a tentacle, then pick a secret operation to tighten its grip.'),
    (Icons.local_fire_department_rounded, 'Every operation adds heat. At 100% suspicion you are exposed.'),
    (Icons.nightlight_round, 'Lie low to cool things down. Every seized tentacle also calms the public each night.'),
    (Icons.live_tv_rounded, 'Seize the Media and all future heat is halved.'),
    (Icons.public_rounded, 'Bring all ten tentacles to 100% in as few nights as possible.'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('How to plot'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (icon, text) in _rules)
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: theme.colorScheme.tertiary, size: AppTheme.iconMd),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Got it')),
      ],
    );
  }
}
