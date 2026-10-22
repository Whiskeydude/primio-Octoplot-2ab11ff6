import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';

IconData tentacleIcon(String key) {
  switch (key) {
    case 'media':
      return Icons.live_tv_rounded;
    case 'banking':
      return Icons.account_balance_rounded;
    case 'tech':
      return Icons.memory_rounded;
    case 'politics':
      return Icons.how_to_vote_rounded;
    case 'pharma':
      return Icons.medication_rounded;
    case 'military':
      return Icons.shield_rounded;
    case 'weather':
      return Icons.thunderstorm_rounded;
    case 'food':
      return Icons.restaurant_rounded;
    case 'space':
      return Icons.rocket_launch_rounded;
    default:
      return Icons.school_rounded;
  }
}

class TentacleNode extends StatelessWidget {
  final Tentacle tentacle;
  final bool selected;
  final VoidCallback onTap;

  const TentacleNode({super.key, required this.tentacle, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final ringColor = tentacle.isSeized ? colors.primary : colors.tertiary;

    return Tooltip(
      message: '${tentacle.name} · ${tentacle.control}% grip',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: selected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: SizedBox.square(
              dimension: AppTheme.nodeSize,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: tentacle.control / 100),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) => CircularProgressIndicator(
                      value: v,
                      strokeWidth: AppTheme.ringWidth,
                      color: ringColor,
                      backgroundColor: colors.surfaceContainerHighest,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.ringWidth + 1),
                    child: Material(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: selected ? colors.primary : Colors.transparent,
                          width: AppTheme.borderThick,
                        ),
                      ),
                      color: tentacle.isSeized ? colors.primaryContainer : colors.surfaceContainerHigh,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onTap,
                        child: Icon(
                          tentacleIcon(tentacle.iconKey),
                          size: AppTheme.iconMd,
                          color: tentacle.isSeized ? colors.onPrimaryContainer : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            tentacle.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected ? colors.primary : colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
