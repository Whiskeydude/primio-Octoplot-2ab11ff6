import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';
import '../common/glass_panel.dart';

class EventBanner extends StatelessWidget {
  final GameEvent? event;
  final int turn;

  const EventBanner({super.key, required this.event, required this.turn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final e = event;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) => SizeTransition(
        sizeFactor: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: e == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              key: ValueKey(turn),
              padding: const EdgeInsets.only(top: AppTheme.spacingSm),
              child: GlassPanel(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingSm),
                child: Row(
                  children: [
                    Icon(
                      e.isGood ? Icons.auto_awesome_rounded : Icons.warning_amber_rounded,
                      color: e.isGood ? appColors.success : appColors.danger,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title, style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(e.message, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
