import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../common/glass_panel.dart';

class EndOverlay extends StatelessWidget {
  final bool won;
  final int turns;
  final int? best;
  final VoidCallback onRestart;
  final VoidCallback onMenu;
  final VoidCallback? onGoBag;

  const EndOverlay({
    super.key,
    required this.won,
    required this.turns,
    required this.best,
    required this.onRestart,
    required this.onMenu,
    this.onGoBag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final accent = won ? colors.tertiary : appColors.danger;

    return ColoredBox(
      color: appColors.scrim,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: ResponsiveLayoutBox(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutBack,
                builder: (context, s, child) => Transform.scale(scale: s, child: child),
                child: GlassPanel(
                  highlighted: true,
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(won ? Icons.public_rounded : Icons.campaign_rounded, size: AppTheme.iconXl, color: accent),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(won ? 'The world is yours' : 'Exposed!',
                          textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(color: accent)),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        won
                            ? 'All ten tentacles tightened their grip in $turns nights.'
                            : 'The public pieced it together on night $turns. The octopus retreats to the deep.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (best != null) ...[
                        const SizedBox(height: AppTheme.spacingSm),
                        Text('Best on this device: $best nights',
                            textAlign: TextAlign.center, style: theme.textTheme.labelMedium),
                      ],
                      const SizedBox(height: AppTheme.spacingLg),
                      FilledButton(onPressed: onRestart, child: const Text('Plot again')),
                      const SizedBox(height: AppTheme.spacingSm),
                      if (!won && onGoBag != null) ...[
                        OutlinedButton.icon(
                          onPressed: onGoBag,
                          icon: const Icon(Icons.backpack_rounded),
                          label: const Text('Grab the go-bag'),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                      ],
                      OutlinedButton(onPressed: onMenu, child: const Text('Main menu')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResponsiveLayoutBox extends StatelessWidget {
  final Widget child;
  const ResponsiveLayoutBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTheme.dialogMaxWidth),
        child: child,
      );
}
