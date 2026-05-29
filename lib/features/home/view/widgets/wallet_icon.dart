import 'package:flutter/material.dart';

class WalletIcon extends StatelessWidget {
  final double size;
  const WalletIcon({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _WalletPainter(), size: Size(size, size));
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;

    final bodyR = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, h * 0.22, w, h * 0.78),
      Radius.circular(w * 0.20),
    );
    canvas.drawRRect(
      bodyR,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE84D), Color(0xFFFFAA00)],
        ).createShader(bodyR.outerRect),
    );

    final flapR = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h * 0.52),
      Radius.circular(w * 0.20),
    );
    canvas.drawRRect(
      flapR,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        ).createShader(flapR.outerRect),
    );

    final bodyOver = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, h * 0.38, w, h * 0.62),
      Radius.circular(w * 0.20),
    );
    canvas.drawRRect(
      bodyOver,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE84D), Color(0xFFFFAA00)],
        ).createShader(bodyOver.outerRect),
    );

    final tp = TextPainter(
      text: TextSpan(
        text: '₹',
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.44,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((w - tp.width) / 2, h * 0.43));
  }

  @override
  bool shouldRepaint(_) => false;
}