import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class OnionRings extends StatelessWidget {
  final int layers;
  final int peeled;

  const OnionRings({super.key, required this.layers, required this.peeled});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 400);

    return Semantics(
      label: '$peeled of $layers layers peeled',
      child: Center(
        child: LayoutBuilder(builder: (context, c) {
          final side = min(c.maxWidth, AppTheme.onionMaxSize);
          return SizedBox(
            width: side,
            height: side,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (var i = 0; i < layers; i++)
                  AnimatedContainer(
                    duration: duration,
                    width: side * (1 - i / layers * AppTheme.onionShrink),
                    height: side * (1 - i / layers * AppTheme.onionShrink),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < peeled
                          ? Colors.transparent
                          : i == peeled
                              ? colors.primaryContainer
                              : colors.surfaceContainerHigh,
                      border: Border.all(
                        color: i < peeled
                            ? colors.outlineVariant
                            : i == peeled
                                ? colors.primary
                                : colors.outline,
                        width: i == peeled ? AppTheme.borderThick : AppTheme.borderDefault,
                      ),
                    ),
                  ),
                Icon(
                  peeled >= layers ? Icons.visibility_rounded : Icons.lock_rounded,
                  size: AppTheme.iconXl,
                  color: peeled >= layers ? colors.tertiary : colors.onSurfaceVariant,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
