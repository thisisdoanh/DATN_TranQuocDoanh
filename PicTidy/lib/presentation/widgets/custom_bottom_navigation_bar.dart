import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors.dart';
import 'app_touchable.dart';
import 'custom_bottom_navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onPressed,
    required this.items,
    required this.spacing,
    required this.selectedColor,
    required this.currentIndex,
  });

  final Function(int index) onPressed;
  final int currentIndex;
  final List<CustomBottomNavigationBarItem> items;
  final double spacing;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(24.r),
      child: InnerShadow(
        shadows: [
          Shadow(
            color: const Color(0xFF595959).withValues(alpha: 0.4),
            offset: const Offset(0, 6),
            blurRadius: 8,
          ),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.greenBD5, width: 1),
            color: AppColors.white,
          ),
          child: Row(
            spacing: spacing,
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: AppTouchable(
                    onPressed: () => onPressed(i),
                    decoration: BoxDecoration(
                      color: currentIndex == i
                          ? selectedColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomBottomNavigationBarItem(
                      icon: items[i].icon,
                      label: items[i].label,
                      isSelected: currentIndex == i,
                      disableIcon: items[i].disableIcon,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
