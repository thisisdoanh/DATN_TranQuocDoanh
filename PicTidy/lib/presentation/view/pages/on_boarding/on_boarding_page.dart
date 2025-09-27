import 'package:auto_route/auto_route.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/extension/widget.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/dimens.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_animation_skeleton.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/app_touchable.dart';
import 'on_boarding_bloc.dart';

@RoutePage()
class OnBoardingPage
    extends BasePage<OnBoardingBloc, OnBoardingEvent, OnBoardingState> {
  OnBoardingPage({super.key}) : super(screenName: 'OnBoardingPage');

  @override
  void onInitState(BuildContext context) {
    context.read<OnBoardingBloc>().add(const OnBoardingEvent.loadData());
    super.onInitState(context);
  }

  final List<Map<String, dynamic>> onBoardingPages = [
    {
      'title': S.current.swipeDelete,
      'description': S.current.organizeYourPhotosWithASimpleSwipeThroughEachDay,
      'image': Assets.images.intro1,
    },
    {
      'title': S.current.browsePhotosByMonth,
      'description': S.current.swipeLeftToDeleteRightToKeepNoHassleMonth,
      'image': Assets.images.intro2,
    },
    {
      'title': S.current.reviewKeepdelete,
      'description': S.current.knowExactlyHowManyPhotosYouveOrganizedAndUndoAt,
      'image': Assets.images.intro3,
    },
    {
      'title': S.current.quicklyRemoveTheBackground,
      'description':
          S.current.withJustOneActionTheBackgroundWillBeAutomaticallyRemoved,
      'image': Assets.images.intro4,
    },
  ];

  Widget _buildNextButton(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          index == onBoardingPages.length - 1
              ? S.of(context).start
              : S.of(context).next,
          style: AppStyles.bodyXLMedium16(
            AppColors.dark200.withValues(alpha: 0),
          ),
        ),
        DotsIndicator(
          dotsCount: onBoardingPages.length,
          axis: Axis.horizontal,
          position: index.toDouble(),
          decorator: DotsDecorator(
            color: AppColors.dark500,
            activeColor: AppColors.mint300,
            shape: const CircleBorder(),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
            size: const Size.square(8),
            activeSize: const Size(16, 8),
            spacing: EdgeInsets.symmetric(horizontal: 3.w),
          ),
        ),
        AppTouchable(
          onPressed: () => onPressNext(context, index + 1),
          rippleColor: AppColors.transparent,
          child: Text(
            index == onBoardingPages.length - 1
                ? S.of(context).start
                : S.of(context).next,
            style: AppStyles.bodyXLMedium16(AppColors.mint400),
          ),
        ),
      ],
    );
  }

  Widget _buildPage(
    BuildContext context,

    Map<String, dynamic> data,
    int index,
  ) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: data['image'].image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 20.h + MediaQuery.of(context).padding.top + Dimens.paddingTop,
          left: 16.w,
          right: 16.w,
          child: Column(
            spacing: 12.h,
            children: [
              Text(
                data['title'],
                textAlign: TextAlign.center,
                style: AppStyles.titleXXLBold20(AppColors.dark100),
              ),
              Text(
                data['description'],
                textAlign: TextAlign.center,
                style: AppStyles.bodyLMedium14(AppColors.dark200),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              _buildNextButton(
                context,
                index,
              ).paddingSymmetric(horizontal: 60.w),
              26.verticalSpace,
            ],
          ),
        ),

        ///1.55 is the ratio of the skeleton anim
        if (index == 0)
          Positioned(
            left: 45.w,
            bottom: 260.h,
            width: 160.w,
            height: 160.w / 1.55,
            child: AppAnimationSkeleton(
              atlasPath: Assets.anim.skeletonAtlas,
              skeletonPath: Assets.anim.skeletonJson,
              animation: 'animation',
            ),
          ),
      ],
    );
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      child: PageView.builder(
        itemBuilder: (context, index) =>
            _buildPage(context, onBoardingPages[index], index),
        onPageChanged: (value) => onPressNext(context, value),
        itemCount: onBoardingPages.length,
        controller: context.read<OnBoardingBloc>().pageController,
      ),
    );
  }

  void onPressNext(BuildContext context, int page) {
    context.read<OnBoardingBloc>().pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    context.read<OnBoardingBloc>().add(OnBoardingEvent.nextPage(page));
  }
}
