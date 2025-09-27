import 'package:auto_route/auto_route.dart';
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
import '../home/home_bloc.dart';
import 'clean_bloc.dart';
import 'component/header.dart';
import 'component/item_album_component.dart';
import 'component/photo_component.dart';
import 'component/screen_shot_component.dart';
import 'component/similar_component.dart';
import 'component/video_component.dart';

@RoutePage()
class CleanPage extends BasePage<CleanBloc, CleanEvent, CleanState> {
  const CleanPage({super.key}) : super(screenName: 'CleanPage');

  @override
  void onInitState(BuildContext context) {
    context.read<CleanBloc>().add(const CleanEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.albumPhoto != current.albumPhoto,
      builder: (context, state) {
        final filteredPhotos = state.albumPhoto
            .where((e) => e.isAll != true)
            .toList();
        return Stack(
          children: [
            // Background image - cached
            RepaintBoundary(
              child: Assets.images.homeBackground.image(
                width: double.maxFinite,
                height: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            // Animation skeleton - isolated repaint
            Positioned(
              top: 0,
              left: 0,
              right: 170.w,
              child: RepaintBoundary(
                child: AppAnimationSkeleton(
                  atlasPath: Assets.anim.bling2Atlas,
                  skeletonPath: Assets.anim.bling2Json,
                ),
              ),
            ),
            CustomScrollView(
              cacheExtent: 500, // Cache more items for smoother scrolling
              slivers: [
                SliverToBoxAdapter(
                  child: const Header().paddingOnly(
                    top:
                        MediaQuery.paddingOf(context).top +
                        16.h +
                        Dimens.paddingTop,
                    left: 16.w,
                    bottom: 32.h,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    spacing: 24.h,
                    children: [
                      const RepaintBoundary(child: VideoComponent()),
                      Row(
                        spacing: 16.w,
                        children: const [
                          Expanded(child: PhotoComponent()),
                          Expanded(child: ScreenShotComponent()),
                        ],
                      ),
                      const RepaintBoundary(child: SimilarComponent()),
                    ],
                  ).paddingSymmetric(horizontal: 16.w),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      20.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 24.h,
                        ),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                        ),
                        alignment: Alignment.topLeft,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 14.w,
                              child: Assets.images.albumTextHomeComponent.image(
                                height: 44.h,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Text(
                              S.of(context).album,
                              style: AppStyles.titleXXLSemi20(AppColors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Album Grid with optimization
                DecoratedSliver(
                  decoration: BoxDecoration(color: AppColors.white),
                  sliver: SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 16.w,
                        mainAxisExtent: 220.h,
                      ),
                      itemBuilder: (context, index) {
                        final photo = filteredPhotos[index];
                        return RepaintBoundary(
                          child: ItemAlbumComponent(
                            key: ValueKey<String>(photo.albumId),
                            photo: photo,
                          ),
                        );
                      },
                      itemCount: filteredPhotos.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(height: 150.h, color: AppColors.white),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
