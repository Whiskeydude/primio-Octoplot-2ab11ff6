import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool highlighted;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surfaceContainer.withValues(alpha: AppTheme.opacityGlass),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: highlighted ? colors.primary : colors.outlineVariant,
          width: highlighted ? AppTheme.borderSelected : AppTheme.borderDefault,
        ),
      ),
      child: child,
    );
  }
}
