import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/utils/app_utils.dart';
import '../../resources/colors.dart';
import '../../widgets/app_button_circle.dart';

class ActionSlideWipe extends StatelessWidget {
  const ActionSlideWipe({
    super.key,
    required this.onPressedDelete,
    required this.onPressedUndo,
    required this.onPressedKeep,
    required this.assetEntity,
    this.onPressedDownload,
    this.isShowDownload = false,
  });

  final VoidCallback onPressedDelete;
  final VoidCallback onPressedUndo;
  final VoidCallback onPressedKeep;
  final VoidCallback? onPressedDownload;
  final bool isShowDownload;
  final AssetEntity assetEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppButtonCircle(
          onPressed: onPressedDelete,
          width: 44.w,
          height: 44.h,
          backgroundColor: AppColors.red6D6,
          boxShadow: [
            BoxShadow(
              color: AppColors.red323.withValues(alpha: .95),
              blurRadius: 12.4,
            ),
          ],
          child: Assets.icons.trash.svg(width: 26.w, height: 26.h),
        ),
        (isShowDownload ? 46 : 64).horizontalSpace,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButtonCircle(
                onPressed: onPressedUndo,
                width: 44.w,
                height: 44.h,
                backgroundColor: AppColors.blackD23,
                child: Assets.icons.undo.svg(width: 24.w, height: 24.h),
              ),

              AppButtonCircle(
                onPressed: () {
                  AppUtils.instance.shareAsset(assetEntity);
                },
                width: 44.w,
                height: 44.h,
                backgroundColor: AppColors.blackD23,
                child: Assets.icons.share.svg(width: 24.w, height: 24.h),
              ),
              if (isShowDownload) AppButtonCircle(
                onPressed: onPressedDownload,
                width: 44.w,
                height: 44.h,
                backgroundColor: AppColors.blackD23,
                child: Assets.icons.download.svg(width: 24.w, height: 24.h),
              ),
            ],
          ),
        ),
        (isShowDownload ? 46 : 64).horizontalSpace,
        AppButtonCircle(
          onPressed: onPressedKeep,
          width: 44.w,
          height: 44.h,
          backgroundColor: AppColors.blueAF6,
          boxShadow: [
            BoxShadow(
              color: AppColors.blue2FD.withValues(alpha: .8),
              blurRadius: 12.4,
            ),
          ],
          child: Assets.icons.star.svg(width: 26.w, height: 26.h),
        ),
      ],
    );
  }
}
