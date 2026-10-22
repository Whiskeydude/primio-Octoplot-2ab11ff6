import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';

/// Centre of the node for tentacle [index] on a square board of [side].
Offset tentacleAnchor(int index, int count, double side) {
  final angle = -pi / 2 + index * 2 * pi / count;
  final r = side * AppTheme.boardOrbitRatio;
  return Offset(side / 2 + cos(angle) * r, side / 2 + sin(angle) * r);
}

class TentaclePainter extends CustomPainter {
  final Animation<double> animation;
  final List<Tentacle> tentacles;
  final String? selectedId;
  final Color dimColor;
  final Color glowColor;
  final Color seizedColor;
  final Color suckerColor;

  TentaclePainter({
    required this.animation,
    required this.tentacles,
    required this.selectedId,
    required this.dimColor,
    required this.glowColor,
    required this.seizedColor,
    required this.suckerColor,
  }) : super(repaint: animation);

  static Offset _cubic(Offset a, Offset b, Offset c, Offset d, double t) {
    final u = 1 - t;
    return a * (u * u * u) + b * (3 * u * u * t) + c * (3 * u * t * t) + d * (t * t * t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final center = Offset(side / 2, side / 2);
    final phase = animation.value * 2 * pi;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final sucker = Paint()..color = suckerColor;

    for (var i = 0; i < tentacles.length; i++) {
      final t = tentacles[i];
      final end = tentacleAnchor(i, tentacles.length, side);
      final dir = (end - center) / (end - center).distance;
      final start = center + dir * side * 0.08;
      final perp = Offset(-dir.dy, dir.dx);
      final amp = side * 0.05;
      final c1 = Offset.lerp(start, end, 0.33)! + perp * (amp * sin(phase + i));
      final c2 = Offset.lerp(start, end, 0.66)! + perp * (-amp * sin(phase + i + 1.3));

      final progress = t.control / 100;
      final selected = t.id == selectedId;
      final color = t.isSeized ? seizedColor : Color.lerp(dimColor, glowColor, progress)!;
      final baseWidth = side * (0.03 + 0.025 * progress) * (selected ? 1.3 : 1.0);

      const segments = 18;
      // Soft halo pass for active tentacles
      if (selected || t.isSeized) {
        var prev = start;
        line.color = color.withValues(alpha: AppTheme.opacitySoft);
        for (var k = 1; k <= segments; k++) {
          final p = _cubic(start, c1, c2, end, k / segments);
          line.strokeWidth = baseWidth * 2.2 * (1 - 0.6 * k / segments);
          canvas.drawLine(prev, p, line);
          prev = p;
        }
      }

      var prev = start;
      line.color = color;
      for (var k = 1; k <= segments; k++) {
        final f = k / segments;
        final p = _cubic(start, c1, c2, end, f);
        final w = baseWidth * (1 - 0.65 * f);
        line.strokeWidth = w;
        canvas.drawLine(prev, p, line);
        if (k % 3 == 0 && t.control > 0) canvas.drawCircle(p, w * 0.22, sucker);
        prev = p;
      }
    }
  }

  @override
  bool shouldRepaint(covariant TentaclePainter old) =>
      old.tentacles != tentacles || old.selectedId != selectedId || old.glowColor != glowColor;
}
