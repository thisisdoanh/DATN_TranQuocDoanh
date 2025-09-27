import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/l10n.dart';
import '../../../shared/extension/widget.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../widgets/app_touchable.dart';
import '../../widgets/image_item_widget.dart';

class StatusSlideWipe extends StatelessWidget {
  const StatusSlideWipe({
    super.key,
    required this.listIdDelete,
    required this.currentIndex,
    required this.listAssets,
    required this.onPressDelete,
  });

  final List<String> listIdDelete;
  final int currentIndex;
  final List<AssetEntity> listAssets;
  final VoidCallback onPressDelete;

  @override
  Widget build(BuildContext context) {
    final double indexColor = listIdDelete.isEmpty ? 0 : 1;

    final borderSide = BorderSide(
      color: Color.lerp(AppColors.black348, AppColors.redC0C, indexColor)!,
      width: 1.w,
    );

    final bool isPreviousDelete =
        currentIndex > 0 &&
        listIdDelete.contains(listAssets[currentIndex - 1].id);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              12.horizontalSpace,
              AnimatedFlipCounter(
                value: currentIndex,
                suffix: '/${listAssets.length}',
                textStyle: AppStyles.bodyLMedium14(AppColors.light300),
                wholeDigits: 0,
              ),
              12.horizontalSpace,
              if (currentIndex > 0)
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: ImageItemWidget(
                    entity: listAssets[currentIndex - 1],
                    option: const ThumbnailOption(
                      size: ThumbnailSize(40, 40),
                      quality: 80,
                    ),
                    radius: 4.r,
                    coverWidget: Container(
                      color: Color.lerp(
                        const Color(0xA102133F),
                        const Color(0x85821C1C),
                        isPreviousDelete ? 1 : 0,
                      ),
                      alignment: Alignment.center,
                      child:
                          (isPreviousDelete
                                  ? Assets.icons.trash
                                  : Assets.icons.star)
                              .svg(width: 20.w, height: 20.h),
                    ),
                  ),
                ).paddingOnly(right: 8.w),
              Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.white, width: 1.w),
                ),
                child: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: ImageItemWidget(
                    entity: listAssets[currentIndex],
                    option: const ThumbnailOption(
                      size: ThumbnailSize(40, 40),
                      quality: 80,
                    ),
                    radius: 4.r,
                  ),
                ),
              ),
              if (currentIndex < listAssets.length - 1)
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: ImageItemWidget(
                    entity: listAssets[currentIndex + 1],
                    option: const ThumbnailOption(
                      size: ThumbnailSize(40, 40),
                      quality: 80,
                    ),
                    radius: 4.r,
                    coverWidget: Container(
                      color: AppColors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ).paddingOnly(left: 8.w),
            ],
          ),
        ),
        AppTouchable(
          onPressed: onPressDelete,
          padding: EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Color.lerp(AppColors.black426, AppColors.red450, indexColor),
            border: Border(
              top: borderSide,
              left: borderSide,
              bottom: borderSide,
            ),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(100.r)),
          ),
          child: Row(
            spacing: 8.w,
            children: [
              Container(
                width: 22.w,
                height: 22.h,
                padding: EdgeInsets.all(4.r),
                decoration: ShapeDecoration(
                  color: Color.lerp(
                    AppColors.dark300,
                    AppColors.semanticRed200,
                    indexColor,
                  ),
                  shape: const CircleBorder(),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    listIdDelete.length.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.light100,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.manrope,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Text(
                S.of(context).delete,
                style: AppStyles.bodyLMedium14(
                  Color.lerp(
                    AppColors.dark300,
                    AppColors.light100,
                    indexColor,
                  )!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
