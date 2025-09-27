import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../../di/di.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../shared/extension/widget.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/styles.dart';
import '../../../../widgets/app_button_circle.dart';
import '../../../../widgets/app_touchable.dart';
import '../../../../widgets/image_item_widget.dart';
import '../../home/home_bloc.dart';
import '../slide_wipe_bloc.dart';

class ImageComponent extends StatelessWidget {
  const ImageComponent({super.key, required this.listPhotos});

  final List<AssetEntity> listPhotos;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlideWipeBloc, SlideWipeState>(
      buildWhen: (previous, current) {
        // Chỉ rebuild khi cần thiết để tránh lag
        return previous.currentIndex != current.currentIndex ||
            previous.listPhotos != current.listPhotos ||
            previous.removeBGBytes != current.removeBGBytes;
      },
      builder: (context, state) {
        return CardSwiper(
          cardBuilder:
              (
                context,
                index,
                horizontalOffsetPercentage,
                verticalOffsetPercentage,
              ) {

                return Center(
                  child: SizedBox(
                    width: 286.w,
                    height: 492.h,

                    child: ImageItemWidget(
                      fit: BoxFit.contain,
                      entity: state.listPhotos[index],
                      imageData: state.removeBGBytes,
                      radius: 12.r,
                      option: ThumbnailOption(
                        size: ThumbnailSize(286.w.toInt(), 492.h.toInt()),
                      ),
                      scale: 492.h / 286.w,
                      topLeftWidget: Container(
                        height: 52.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        constraints: BoxConstraints(minWidth: 100.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blue7FF,
                            width: 2.w,
                          ),
                          color: AppColors.blue3DC.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).keep,
                          style: AppStyles.titleXLBold18(AppColors.light100),
                        ),
                      ),
                      topRightWidget: Container(
                        height: 52.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        constraints: BoxConstraints(minWidth: 100.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.red484,
                            width: 2.w,
                          ),
                          color: AppColors.red030.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).delete.toUpperCase(),
                          style: AppStyles.titleXLBold18(AppColors.light100),
                        ),
                      ),
                      bottomLeftWidget: AppTouchable(
                        onPressed: () => context.read<SlideWipeBloc>().add(
                          const SlideWipeEvent.onPressRemoveBG(),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: AppColors.black.withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                        child: Assets.images.removeBg.image(
                          width: 42.w,
                          height: 26.h,
                        ),
                      ),
                      bottomRightWidget: BlocBuilder<HomeBloc, HomeState>(
                        bloc: getIt<HomeBloc>(),
                        builder: (context, state) {
                          final id = listPhotos[index].id;
                          return AppButtonCircle(
                            onPressed: () => context.read<SlideWipeBloc>().add(
                              SlideWipeEvent.onPressFavorite(id),
                            ),
                            width: 36.w,
                            height: 36.h,
                            backgroundColor: AppColors.blackD23.withValues(
                              alpha: 0.6,
                            ),
                            child:
                                (state.listFavoriteId.contains(id)
                                        ? Assets.icons.liked
                                        : Assets.icons.like)
                                    .svg(width: 20.w, height: 20.h),
                          );
                        },
                      ),
                      isShowTopLeftWidget: horizontalOffsetPercentage > 0,
                      isShowTopRightWidget: horizontalOffsetPercentage < 0,
                      coverWidget: horizontalOffsetPercentage != 0
                          ? Container(
                              color: AppColors.black.withValues(alpha: 0.4),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                );
              },

          cardsCount: listPhotos.length,
          controller: context.read<SlideWipeBloc>().cardSwiperController,
          numberOfCardsDisplayed: 1,
          initialIndex: 0,
          isLoop: false,
          threshold: 80,
          padding: EdgeInsets.zero,
          onSwipe: (previousIndex, currentIndex, direction) {
            context.read<SlideWipeBloc>().add(
              SlideWipeEvent.onSwipe(previousIndex, currentIndex, direction),
            );
            return true;
          },
          onUndo: (previousIndex, currentIndex, direction) {
            context.read<SlideWipeBloc>().add(
              SlideWipeEvent.onPressUndo(previousIndex, currentIndex),
            );
            return true;
          },
          allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
            horizontal: true,
          ),
        );
      },
    );
  }
}
