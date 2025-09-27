import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../resources/colors.dart';

class GradientTextStrokePainter extends CustomPainter {
  GradientTextStrokePainter({
    required this.text,
    required this.textStyle,
    required this.colors,
    this.isHasShadow = true,
    this.sizeCallback,
  });
  final String text;
  final List<Color> colors;
  final TextStyle textStyle;
  final bool isHasShadow;
  final Function(Size size)? sizeCallback;

  @override
  void paint(Canvas canvas, Size size) {
    final textPainterGradient = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: textStyle.fontSize,
          fontWeight: textStyle.fontWeight,
          fontFamily: textStyle.fontFamily,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..shader = ui.Gradient.linear(
              Offset(size.width / 2, size.height * 0.05),
              Offset(size.width / 2, size.height * 0.8),
              colors,
            ),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textPainterText = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final textPainterShadow = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: (textStyle.fontSize ?? 0),
          fontWeight: textStyle.fontWeight,
          fontFamily: textStyle.fontFamily,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = AppColors.green82A.withValues(alpha: 0.71)
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const offset = Offset(0, 0);
    const offsetShadow = Offset(0, 2);

    if (isHasShadow) {
      textPainterShadow.paint(canvas, offsetShadow);
    }
    textPainterGradient.paint(canvas, offset);
    textPainterText.paint(canvas, offset);
    sizeCallback?.call(textPainterGradient.size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
