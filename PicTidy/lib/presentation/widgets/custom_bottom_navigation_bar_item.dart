import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../../shared/extension/widget.dart';
import '../resources/colors.dart';
import '../resources/styles.dart';
import 'marquee_text.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  const CustomBottomNavigationBarItem({
    super.key,
    required this.icon,
    required this.disableIcon,
    this.label,
    this.backgroundColor,
    this.isSelected = false,
  });

  final SvgGenImage icon;
  final SvgGenImage disableIcon;
  final bool isSelected;
  final String? label;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (isSelected ? icon : disableIcon).svg(width: 36.w, height: 36.h),
        if (label != null)
          MarqueeText(
            '$label',
            textAlign: TextAlign.center,
            padding: 0,
            style: AppStyles.titleLBold13(AppColors.dark100),
          ),
      ],
    ).paddingSymmetric(vertical: 3.h, horizontal: 4.w);
  }
}
