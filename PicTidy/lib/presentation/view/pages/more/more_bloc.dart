import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/extension/iterable.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../router/router.dart';
import '../home/home_bloc.dart';

part 'more_bloc.freezed.dart';

part 'more_event.dart';

part 'more_state.dart';

@injectable
class MoreBloc extends BaseBloc<MoreEvent, MoreState> {
  MoreBloc() : super(const MoreState()) {
    on<MoreEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            await _handleLoadData(emit, event);
            break;
          case _Favorite():
            await _handleFavorite(emit, event);
            break;
          case _MyStatistics():
            await _handleMyStatistics(emit, event);
            break;

          case _Language():
            await _handleLanguage(emit, event);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  Future<void> _handleLoadData(Emitter<MoreState> emit, _LoadData event) async {
    emit(state.copyWith(pageStatus: PageStatus.Loaded));
  }

  Future<void> _handleFavorite(Emitter<MoreState> emit, _Favorite event) async {
    final List<AssetEntity> allPhoto =
        (homeBloc.state.albumPhoto
                    .safeFirstWhere((element) => element.isAll == true)
                    ?.photos ??
                [])
            .toList();

    final List<AssetEntity> favoritePhotos = allPhoto
        .where((element) => homeBloc.state.listFavoriteId.contains(element.id))
        .toList();

    final List<AssetEntity> favoriteVideo = homeBloc.state.albumVideos
        .where((element) => homeBloc.state.listFavoriteId.contains(element.id))
        .toList();

    final List<AssetEntity> favoriteAssets = favoritePhotos + favoriteVideo;

    if (favoriteAssets.isEmpty) {
      getIt<AppRouter>().push(
        EmptyWarningRoute(
          title: S.current.youHaventSavedAnyImagesYet,
          message: '',
          messageWidget: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4.w,
                children: [
                  Text(
                    S.current.tapTheIcon,
                    style: AppStyles.bodyLRegular14(AppColors.dark200),
                  ),
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.blackD23.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Assets.icons.like.svg(width: 20.w, height: 20.h),
                  ),
                ],
              ),
              Text(
                S.current.toSaveTheImageToFavorites,
                style: AppStyles.bodyLRegular14(AppColors.dark200),
              ),
            ],
          ),
          backgroundImage: Assets.images.bgEmptyFavorite,
          verticalSpace: 410,
          isShowGoToHomeButton: false,
        ),
      );
      return;
    }
    getIt<AppRouter>().push(
      SlideWipeRoute(
        listPhotos: favoriteAssets,
        albumName: S.current.favorites,
        isAlbum: true,
      ),
    );
  }

  Future<void> _handleMyStatistics(
    Emitter<MoreState> emit,
    _MyStatistics event,
  ) async {
    getIt<AppRouter>().push(const MyStatisticsRoute());
  }

  Future<void> _handleLanguage(Emitter<MoreState> emit, _Language event) async {
    // Handle language logic here
    getIt<AppRouter>().push(LanguageRoute(isFirstOpenLanguage: false));
  }

  final homeBloc = getIt<HomeBloc>();
}
