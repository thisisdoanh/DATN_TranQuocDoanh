import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/extension/widget.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../router/router.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_container.dart';
import 'empty_warning_bloc.dart';

@RoutePage()
class EmptyWarningPage
    extends BasePage<EmptyWarningBloc, EmptyWarningEvent, EmptyWarningState> {
  const EmptyWarningPage({
    super.key,
    required this.title,
    required this.message,
    required this.backgroundImage,
    required this.isShowGoToHomeButton,
    this.messageWidget,
    this.verticalSpace = 320,
  }) : super(screenName: 'EmptyWarningPage');

  final String title;
  final String message;
  final Widget? messageWidget;
  final AssetGenImage backgroundImage;
  final double verticalSpace;
  final bool isShowGoToHomeButton;

  @override
  void onInitState(BuildContext context) {
    context.read<EmptyWarningBloc>().add(const EmptyWarningEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      backgroundGradientColor: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB3FFF6), Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
        stops: [0, 0.41, 1],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: backgroundImage.image(
              width: double.maxFinite,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                verticalSpace.verticalSpace,
                Column(
                  children: [
                    Text(
                      title,
                      style: AppStyles.titleXLBold18(AppColors.dark200),
                      textAlign: TextAlign.center,
                    ),
                    12.verticalSpace,
                    messageWidget ??
                        Text(
                          message,
                          style: AppStyles.bodyLRegular14(AppColors.dark200),
                          textAlign: TextAlign.center,
                        ),
                    16.verticalSpace,
                    if (messageWidget == null)
                      Row(
                        spacing: 5.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.images.keepOnExploring.image(
                            width: 54.w,
                            height: 36.h,
                          ),
                          Text(
                            S.of(context).keepOnExploring,
                            style: AppStyles.titleXLBold16(AppColors.dark200),
                          ),
                        ],
                      ),
                  ],
                ).paddingSymmetric(horizontal: 28.w),
                if (isShowGoToHomeButton) ...[
                  24.verticalSpace,
                  AppButton(
                    onPressed: () => getIt<AppRouter>().popUntil(
                      (route) => route.settings.name == HomeRoute.name,
                    ),
                    radius: 16.r,
                    height: 56.h,
                    width: 328.w,
                    text: S.of(context).goToHome,
                  ),
                ],
              ],
            ),
          ),

          if (!isShowGoToHomeButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16.h,
              left: 16.w,
              child: IconButton(
                onPressed: getIt<AppRouter>().pop,
                icon: Assets.icons.arrowLeft.svg(
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.dark100,
                    BlendMode.srcIn,
                  ),
                ),
                tooltip: 'Back',
              ),
            ),
        ],
      ),
    );
  }
}
