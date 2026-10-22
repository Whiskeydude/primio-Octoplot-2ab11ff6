import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AbyssBackground extends StatelessWidget {
  const AbyssBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/abyss_bg.jpg', fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.surface.withValues(alpha: AppTheme.opacityBgTop),
                colors.surface.withValues(alpha: AppTheme.opacityBgBottom),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
