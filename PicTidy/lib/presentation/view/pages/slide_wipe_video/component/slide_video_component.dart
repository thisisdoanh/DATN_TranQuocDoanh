part of '../slide_wipe_video_page.dart';

class SlideVideoComponent extends StatelessWidget {
  const SlideVideoComponent({super.key, required this.listVideos});

  final List<AssetEntity> listVideos;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12.r),
          child: FutureBuilder<List<BetterPlayerDataSource>>(
            future: context.read<SlideWipeVideoBloc>().setupData(listVideos),
            builder: (context, snapshot) {
              final slideWipeVideoBloc = context.read<SlideWipeVideoBloc>();
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.hasError) {
                return AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade600,
                    highlightColor: Colors.grey.shade50,
                    child: const RectanglePlaceholder(),
                  ),
                );
              }

              return CardSwiper(
                cardBuilder:
                    (
                      context,
                      index,
                      horizontalOffsetPercentage,
                      verticalOffsetPercentage,
                    ) {
                      if (index == 0) {
                        _betterPlayerPlaylistController(
                          context,
                        )?.betterPlayerController?.play();
                      }
                      return Center(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.dark200,
                                    ),
                                  ),
                                ),
                                BetterPlayerPlaylist(
                                  key: slideWipeVideoBloc
                                      .betterPlayerPlaylistStateKey,
                                  betterPlayerConfiguration: slideWipeVideoBloc
                                      .betterPlayerConfiguration,
                                  betterPlayerPlaylistConfiguration:
                                      slideWipeVideoBloc
                                          .betterPlayerPlaylistConfiguration,
                                  betterPlayerDataSourceList: snapshot.data!,
                                ),
                                Positioned(
                                  bottom: 10.h,
                                  left: 12.w,
                                  right: 6.w,
                                  child: BlocBuilder<HomeBloc, HomeState>(
                                    bloc: getIt<HomeBloc>(),
                                    builder: (contextHome, homeState) {
                                      return BlocBuilder<
                                        SlideWipeVideoBloc,
                                        SlideWipeVideoState
                                      >(
                                        builder: (context, state) {
                                          final id = listVideos[index].id;
                                          return CustomControlPlayer(
                                            controller:
                                                _betterPlayerPlaylistController(
                                                  context,
                                                )?.betterPlayerController,
                                            controlsConfiguration:
                                                slideWipeVideoBloc
                                                    .betterPlayerConfiguration
                                                    .controlsConfiguration,
                                            isLiked: homeState.listFavoriteId
                                                .contains(id),
                                            onPressLike: (isLike) => context
                                                .read<SlideWipeVideoBloc>()
                                                .add(
                                                  SlideWipeVideoEvent.onPressFavorite(
                                                    id,
                                                  ),
                                                ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                if (horizontalOffsetPercentage > 0)
                                  Positioned(
                                    top: 8.h,
                                    left: 10.w,
                                    child: Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 100.w,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.blue7FF,
                                          width: 2.w,
                                        ),
                                        color: AppColors.blue3DC.withValues(
                                          alpha: 0.75,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          11.r,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        S.of(context).keep,
                                        style: AppStyles.titleXLBold18(
                                          AppColors.light100,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (horizontalOffsetPercentage < 0)
                                  Positioned(
                                    top: 8.h,
                                    right: 10.w,
                                    child: Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 100.w,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.red484,
                                          width: 2.w,
                                        ),
                                        color: AppColors.red030.withValues(
                                          alpha: 0.72,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          11.r,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        S.of(context).delete.toUpperCase(),
                                        style: AppStyles.titleXLBold18(
                                          AppColors.light100,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (horizontalOffsetPercentage != 0)
                                  Container(
                                    color: AppColors.black.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },

                cardsCount: listVideos.length,
                controller: context
                    .read<SlideWipeVideoBloc>()
                    .cardSwiperController,
                numberOfCardsDisplayed: 1,
                initialIndex: 0,
                isLoop: false,
                threshold: 80,
                padding: EdgeInsets.zero,
                onSwipe: (previousIndex, currentIndex, direction) {
                  AppLog.info(
                    'onSwipe previousIndex: $previousIndex ||| currentIndex:$currentIndex',
                    tag: 'SlideWipeWatch',
                  );
                  context.read<SlideWipeVideoBloc>().add(
                    SlideWipeVideoEvent.onSwipe(
                      previousIndex,
                      currentIndex,
                      direction,
                    ),
                  );
                  return true;
                },
                onUndo: (previousIndex, currentIndex, direction) {
                  AppLog.info(
                    'onUndo previousIndex: $previousIndex ||| currentIndex:$currentIndex',
                    tag: 'SlideWipeWatch',
                  );

                  context.read<SlideWipeVideoBloc>().add(
                    SlideWipeVideoEvent.onPressUndo(
                      previousIndex,
                      currentIndex,
                    ),
                  );
                  return true;
                },
                allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                  horizontal: true,
                ),
              );
            },
          ),
        ),

      ],
    );
  }

  BetterPlayerPlaylistController? _betterPlayerPlaylistController(
    BuildContext context,
  ) {
    final key = context
        .watch<SlideWipeVideoBloc>()
        .betterPlayerPlaylistStateKey;
    final state = key.currentState;
    if (state == null) {
      return null;
    }
    return state.betterPlayerPlaylistController;
  }
}
