import 'package:flutter/material.dart';

class SquarePlaceholder extends StatelessWidget {
  const SquarePlaceholder({
    super.key,
    required this.size,
    required this.radius,
  });

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
      ),
    );
  }
}

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({
    super.key,
    required this.height,
    required this.radius,
  });

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  const TitlePlaceholder({super.key, required this.width, this.lines = 2});

  final double width;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: width, height: 12.0, color: Colors.white),

        for (int i = 1; i < lines; i++)
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
            margin: const EdgeInsets.only(top: 8),
          ),
      ],
    );
  }
}

enum ContentLineType { twoLines, threeLines }

class ContentPlaceholder extends StatelessWidget {
  const ContentPlaceholder({
    super.key,
    required this.lineType,
    required this.height,
    required this.radius,
  });

  final ContentLineType lineType;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 10.0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8.0),
              ),
              if (lineType == ContentLineType.threeLines)
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
              Container(width: 100.0, height: 10.0, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}

class RectanglePlaceholder extends StatelessWidget {
  const RectanglePlaceholder({
    super.key,
    this.width,
    this.height,
    this.radius = 0.0,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
      ),
    );
  }
}
