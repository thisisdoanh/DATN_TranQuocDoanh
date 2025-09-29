import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../di/di.dart';
import '../../../../domain/entities/photo.dart';
import '../../../../domain/entities/photo_by_month_year.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/extension/datetime.dart';
import '../../../../shared/extension/iterable.dart';
import '../../../../shared/utils/app_log.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../router/router.dart';
import '../../bottom_sheet/random_bottom_sheet.dart';
import '../home/home_bloc.dart';
import '../permission/permission_bloc.dart';

part 'memory_bloc.freezed.dart';
part 'memory_event.dart';
part 'memory_state.dart';

@injectable
class MemoryBloc extends BaseBloc<MemoryEvent, MemoryState> {
  MemoryBloc(this.homeBloc) : super(const MemoryState()) {
    homeSubscription = homeBloc.stream.listen((homeState) {
      add(const MemoryEvent.loadData());
    });

    on<MemoryEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            await _handleEventLoadData(emit, event);
            break;
          case _Recent():
            await _handleEventRecent(emit, event);
            break;
          case _Random():
            await _handleEventRandom(emit, event);
            break;
          case _OnPressMonth():
            await _handleEventPressMonth(emit, event);
            break;
          case _Memory():
            await _handleEventMemory(emit, event);
            break;
          case _OnPressAnything():
            await _handleEventPressAnything(emit, event);
            break;
          case _OnPressScreenshots():
            await _handleEventPressScreenshots(emit, event);
            break;
          case _OnPressPhoto():
            await _handleEventPressPhoto(emit, event);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }
  @override
  Future<void> close() async {
    await homeSubscription.cancel();
    return super.close();
  }

  Future<void> _handleEventLoadData(
    Emitter<MemoryState> emit,
    _LoadData event,
  ) async {
    final List<AssetEntity> allPhoto = homeBloc.state.albumPhoto
        .firstWhere(
          (element) => element.isAll == true,
          orElse: () => const Photo(albumName: 'empty'),
        )
        .photos;

    final listMemory = allPhoto
        .where(
          (element) =>
              element.createDateTime.isSameOnlyDateMonth(DateTime.now()),
        )
        .toList();

    final listRecent = getListAssetEntityFromDateTime(
      allPhoto,
      DateTime.now(),
      DateTime.now().subtract(const Duration(days: 5)),
    );

    emit(
      state.copyWith(
        pageStatus: PageStatus.Loaded,
        listMemory: listMemory,
        listRecent: listRecent,
      ),
    );
  }

  Future<void> _handleEventMemory(
    Emitter<MemoryState> emit,
    _Memory event,
  ) async {
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
    _handleTimeClick(
      state.listMemory,
      S.current.noThrowbackKnockingOnYourDoorToday,
      S.current.butWhoKnowsTomorrowMightBringSomethingSpecial,
      Assets.images.bgEmptyMemoryRecent,
      true,
    );
  }

  Future<void> _handleEventRecent(
    Emitter<MemoryState> emit,
    _Recent event,
  ) async {
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
    _handleTimeClick(
      state.listRecent,
      S.current.nothingFromThePast5Days,
      S.current.theRecentlyFolderWillDisplayPhotosYouHaventViewedIn,
      Assets.images.bgEmptyMemoryRecent,
      false,
    );
  }

  Future<void> _handleEventRandom(
    Emitter<MemoryState> emit,
    _Random event,
  ) async {
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

    final context = getIt<AppRouter>().navigatorKey.currentContext;
    if (context == null) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => RandomBottomSheet(
        onAnythingPressed: () {
          add(const MemoryEvent.onPressAnything());
        },
        onScreenshotsPressed: () {
          add(const MemoryEvent.onPressScreenshots());
        },
        onPhotosPressed: () {
          add(const MemoryEvent.onPressPhoto());
        },
      ),
      isScrollControlled: true, // cho phép chiếm toàn bộ chiều cao nếu cần
      isDismissible: false,
    );
  }

  Future<void> _handleEventPressMonth(
    Emitter<MemoryState> emit,
    _OnPressMonth event,
  ) async {
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
    if (event.album.photos.isEmpty) {
      getIt<AppRouter>().push(
        EmptyWarningRoute(
          title: S.current.thisAlbumHasNoPhotosYet,
          message: S.current.addSomePhotosToStartSavingYourPreciousMoments,
          backgroundImage: Assets.images.bgEmptyAlbum,
          isShowGoToHomeButton: false,
        ),
      );
      return;
    }
    getIt<AppRouter>().push(
      SlideWipeRoute(
        listPhotos: event.album.photos,
        isMonth: true,
        albumName: '${event.album.month} ${event.album.year}',
      ),
    );
  }

  List<AssetEntity> getListAssetEntityFromDateTime(
    List<AssetEntity> assets,
    DateTime dateTime,
    DateTime? dateTimeEnd,
  ) {
    if (dateTimeEnd == null) {
      return assets
          .where((element) => element.createDateTime.isSameDate(dateTime))
          .toList();
    } else {
      AppLog.info(dateTimeEnd.zeroTime(), tag: 'dateTimeEnd');
      return assets
          .where(
            (element) =>
                element.createDateTime.isAfterOrEqualTo(dateTimeEnd.zeroTime()),
          )
          .toList();
    }
  }

  void _handleTimeClick(
    List<AssetEntity> assets,
    String titleEmpty,
    String messageEmpty,
    AssetGenImage imageEmpty,
    bool isMemory,
  ) {
    if (assets.isNotEmpty) {
      getIt<AppRouter>().push(
        SlideWipeRoute(
          listPhotos: assets,
          isAlbum: true,
          isMemory: isMemory,
          albumName: S.current.recently,
        ),
      );
    } else {
      getIt<AppRouter>().push(
        EmptyWarningRoute(
          title: titleEmpty,
          message: messageEmpty,
          backgroundImage: imageEmpty,
          isShowGoToHomeButton: true,
        ),
      );
    }
  }

  Future<void> _handleEventShowToast() async {
    await AppToast.instance.show(
      icon: Assets.icons.fileImage.svg(width: 18.w, height: 24.h),
      title: Text(
        S.current.thereAreNoImagesInThisSection,
        style: AppStyles.titleLBold13(AppColors.light100),
      ),
      spacingIcon: 10.w,
      backgroundColor: AppColors.dark100.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(13.r),
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
      margin: EdgeInsets.only(bottom: 40.h),
      position: ToastPosition.bottom,
    );
  }

  Future<void> _handleEventPressAnything(
    Emitter<MemoryState> emit,
    _OnPressAnything event,
  ) async {
    final albumAnything = homeBloc.state.albumPhoto
        .safeFirstWhere((element) => element.isAll == true)
        ?.photos
        .toList();

    if (albumAnything == null || albumAnything.isEmpty) {
      _handleEventShowToast();
      return;
    }
    getIt<AppRouter>().pop();

    _goToSlideWipeRoute(albumAnything);
  }

  Future<void> _handleEventPressScreenshots(
    Emitter<MemoryState> emit,
    _OnPressScreenshots event,
  ) async {
    final albumScreenshot = homeBloc.state.albumPhoto.safeFirstWhere(
      (element) =>
          element.albumName.toLowerCase() == 'screenshot' ||
          element.albumName.toLowerCase() == 'screenshots',
    );
    if (albumScreenshot == null || albumScreenshot.photos.isEmpty) {
      _handleEventShowToast();
      return;
    }
    getIt<AppRouter>().pop();

    _goToSlideWipeRoute(albumScreenshot.photos);
  }

  Future<void> _handleEventPressPhoto(
    Emitter<MemoryState> emit,
    _OnPressPhoto event,
  ) async {
    final albumCamera = homeBloc.state.albumPhoto.safeFirstWhere(
      (element) =>
          element.albumName.toLowerCase() == 'camera' ||
          element.albumName.toLowerCase() == 'cameras',
    );
    if (albumCamera == null || albumCamera.photos.isEmpty) {
      _handleEventShowToast();
      return;
    }
    getIt<AppRouter>().pop();
    _goToSlideWipeRoute(albumCamera.photos);
  }

  void _goToSlideWipeRoute(List<AssetEntity> photos) {
    final shuffledPhotos = List<AssetEntity>.from(photos)..shuffle();

    getIt<AppRouter>().push(
      SlideWipeRoute(
        listPhotos: shuffledPhotos.sublist(0, min(20, shuffledPhotos.length)),
      ),
    );
  }

  final HomeBloc homeBloc;
  final permissionBloc = getIt<PermissionBloc>();
  late StreamSubscription homeSubscription;
}
