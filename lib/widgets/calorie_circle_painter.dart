import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalorieCirclePainter extends CustomPainter {
  final double usedCaloriesFraction; // Anteil der genutzten Kalorien
  final double bonusCaloriesFraction; // Anteil der Bonus-Kalorien

  CalorieCirclePainter(this.usedCaloriesFraction, this.bonusCaloriesFraction);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 10.0;

    // Hintergrundkreis (Ziel-Kalorien)
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Berechne die Winkel für die Kreise
    const startAngle = -math.pi / 2; // Start bei 12 Uhr (90 Grad nach links)
    final bonusSweepAngle = -bonusCaloriesFraction * 2 * math.pi; // Gegen Uhrzeigersinn
    final usedSweepAngle = usedCaloriesFraction * 2 * math.pi; // Im Uhrzeigersinn

    // Blauer Kreis (Bonus-Kalorien, gegen Uhrzeigersinn)
    final bonusPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      bonusSweepAngle,
      false,
      bonusPaint,
    );

    // Grüner Kreis (Genutzte Kalorien, im Uhrzeigersinn)
    final usedPaint = Paint()
      ..color = const Color.fromARGB(255, 86, 231, 146)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Berechne, wie viel der grüne Kreis den blauen überdecken soll
    double usedOverBonus = usedCaloriesFraction - bonusCaloriesFraction;
    if (usedOverBonus > 0) {
      // Wenn die genutzten Kalorien die Bonus-Kalorien überschreiten,
      // zeichne den grünen Kreis über den gesamten Bereich
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        usedSweepAngle,
        false,
        usedPaint,
      );
    } else {
      // Sonst zeichne den grünen Kreis nur bis zu seinem Anteil
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        usedSweepAngle,
        false,
        usedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}