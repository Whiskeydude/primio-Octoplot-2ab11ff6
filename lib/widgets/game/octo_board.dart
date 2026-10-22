import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';
import 'tentacle_node.dart';
import 'tentacle_painter.dart';

class OctoBoard extends StatefulWidget {
  final List<Tentacle> tentacles;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const OctoBoard({super.key, required this.tentacles, required this.selectedId, required this.onSelect});

  @override
  State<OctoBoard> createState() => _OctoBoardState();
}

class _OctoBoardState extends State<OctoBoard> with SingleTickerProviderStateMixin {
  late final AnimationController _wave =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final reduce = MediaQuery.disableAnimationsOf(context);

    return LayoutBuilder(builder: (context, c) {
      final side = c.biggest.shortestSide;
      final heroSize = side * AppTheme.boardHeroRatio;
      return Center(
        child: SizedBox.square(
          dimension: side,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: TentaclePainter(
                      animation: reduce ? const AlwaysStoppedAnimation(0.0) : _wave,
                      tentacles: widget.tentacles,
                      selectedId: widget.selectedId,
                      dimColor: appColors.inkDim,
                      glowColor: appColors.glow,
                      seizedColor: colors.primary,
                      suckerColor: colors.onSurface.withValues(alpha: AppTheme.opacityHint),
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/octo_mastermind.png',
                  width: heroSize,
                  height: heroSize,
                  fit: BoxFit.contain,
                  semanticLabel: 'The octopus mastermind',
                ),
              ),
              for (var i = 0; i < widget.tentacles.length; i++)
                Builder(builder: (context) {
                  final p = tentacleAnchor(i, widget.tentacles.length, side);
                  final t = widget.tentacles[i];
                  return Positioned(
                    left: p.dx - AppTheme.nodeLabelWidth / 2,
                    top: p.dy - AppTheme.nodeSize / 2,
                    width: AppTheme.nodeLabelWidth,
                    child: TentacleNode(
                      tentacle: t,
                      selected: t.id == widget.selectedId,
                      onTap: () => widget.onSelect(t.id),
                    ),
                  );
                }),
            ],
          ),
        ),
      );
    });
  }
}
