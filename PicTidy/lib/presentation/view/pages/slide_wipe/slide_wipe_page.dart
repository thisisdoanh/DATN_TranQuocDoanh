import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/extension/datetime.dart';
import '../../../../shared/extension/widget.dart';
import '../../../../shared/extension/text_style.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/dimens.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_animation_skeleton.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../shared_widget/action_slide_wipe.dart';
import '../../shared_widget/status_slide_wipe.dart';
import 'component/image_component.dart';
import 'slide_wipe_bloc.dart';

part 'component/bg_remove_setting_component.dart';

@RoutePage()
class SlideWipePage
    extends BasePage<SlideWipeBloc, SlideWipeEvent, SlideWipeState> {
  const SlideWipePage({
    super.key,
    required this.listPhotos,
    this.isAlbum = false,
    this.isMonth = false,
    this.isMemory = false,
    this.albumName = '',
  }) : super(screenName: 'SlideWipePage');

  final List<AssetEntity> listPhotos;
  final bool isAlbum;
  final bool isMonth;
  final bool isMemory;
  final String albumName;

  @override
  void onInitState(BuildContext context) async {
    context.read<SlideWipeBloc>().add(SlideWipeEvent.loadData(listPhotos));
    await BackgroundRemover.instance.initializeOrt();

    super.onInitState(context);
  }

  @override
  void onDispose(BuildContext context) {
    BackgroundRemover.instance.dispose();

    super.onDispose(context);
  }

  String? _getBottomText(DateTime dateTime) {
    if (isAlbum || isMemory) {
      return dateTime.formatPattern(pattern: 'dd MMM yyyy');
    }

    if (isMonth) {
      return dateTime.formatWithSuffix();
    }

    return null;
  }

  String? _getTitleText(DateTime dateTime) {
    if (isAlbum || isMonth) {
      return albumName;
    }

    return dateTime.formatPattern(pattern: 'dd MMM yyyy');
  }

  Widget? _getTitleWidget(DateTime dateTime) {
    if (isMemory) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8.w,
        children: [
          Assets.icons.calendarMemory.svg(width: 24.w, height: 24.h),
          Text(
            S.current.NYearsAgo(DateTime.now().year - dateTime.year),
            style: AppStyles.titleXLBold18(AppColors.light100),
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      backgroundImage: Assets.images.bgSlideWipe,
      isUseBackgroundImage: true,
      coverScreenWidget: BlocBuilder<SlideWipeBloc, SlideWipeState>(
        builder: (context, state) => state.isLoadingRemoveBG
            ? Scaffold(
                backgroundColor: AppColors.black.withValues(alpha: 0.4),
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 60.w,
                        height: 60.w / 3,
                        child: AppAnimationSkeleton(
                          atlasPath: Assets.anim.skeletonAtlas,
                          skeletonPath: Assets.anim.skeletonJson,
                          animation: 'animation2',
                        ),
                      ),
                      24.verticalSpace,
                      Text(
                        S.of(context).removingBackground,
                        style: AppStyles.titleXLBold16(AppColors.light100),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight.h + Dimens.paddingTop),
        child: BlocBuilder<SlideWipeBloc, SlideWipeState>(
          buildWhen: (previous, current) {
            if (previous.currentIndex != current.currentIndex ||
                previous.listPhotos != current.listPhotos) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            return CustomAppbar(
              titleText: _getTitleText(
                state.listPhotos[state.currentIndex].createDateTime,
              ),
              titleWidget: _getTitleWidget(
                state.listPhotos[state.currentIndex].createDateTime,
              ),
              bottomText: _getBottomText(
                state.listPhotos[state.currentIndex].createDateTime,
              ),
              centerTitle: true,
            );
          },
        ),
      ),
      child: Column(
        children: [
          Expanded(child: ImageComponent(listPhotos: listPhotos)),
          4.verticalSpace,
          const BgRemoveSettingComponent(),
          8.verticalSpace,
          BlocBuilder<SlideWipeBloc, SlideWipeState>(
            buildWhen: (previous, current) =>
                current.removeBGBytes != null ||
                previous.listPhotos != current.listPhotos ||
                previous.currentIndex != current.currentIndex ||
                previous.listIdsPhotosDelete != current.listIdsPhotosDelete,
            builder: (context, state) {
              return Column(
                children: [
                  ActionSlideWipe(
                    onPressedDelete: () {
                      context.read<SlideWipeBloc>().cardSwiperController.swipe(
                        CardSwiperDirection.left,
                      );
                    },
                    onPressedUndo: () {
                      if (state.removeBGBytes != null) {
                        context.read<SlideWipeBloc>().add(
                          const SlideWipeEvent.backFromRemoveBG(),
                        );
                      } else {
                        context
                            .read<SlideWipeBloc>()
                            .cardSwiperController
                            .undo();
                      }
                    },

                    onPressedKeep: () {
                      context.read<SlideWipeBloc>().cardSwiperController.swipe(
                        CardSwiperDirection.right,
                      );
                    },

                    onPressedDownload: () {
                      context.read<SlideWipeBloc>().add(
                        const SlideWipeEvent.onPressDownloadRemoveBG(),
                      );
                    },
                    isShowDownload: state.removeBGBytes != null,
                    assetEntity: state.listPhotos[state.currentIndex],
                  ).paddingSymmetric(horizontal: 12.w),
                  16.verticalSpace,
                  StatusSlideWipe(
                    listIdDelete: state.listIdsPhotosDelete,
                    currentIndex: state.currentIndex,
                    listAssets: state.listPhotos,
                    onPressDelete: () {
                      context.read<SlideWipeBloc>().add(
                        const SlideWipeEvent.onPressConfirmDelete(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          15.verticalSpace,
        ],
      ),
    );
  }
}
