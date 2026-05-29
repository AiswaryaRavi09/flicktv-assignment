import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiPiece {
  final double nx;
  final double speed;
  final double delay;
  final Color  color;
  final double w, h;
  final double angle0;
  final double spin;

  const ConfettiPiece({
    required this.nx,
    required this.speed,
    required this.delay,
    required this.color,
    required this.w,
    required this.h,
    required this.angle0,
    required this.spin,
  });
}

/// [nxOffset] biases horizontal direction: positive → rightward, negative → leftward.
List<ConfettiPiece> makeConfettiPieces(int n, {int seed = 7, double nxOffset = 0.0}) {
  final rng = math.Random(seed);
  const colors = [
    Color(0xFFFF5252), Color(0xFF448AFF), Color(0xFF69F0AE),
    Color(0xFFFFD740), Color(0xFFFF6EC7), Color(0xFF40C4FF),
    Color(0xFFFF6D00), Color(0xFFB388FF),
  ];
  return List.generate(n, (_) => ConfettiPiece(
    nx:     (nxOffset + (rng.nextDouble() - 0.5) * 2.4).clamp(-3.0, 3.0),
    speed:  0.30 + rng.nextDouble() * 0.90,
    delay:  rng.nextDouble() * 0.40,
    color:  colors[rng.nextInt(colors.length)],
    w:      7 + rng.nextDouble() * 8,
    h:      4 + rng.nextDouble() * 3,
    angle0: rng.nextDouble() * math.pi * 2,
    spin:   (rng.nextDouble() - 0.5) * 12,
  ));
}

class ConfettiBurstPainter extends CustomPainter {
  final double t;
  final double durationSec;
  final List<ConfettiPiece> pieces;
  final double originNx;
  final double originNy;

  static const double _g = 1.1;

  const ConfettiBurstPainter({
    required this.t,
    required this.durationSec,
    required this.pieces,
    this.originNx = 0.5,
    this.originNy = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ox = originNx * size.width;
    final oy = originNy * size.height;
    final paint = Paint();

    for (final p in pieces) {
      final ts = t * durationSec - p.delay;
      if (ts <= 0) continue;

      final vx = p.nx * size.width * 0.20;
      final x  = ox + vx * ts;
      final y  = oy
          - p.speed * size.height * ts
          + 0.5 * _g * size.height * ts * ts;

      if (y > size.height + 24) continue;
      if (x < -24 || x > size.width + 24) continue;

      paint.color = p.color.withValues(alpha: 0.90);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.angle0 + ts * p.spin);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.w, height: p.h),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiBurstPainter old) => old.t != t;
}