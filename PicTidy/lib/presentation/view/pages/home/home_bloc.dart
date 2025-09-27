import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../data/local/local_repository.dart';
import '../../../../di/di.dart';
import '../../../../domain/entities/photo.dart';
import '../../../../domain/entities/photo_by_month_year.dart';
import '../../../../domain/usecases/get_all_photo_by_month_year_use_case.dart';
import '../../../../domain/usecases/get_all_photo_use_case.dart';
import '../../../../domain/usecases/get_all_video_use_case.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/utils/app_log.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../router/router.dart';
import '../../../widgets/app_animation_skeleton.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../permission/permission_bloc.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@singleton
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc(
    this._getAllVideoUseCase,
    this._getAllPhotoUseCase,
    this._getAllPhotoByMonthYearUseCase,
    this.permissionBloc,
  ) : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            emit(state.copyWith(pageStatus: PageStatus.Loaded));
            PhotoManager.addChangeCallback(
              (value) => add(const HomeEvent.getPhotoAndVideo()),
            );
            PhotoManager.startChangeNotify();
            break;
          case _GetPhotoAndVideo():
            if (isCallingGetPhotoAndVideo) {
              return;
            }

            bool isGrantedPermission = permissionBloc.isHasPermission();

            if (!isGrantedPermission) {
              isGrantedPermission = await permissionBloc.checkAppPermission();
              if (!isGrantedPermission) {
                return;
              } else {
                getIt<HomeBloc>().add(const HomeEvent.getPhotoAndVideo());
                return;
              }
            }

            showPrepareData();
            final freedInBytes = LocalRepository.instance
                .getByteAllDataDeleteImage();
            final listFavorite = LocalRepository.instance.getAllFavorite();
            final albumPhotoTemp = await _getAllPhotoUseCase.call(
              params: GetAllPhotoParam(),
            );

            final albumPhotoByMonthTemp = await _getAllPhotoByMonthYearUseCase
                .call(params: GetAllPhotoByMonthYearParam());

            final albumVideosTemp = await _getAllVideoUseCase.call(
              params: GetAllVideoParam(),
            );

            for (final photo in albumPhotoTemp) {
              final image = photo.photos.first;

              AppLog.info(
                'Photo: ${photo.albumName}, ID: ${image.id}, Size: ${image.size}, path: ${image.relativePath}',
                tag: 'albumPhotoTemp',
              );
            }

            emit(
              state.copyWith(
                pageStatus: PageStatus.Loaded,
                albumPhoto: albumPhotoTemp,
                albumVideos: albumVideosTemp,
                albumPhotoByYear: albumPhotoByMonthTemp,
                freedInByte: freedInBytes,
                listFavoriteId: listFavorite,
              ),
            );
            hidePrepareData();

            break;
          case _ChangeTab():
            emit(state.copyWith(currentPage: event.index));
            break;
          case _ToggleFavorite():
            await _handleToggleFavorite(emit, event);
            break;
          case _DeleteIds():
            await _handleDeleteId(emit, event);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  @override
  Future<void> close() async {
    PhotoManager.removeChangeCallback(
      (value) => add(const HomeEvent.getPhotoAndVideo()),
    );
    PhotoManager.stopChangeNotify();
    super.close();
  }

  Future<void> _handleToggleFavorite(
    Emitter<HomeState> emit,
    _ToggleFavorite event,
  ) async {
    await LocalRepository.instance.toggleFavorite(event.id);
    final listFavorite = LocalRepository.instance.getAllFavorite();
    emit(state.copyWith(listFavoriteId: listFavorite));
  }

  void showPrepareData() {
    if (getIt<AppRouter>().current.name != HomeRoute.name) {
      return;
    }
    final context = getIt<AppRouter>().navigatorKey.currentContext;
    if (context == null) {
      return;
    }
    isCallingGetPhotoAndVideo = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      builder: (_) {
        return PopScope(
          canPop: false,
          child: CustomAlertDialog(
            top: Center(
              child: SizedBox(
                width: 60.w,
                height: 60.w / 3,
                child: AppAnimationSkeleton(
                  atlasPath: Assets.anim.skeletonAtlas,
                  skeletonPath: Assets.anim.skeletonJson,
                  animation: 'animation2',
                ),
              ),
            ),
            topPadding: EdgeInsets.only(top: 24.h, bottom: 24.h),
            title: Text(
              S.of(context).yourPhotoIsBeingPreparedForSwipingPleaseWaitA,
              textAlign: TextAlign.center,
            ),
            titleTextStyle: AppStyles.bodyLMedium14(AppColors.dark100),
            titlePadding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 24.h),
          ),
        );
      },
    );
  }

  void hidePrepareData() {
    if (getIt<AppRouter>().current.name != HomeRoute.name) {
      return;
    }
    isCallingGetPhotoAndVideo = false;
    getIt<AppRouter>().popUntil(
      (route) => route.settings.name == HomeRoute.name,
    );
  }

  Future<void> _handleDeleteId(
    Emitter<HomeState> emit,
    _DeleteIds event,
  ) async {
    final resultIds = event.listIds;
    final updatedAlbumPhoto = state.albumPhoto.map((photo) {
      final filteredAssets = photo.photos
          .where((asset) => !resultIds.contains(asset.id))
          .toList();
      return photo.copyWith(photos: filteredAssets);
    }).toList();

    final updatedAlbumPhotoByYear = state.albumPhotoByYear.map((year) {
      final updatedMonths = year.months.map((month) {
        final filteredAssets = month.photos
            .where((asset) => !resultIds.contains(asset.id))
            .toList();
        return month.copyWith(photos: filteredAssets);
      }).toList();

      return year.copyWith(months: updatedMonths);
    }).toList();

    final updatedAlbumVideos = state.albumVideos
        .where((video) => !resultIds.contains(video.id))
        .toList();

    emit(
      state.copyWith(
        albumPhoto: updatedAlbumPhoto,
        albumPhotoByYear: updatedAlbumPhotoByYear,
        albumVideos: updatedAlbumVideos,
      ),
    );
  }

  final PermissionBloc permissionBloc;
  final GetAllVideoUseCase _getAllVideoUseCase;
  final GetAllPhotoUseCase _getAllPhotoUseCase;
  final GetAllPhotoByMonthYearUseCase _getAllPhotoByMonthYearUseCase;

  bool isCallingGetPhotoAndVideo = false;
}
