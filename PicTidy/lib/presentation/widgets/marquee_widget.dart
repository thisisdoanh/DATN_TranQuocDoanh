import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marqueer/marqueer.dart';

import 'overflow_detector.dart';

class MarqueeWidget extends StatelessWidget {
  const MarqueeWidget({
    super.key,
    required this.child,
    this.blankSpace = 20,
    this.padding = 10,
    this.widgetWidth,
    this.maxWidth,
    this.height,
  });

  final double blankSpace;
  final double padding;
  final Widget child;
  final double? widgetWidth;
  final double? maxWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (widgetWidth != null && maxWidth != null) {
      if (widgetWidth! <= maxWidth!) {
        return child;
      }
      return SizedBox(
        height: height ?? 50, // hoặc đo chiều cao thực tế nếu cần
        width: maxWidth,
        child: Marqueer(
          pps: 60,
          padding: EdgeInsets.symmetric(horizontal: blankSpace),
          child: child,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint('Maxwidth: ${constraints.maxWidth}, 105.w:${105.w}');
        return OverflowDetector(
          maxWidth: constraints.maxWidth - padding,
          onOverflow: (isOverflowing, childWidth, maxWidth) {
            debugPrint(
              'isOverflowing: $isOverflowing, childWidth: $childWidth, maxWidth: $maxWidth',
            );
            if (isOverflowing) {
              return SizedBox(
                height:
                    constraints.maxHeight, // hoặc đo chiều cao thực tế nếu cần
                width: constraints.maxWidth,
                child: Marqueer(
                  pps: 60,
                  padding: EdgeInsets.symmetric(horizontal: blankSpace),
                  child: child,
                ),
              );
            } else {
              return child;
            }
          },
          child: child,
        );
      },
    );
  }
}
