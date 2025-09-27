import 'package:auto_route/auto_route.dart';
import 'package:awesome_video_player/awesome_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/extension/datetime.dart';
import '../../../../shared/extension/widget.dart';
import '../../../../shared/utils/app_log.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/dimens.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/app_touchable.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_control_player.dart';
import '../../../widgets/placeholders.dart';
import '../../shared_widget/action_slide_wipe.dart';
import '../../shared_widget/status_slide_wipe.dart';
import '../home/home_bloc.dart';
import 'slide_wipe_video_bloc.dart';

part 'component/slide_video_component.dart';

@RoutePage()
class SlideWipeVideoPage
    extends
        BasePage<SlideWipeVideoBloc, SlideWipeVideoEvent, SlideWipeVideoState> {
  const SlideWipeVideoPage({super.key, required this.listVideos})
    : super(screenName: 'SlideWipeVideoPage');

  final List<AssetEntity> listVideos;

  @override
  void onInitState(BuildContext context) {
    context.read<SlideWipeVideoBloc>().add(
      SlideWipeVideoEvent.loadData(listVideos: listVideos),
    );
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      backgroundImage: Assets.images.bgSlideWipe,
      isUseBackgroundImage: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight.h + Dimens.paddingTop),
        child: BlocBuilder<SlideWipeVideoBloc, SlideWipeVideoState>(
          buildWhen: (previous, current) {
            if (previous.currentIndex != current.currentIndex ||
                previous.listVideos != current.listVideos) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            return CustomAppbar(
              titleText: state.listVideos[state.currentIndex].createDateTime
                  .formatPattern(pattern: 'dd MMM yyyy'),
              style: AppStyles.titleXLBold18(AppColors.light200),
              centerTitle: true,
            );
          },
        ),
      ),
      child: Column(
        children: [
          20.verticalSpace,
          Expanded(child: SlideVideoComponent(listVideos: listVideos)),
          20.verticalSpace,
          BlocBuilder<SlideWipeVideoBloc, SlideWipeVideoState>(
            builder: (context, state) {
              // return state.cntWipe % 4 == 3
              //     ? const SizedBox.shrink()
              //     : Column(
              return Column(
                children: [
                  ActionSlideWipe(
                    onPressedDelete: () {
                      context
                          .read<SlideWipeVideoBloc>()
                          .cardSwiperController
                          .swipe(CardSwiperDirection.left);
                    },
                    onPressedUndo: () {
                      context
                          .read<SlideWipeVideoBloc>()
                          .cardSwiperController
                          .undo();
                    },

                    onPressedKeep: () {
                      context
                          .read<SlideWipeVideoBloc>()
                          .cardSwiperController
                          .swipe(CardSwiperDirection.right);
                    },
                    assetEntity: state.listVideos[state.currentIndex],
                  ).paddingSymmetric(horizontal: 12.w),
                  32.verticalSpace,
                  StatusSlideWipe(
                    listIdDelete: state.listIdsVideosDelete,
                    currentIndex: state.currentIndex,
                    listAssets: state.listVideos,
                    onPressDelete: () {
                      context.read<SlideWipeVideoBloc>().add(
                        const SlideWipeVideoEvent.onPressConfirmDelete(),
                      );
                    },
                  ),
                  45.verticalSpace,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
