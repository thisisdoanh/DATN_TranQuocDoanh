import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../di/di.dart';
import '../../../../domain/entities/photo.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/extension/iterable.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';
import '../home/home_bloc.dart';
import '../permission/permission_bloc.dart';

part 'clean_bloc.freezed.dart';

part 'clean_event.dart';

part 'clean_state.dart';

@injectable
class CleanBloc extends BaseBloc<CleanEvent, CleanState> {
  CleanBloc() : super(const CleanState()) {
    on<CleanEvent>((event, emit) async {
      try {
        final homeBloc = getIt<HomeBloc>();
        switch (event) {
          case _LoadData():
            emit(state.copyWith(pageStatus: PageStatus.Loaded));
            break;
          case _OnPressSimilar():
            await _handleEventSimilar(emit, event);
            break;
          case _OnPressVideo():
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
            if (homeBloc.state.albumVideos.isEmpty) {
              getIt<AppRouter>().push(
                EmptyWarningRoute(
                  title: S.current.thereAreNoVideoHereYet,
                  message: S.current.addSomeFunVideosToSpiceThingsUp,
                  backgroundImage: Assets.images.bgEmptyVideo,
                  isShowGoToHomeButton: false,
                  verticalSpace: 410,
                ),
              );
              return;
            }
            getIt<AppRouter>().push(
              SlideWipeVideoRoute(listVideos: homeBloc.state.albumVideos),
            );
            break;
          case _OnPressPhoto():
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
            final albumCamera = homeBloc.state.albumPhoto.safeFirstWhere(
              (element) =>
                  element.albumName.toLowerCase() == 'camera' ||
                  element.albumName.toLowerCase() == 'cameras',
            );
            if (albumCamera == null || albumCamera.photos.isEmpty) {
              getIt<AppRouter>().push(
                EmptyWarningRoute(
                  title: S.current.thereAreNoPhotosHereYet,
                  message: S.current.addAFewPicsAndLetTheFunBegin,
                  backgroundImage: Assets.images.bgEmptyPhotoScreenshot,
                  isShowGoToHomeButton: false,
                  verticalSpace: 410,
                ),
              );
              return;
            }

            getIt<AppRouter>().push(
              SlideWipeRoute(listPhotos: albumCamera.photos),
            );
            break;
          case _OnPressScreenShot():
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

            final albumScreenshot = homeBloc.state.albumPhoto.safeFirstWhere(
              (element) =>
                  element.albumName.toLowerCase() == 'screenshot' ||
                  element.albumName.toLowerCase() == 'screenshots',
            );
            if (albumScreenshot == null || albumScreenshot.photos.isEmpty) {
              getIt<AppRouter>().push(
                EmptyWarningRoute(
                  title: S.current.thereAreNoPhotosHereYet,
                  message: S.current.addAFewPicsAndLetTheFunBegin,
                  backgroundImage: Assets.images.bgEmptyPhotoScreenshot,
                  isShowGoToHomeButton: false,
                  verticalSpace: 410,
                ),
              );
              return;
            }

            getIt<AppRouter>().push(
              SlideWipeRoute(listPhotos: albumScreenshot.photos),
            );
            break;
          case _OnPressAlbum():
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

            if (event.photo.photos.isEmpty) {
              getIt<AppRouter>().push(
                EmptyWarningRoute(
                  title: S.current.thisAlbumHasNoPhotosYet,
                  message:
                      S.current.addSomePhotosToStartSavingYourPreciousMoments,
                  backgroundImage: Assets.images.bgEmptyAlbum,
                  verticalSpace: 410,
                  isShowGoToHomeButton: false,
                ),
              );
              return;
            }
            getIt<AppRouter>().push(
              SlideWipeRoute(
                listPhotos: event.photo.photos,
                isAlbum: true,
                albumName: event.photo.albumName,
              ),
            );
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  Future<void> _handleEventSimilar(
    Emitter<CleanState> emit,
    _OnPressSimilar event,
  ) async {
    getIt<AppRouter>().push(SimilarRoute());
  }

  final permissionBloc = getIt<PermissionBloc>();
}
