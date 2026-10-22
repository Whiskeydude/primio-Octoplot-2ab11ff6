import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class PaywallBenefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const PaywallBenefit({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppTheme.iconMd, color: theme.colorScheme.tertiary),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
