import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/styles.dart';
import '../../../../widgets/app_touchable.dart';

class ItemSettingComponent extends StatelessWidget {
  const ItemSettingComponent({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
  });

  final VoidCallback onPressed;
  final SvgGenImage icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPressed: onPressed,
      width: 328.w,
      height: 68.h,
      padding:  EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.w,
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: const ShapeDecoration(
              color: Color(0xFF008D3A),
              shape: CircleBorder(),
            ),
            alignment: Alignment.center,
            child: icon.svg(width: 18.w, height: 18.h,),
          ),
          Expanded(child: Text(title, style: AppStyles.titleXLSemi16(AppColors.dark100),),),
          Assets.icons.arrowRight.svg(
            width: 20.w,
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
