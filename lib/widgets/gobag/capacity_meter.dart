import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CapacityMeter extends StatelessWidget {
  final int used;
  final int capacity;

  const CapacityMeter({super.key, required this.used, required this.capacity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final full = used >= capacity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Bag space: $used of $capacity', style: theme.textTheme.labelLarge),
        const SizedBox(height: AppTheme.spacingSm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          child: LinearProgressIndicator(
            value: capacity == 0 ? 0 : used / capacity,
            minHeight: AppTheme.meterHeight,
            color: full ? appColors.warning : colors.tertiary,
            backgroundColor: appColors.inkDim,
          ),
        ),
      ],
    );
  }
}
