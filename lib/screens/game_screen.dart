import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/game_models.dart';
import '../providers/game/game_provider.dart';
import '../theme/responsive_layout.dart';
import '../theme/theme.dart';
import '../widgets/common/abyss_background.dart';
import '../widgets/game/command_dock.dart';
import '../widgets/game/dossier_sheet.dart';
import '../widgets/game/end_overlay.dart';
import '../widgets/game/event_banner.dart';
import '../widgets/game/hud_bar.dart';
import '../widgets/game/intel_log_panel.dart';
import '../widgets/game/octo_board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final state = game.state;
    final theme = Theme.of(context);

    void openDossier() {
      final t = game.selected;
      if (t == null) return;
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => DossierSheet(tentacle: t, dossier: game.dossierFor(t.id)),
      );
    }

    final hud = HudBar(
      turn: state.turn,
      funds: state.funds,
      income: game.income,
      suspicion: state.suspicion,
      seized: state.seizedCount,
      total: state.tentacles.length,
      onBack: () => context.pop(),
    );
    final banner = EventBanner(event: state.lastEvent, turn: state.turn);
    final board = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
      child: OctoBoard(tentacles: state.tentacles, selectedId: game.selectedId, onSelect: game.select),
    );
    final boardWithLog = IntelLogPanel(entries: state.log, child: board);
    final dock = CommandDock(
      selected: game.selected,
      operations: game.operations,
      funds: state.funds,
      onOperation: game.runOperation,
      onLieLow: game.lieLow,
      onDossier: openDossier,
      lieLowAmount: game.lieLowAmount,
    );

    return Scaffold(
      body: AnnotatedRegion(
        value: theme.appBarTheme.systemOverlayStyle!,
        child: Stack(
          children: [
            const Positioned.fill(child: AbyssBackground()),
            SafeArea(
              child: Padding(
                padding: ResponsiveLayout.getPadding(context),
                child: LayoutBuilder(builder: (context, c) {
                  final wide = c.maxWidth > c.maxHeight * 1.2;
                  if (wide) {
                    return Row(
                      children: [
                        Expanded(flex: 5, child: boardWithLog),
                        const SizedBox(width: AppTheme.spacingMd),
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: Column(children: [hud, banner, const SizedBox(height: AppTheme.spacingSm), dock]),
                          ),
                        ),
                      ],
                    );
                  }
                  return ResponsiveLayout.constrain(
                    Column(children: [hud, banner, Expanded(child: boardWithLog), dock]),
                  );
                }),
              ),
            ),
            if (state.status != GameStatus.playing)
              Positioned.fill(
                child: EndOverlay(
                  won: state.status == GameStatus.won,
                  turns: state.turn,
                  best: game.best,
                  onRestart: game.restart,
                  onMenu: () => context.pop(),
                  onGoBag: () => context.push('/gobag'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
