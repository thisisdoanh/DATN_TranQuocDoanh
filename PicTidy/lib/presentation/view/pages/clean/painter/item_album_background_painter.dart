//Copy this CustomPainter code to the Bottom of the File
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ItemAlbumBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000000, 0),
      Offset(size.width * 0.5000000, size.height * 0.9715909),
      [
        const Color(0xffB1FEFF).withOpacity(1),
        const Color(0xffC1FAC2).withOpacity(1),
      ],
      [0, 1],
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height * 0.9715909),
        bottomRight: Radius.circular(size.width * 0.1025641),
        bottomLeft: Radius.circular(size.width * 0.1025641),
        topLeft: Radius.circular(size.width * 0.1025641),
        topRight: Radius.circular(size.width * 0.1025641),
      ),
      paint0Fill,
    );

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.2051282, size.height * 0.9886364);
    path_1.lineTo(size.width * 0.7948718, size.height * 0.9886364);
    path_1.cubicTo(
      size.width * 0.7948718,
      size.height * 0.9949148,
      size.width * 0.7891346,
      size.height,
      size.width * 0.7820513,
      size.height,
    );
    path_1.lineTo(size.width * 0.2179487, size.height);
    path_1.cubicTo(
      size.width * 0.2108679,
      size.height,
      size.width * 0.2051282,
      size.height * 0.9949148,
      size.width * 0.2051282,
      size.height * 0.9886364,
    );
    path_1.close();

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xffB6EFB9).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
