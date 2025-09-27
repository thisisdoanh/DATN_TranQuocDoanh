import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TextWithBackgroundPainter extends CustomPainter {
  TextWithBackgroundPainter({
    super.repaint,
    required this.text,
    required this.colors,
    required this.textStyle,
    required this.stops,
  });

  final String text;
  final List<Color> colors;
  final List<double> stops;
  final TextStyle textStyle;
  @override
  void paint(Canvas canvas, Size size) {
    final textPainterBackground = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textStyle.color,
          fontSize: textStyle.fontSize,
          fontWeight: textStyle.fontWeight,
          fontFamily: textStyle.fontFamily,
          background: Paint()
            ..shader = ui.Gradient.linear(
              Offset(0, size.height * 0.5),
              Offset(size.width, size.height * 0.5),
              colors,
              stops,
            ),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    const offset = Offset(0, 0);
    textPainterBackground.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
