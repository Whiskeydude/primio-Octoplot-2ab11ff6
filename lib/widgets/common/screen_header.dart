import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const ScreenHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
