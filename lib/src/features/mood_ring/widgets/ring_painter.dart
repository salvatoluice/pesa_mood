import 'dart:math';
import 'package:flutter/material.dart';

class FinancialMoodPainter extends CustomPainter {
  final double savingsProgress;
  final double billsProgress;
  final double splurgeProgress;
  final Animation<double> pulseAnimation;
  final Animation<double> particleAnimation;

  late TextPainter _savingsLabelPainter;
  late TextPainter _billsLabelPainter;
  late TextPainter _splurgeLabelPainter;

  FinancialMoodPainter({
    required this.savingsProgress,
    required this.billsProgress,
    required this.splurgeProgress,
    required this.pulseAnimation,
    required this.particleAnimation,
  }) {
    _savingsLabelPainter = _createTextPainter('SAVINGS');
    _billsLabelPainter = _createTextPainter('BILLS');
    _splurgeLabelPainter = _createTextPainter('SPLURGE');
  }

  TextPainter _createTextPainter(String text) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 1))
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    const segmentWidth = 24.0;

    _draw3DBaseShadow(canvas, center, radius, segmentWidth);

    _drawHolographicSegment(
      canvas,
      center,
      radius,
      0,
      savingsProgress,
      [
        const Color(0xFF00B894),
        const Color(0xFF00CE9A),
      ],
      segmentWidth,
    );

    _drawHolographicSegment(
      canvas,
      center,
      radius,
      savingsProgress,
      billsProgress,
      [
        const Color(0xFF0984E3),
        const Color(0xFF74B9FF),
      ],
      segmentWidth,
    );

    _drawHolographicSegment(
      canvas,
      center,
      radius,
      savingsProgress + billsProgress,
      splurgeProgress,
      [
        const Color(0xFFE84393),
        const Color(0xFFFF7675),
      ],
      segmentWidth,
    );

    _drawParticles(canvas, center, radius, segmentWidth);

    _drawFloatingLabels(canvas, center, radius + segmentWidth / 2 + 8);

    _drawHolographicGlow(canvas, center, radius, segmentWidth);

    _drawInteractiveIndicators(canvas, center, radius, segmentWidth);
  }

  void _draw3DBaseShadow(
      Canvas canvas, Offset center, double radius, double width) {
    canvas.drawCircle(
      center,
      radius + width / 2,
      Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    canvas.drawCircle(
      center,
      radius + width / 2,
      Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
        ..blendMode = BlendMode.overlay,
    );
  }

  void _drawHolographicSegment(
    Canvas canvas,
    Offset center,
    double radius,
    double start,
    double progress,
    List<Color> colors,
    double width,
  ) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: const [0.0, 1.0],
        transform: GradientRotation(-pi / 2 + 2 * pi * start),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + 2 * pi * start,
      2 * pi * progress,
      false,
      paint,
    );

    final holographicPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.overlay
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + 2 * pi * start,
      2 * pi * progress,
      false,
      holographicPaint,
    );
  }

  void _drawParticles(
      Canvas canvas, Offset center, double radius, double width) {
    final particleCount = 50;
    final particleRadius = 2.0;
    final dominantColor = _getDominantColor();

    for (var i = 0; i < particleCount; i++) {
      final angle =
          2 * pi * (i / particleCount) + particleAnimation.value * 2 * pi;
      final offset = Offset(
        center.dx + (radius - width / 2) * cos(angle),
        center.dy + (radius - width / 2) * sin(angle),
      );

      canvas.drawCircle(
        offset,
        particleRadius,
        Paint()
          ..color = dominantColor.withOpacity(0.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  void _drawFloatingLabels(Canvas canvas, Offset center, double radius) {
    void drawLabel(TextPainter painter, double angle) {
      final textOffset = Offset(
        center.dx + radius * cos(angle) - painter.width / 2,
        center.dy + radius * sin(angle) - painter.height / 2,
      );

      canvas.save();
      canvas.translate(textOffset.dx + painter.width / 2,
          textOffset.dy + painter.height / 2);
      canvas.rotate(angle + pi / 2);
      canvas.translate(-painter.width / 2, -painter.height / 2);
      painter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    drawLabel(_savingsLabelPainter, _getMidAngle(0, savingsProgress));
    drawLabel(_billsLabelPainter, _getMidAngle(savingsProgress, billsProgress));
    drawLabel(_splurgeLabelPainter,
        _getMidAngle(savingsProgress + billsProgress, splurgeProgress));
  }

  void _drawHolographicGlow(
      Canvas canvas, Offset center, double radius, double width) {
    final dominantColor = _getDominantColor();
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          dominantColor.withOpacity(0.3),
          dominantColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.7))
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, 40 * pulseAnimation.value);

    canvas.drawCircle(center, radius * 0.7, glowPaint);
  }

  void _drawInteractiveIndicators(
      Canvas canvas, Offset center, double radius, double width) {
    final indicatorPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    void drawIndicator(double progress) {
      final angle = -pi / 2 + 2 * pi * progress;
      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      canvas.drawCircle(
        offset,
        4 * (1 + pulseAnimation.value * 0.5),
        indicatorPaint..color = Colors.white.withOpacity(pulseAnimation.value),
      );
    }

    drawIndicator(savingsProgress);
    drawIndicator(savingsProgress + billsProgress);
  }

  double _getMidAngle(double start, double progress) {
    return -pi / 2 + 2 * pi * (start + progress / 2);
  }

  Color _getDominantColor() {
    final values = [savingsProgress, billsProgress, splurgeProgress];
    final maxIndex = values.indexOf(values.reduce(max));

    return switch (maxIndex) {
      0 => const Color(0xFF00B894),
      1 => const Color(0xFF0984E3),
      2 => const Color(0xFFE84393),
      _ => Colors.white,
    };
  }

  @override
  bool shouldRepaint(covariant FinancialMoodPainter old) =>
      old.savingsProgress != savingsProgress ||
      old.billsProgress != billsProgress ||
      old.splurgeProgress != splurgeProgress ||
      old.pulseAnimation != pulseAnimation ||
      old.particleAnimation != particleAnimation;
}
