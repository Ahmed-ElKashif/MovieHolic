import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MovieHolicLogo extends StatelessWidget {
  final double size;
  const MovieHolicLogo({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // --- 1. THE PAINTS ---

    // Ambient Red Glow behind everything
    final redGlow = Paint()
      ..color = const Color(0xFFE50914).withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    // Deep Shadow for 3D depth
    final shadowStroke = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Silver/Metallic Gradient for the Left Film Strip
    final leftPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.2, h * 0.2),
        Offset(w * 0.5, h * 0.8),
        [const Color(0xFFFFFFFF), const Color(0xFF9E9E9E)],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Darker Silver/Metallic Gradient for the Right Film Strip
    final rightPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.8, h * 0.2),
        Offset(w * 0.5, h * 0.8),
        [const Color(0xFFE0E0E0), const Color(0xFF616161)],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Cinematic Red Gradient for the Play Button
    final playFill = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.4, h * 0.2),
        Offset(w * 0.65, h * 0.35),
        [
          const Color(0xFFFF4D4D),
          const Color(0xFFE50914),
        ], // Vibrant red to deep red
      )
      ..style = PaintingStyle.fill;

    // Stroke for the Play Button to perfectly round off the sharp triangle corners
    final playStroke = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04
      ..strokeJoin = StrokeJoin.round;

    // --- 2. THE PATHS ---

    // Left 'M' Pillar
    final leftM = Path()
      ..moveTo(w * 0.2, h * 0.85)
      ..lineTo(w * 0.2, h * 0.25)
      ..lineTo(w * 0.5, h * 0.65);

    // Right 'M' Pillar
    final rightM = Path()
      ..moveTo(w * 0.8, h * 0.85)
      ..lineTo(w * 0.8, h * 0.25)
      ..lineTo(w * 0.5, h * 0.65);

    // Center Play Triangle
    final playPath = Path()
      ..moveTo(w * 0.42, h * 0.22) // Top left
      ..lineTo(w * 0.42, h * 0.48) // Bottom left
      ..lineTo(w * 0.65, h * 0.35) // Center right point
      ..close();

    // --- 3. THE CANVAS DRAWING (Order matters for overlapping) ---

    // Draw the ambient red studio glow
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.25, redGlow);

    // Draw Right Pillar (Background layer)
    canvas.drawPath(rightM.shift(Offset(0, h * 0.02)), shadowStroke); // Shadow
    canvas.drawPath(rightM, rightPaint); // Metallic Body

    // Draw Left Pillar (Foreground layer, overlapping the right)
    canvas.drawPath(leftM.shift(Offset(0, h * 0.02)), shadowStroke); // Shadow
    canvas.drawPath(leftM, leftPaint); // Metallic Body

    // Draw Film Holes (Fake punch-outs using the Obsidian Background Color)
    final holePaint = Paint()..color = const Color(0xFF131313);
    final double holeR = w * 0.01;
    final double holeW = w * 0.04;
    final double holeH = h * 0.05;

    void drawFilmHoles(double x) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, h * 0.45),
            width: holeW,
            height: holeH,
          ),
          Radius.circular(holeR),
        ),
        holePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, h * 0.60),
            width: holeW,
            height: holeH,
          ),
          Radius.circular(holeR),
        ),
        holePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, h * 0.75),
            width: holeW,
            height: holeH,
          ),
          Radius.circular(holeR),
        ),
        holePaint,
      );
    }

    drawFilmHoles(w * 0.2); // Punch left side
    drawFilmHoles(w * 0.8); // Punch right side

    // Draw Glowing Play Button (Nestled in the V of the M)
    final shadowFill = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(
      playPath.shift(Offset(0, h * 0.015)),
      shadowFill,
    ); // Drop shadow
    canvas.drawPath(playPath, playStroke); // Outer rounded border
    canvas.drawPath(playPath, playFill); // Inner gradient fill
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
