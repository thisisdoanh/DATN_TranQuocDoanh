import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/constant/app_constant.dart';
import '../../../../shared/extension/widget.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_container.dart';
import 'splash_bloc.dart';

@RoutePage()
class SplashPage extends BasePage<SplashBloc, SplashEvent, SplashState> {
  const SplashPage({super.key}) : super(screenName: 'SplashPage');

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      isUseBackgroundImage: true,
      backgroundImage: Assets.images.bgSplash,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(16.r),
                child: Assets.images.appIcon.image(width: 139.w, height: 139.w),
              ),
              24.verticalSpace,
              Text(
                AppConstant.appName.toUpperCase(),
                style: AppStyles.titleXXLBold20(AppColors.dark100),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  S.of(context).cleaner.toUpperCase(),
                  style: GoogleFonts.maname(
                    fontSize: 60.sp,
                    color: AppColors.white.withValues(alpha: 0.36),
                    height: 72 / 60,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3.60,
                  ),
                ),
              ).paddingSymmetric(horizontal: 8.w),
            ],
          ),
          Positioned(
            bottom: 36.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              children: [
                SizedBox(
                  width: 30.r,
                  height: 30.r,
                  child: CircularProgressIndicator(
                    color: AppColors.dark100,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 4.r,
                  ),
                ),
                15.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onInitState(BuildContext context) {
    context.read<SplashBloc>().add(const SplashEvent.loadData());
    super.onInitState(context);
  }
}
