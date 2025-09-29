import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../shared/extension/widget.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialog.dart';

class RandomBottomSheet extends StatelessWidget {
  const RandomBottomSheet({
    super.key,
    this.onAnythingPressed,
    this.onScreenshotsPressed,
    this.onPhotosPressed,
  });

  final VoidCallback? onAnythingPressed;
  final VoidCallback? onScreenshotsPressed;
  final VoidCallback? onPhotosPressed;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      widthDialog: 360.w,
      topWidget: Assets.icons.random.svg(width: 84.w, height: 84.h),
      topPadding: EdgeInsets.only(top: 16.h, bottom: 24.h),
      titleWidget: Text(
        S.of(context).pickWhatTypesOfImageToSeeInRandom,
        style: AppStyles.bodyLSemi14(AppColors.dark200),
        textAlign: TextAlign.center,
      ),
      messageWidget: Column(
        spacing: 16.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            onPressed: () {
              onAnythingPressed?.call();
            },
            text: S.of(context).anything,
            width: double.infinity,
            height: 56.h,
            radius: 16.r,
          ),
          AppButton(
            onPressed: () {
              onScreenshotsPressed?.call();
            },
            text: S.of(context).screenshots,
            width: double.infinity,
            height: 56.h,
            radius: 16.r,
          ),
          AppButton(
            onPressed: () {
              onPhotosPressed?.call();
            },
            text: S.of(context).photos,
            width: double.infinity,
            height: 56.h,
            radius: 16.r,
          ),
        ],
      ).paddingSymmetric(horizontal: 16.w, vertical: 24.h),

      isShowButton: false,
    );
  }
}
