import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart' as assets;
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../router/router.dart';
import '../home/home_bloc.dart';

part 'slide_wipe_bloc.freezed.dart';

part 'slide_wipe_event.dart';

part 'slide_wipe_state.dart';

@injectable
class SlideWipeBloc extends BaseBloc<SlideWipeEvent, SlideWipeState> {
  SlideWipeBloc() : super(const SlideWipeState()) {
    on<SlideWipeEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            await _handleEventLoadData(emit, event);
            break;
          case _OnPressUndo():
            await _handleEventUndo(emit, event);
            break;
          case _OnSwipe():
            await _handleEventSwipe(emit, event);
            break;
          case _OnPressConfirmDelete():
            await _handleEventConfirmDelete(emit, event);
            break;
          case _OnPressRemoveBG():
            await _handleEventRemoveBG(emit, event);
            break;
          case _OnPressFavorite():
            await _handleEventFavorite(emit, event);
            break;
          case _OnPressDownloadRemoveBG():
            await _handleEventDownloadRemoveBG(emit, event);
            break;
          case _ShowToast():
            await _handleEventShowToast(emit, event);
            break;
          case _BackFromRemoveBG():
            await _handleEventBackFromRemoveBG(emit, event);
            break;
          case _UpdateCntWipe():
            await _handleEventUpdateCntWipe(emit, event);
            break;
          case _UpdateEnhanceEdges():
            await _handleEventUpdateEnhanceEdges(emit, event);
            break;
          case _UpdateSmoothMask():
            await _handleEventUpdateSmoothMask(emit, event);
            break;
          case _UpdateThreshold():
            await _handleEventUpdateThreshold(emit, event);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  @override
  Future<void> close() {
    cardSwiperController.dispose();
    return super.close();
  }

  Future<void> _handleEventUpdateEnhanceEdges(
    Emitter<SlideWipeState> emit,
    _UpdateEnhanceEdges event,
  ) async {
    emit(state.copyWith(isEnhanceEdges: event.value));
  }

  Future<void> _handleEventUpdateSmoothMask(
    Emitter<SlideWipeState> emit,
    _UpdateSmoothMask event,
  ) async {
    emit(state.copyWith(isSmoothMask: event.value));
  }

  Future<void> _handleEventUpdateThreshold(
    Emitter<SlideWipeState> emit,
    _UpdateThreshold event,
  ) async {
    emit(state.copyWith(threshold: event.value));
  }

  Future<void> _handleEventUpdateCntWipe(
    Emitter<SlideWipeState> emit,
    _UpdateCntWipe event,
  ) async {
    emit(state.copyWith(cntWipe: state.cntWipe + 1));
  }

  Future<void> _handleEventBackFromRemoveBG(
    Emitter<SlideWipeState> emit,
    _BackFromRemoveBG event,
  ) async {
    emit(state.copyWith(isLoadingRemoveBG: false, removeBGBytes: null));
  }

  Future<void> _handleEventFavorite(
    Emitter<SlideWipeState> emit,
    _OnPressFavorite event,
  ) async {
    getIt<HomeBloc>().add(HomeEvent.toggleFavorite(event.id));
  }

  Future<void> _handleEventLoadData(
    Emitter<SlideWipeState> emit,
    _LoadData event,
  ) async {
    emit(
      state.copyWith(
        pageStatus: PageStatus.Loaded,
        listPhotos: event.listPhotos,
      ),
    );
  }

  Future<void> _handleEventRemoveBG(
    Emitter<SlideWipeState> emit,
    _OnPressRemoveBG event,
  ) async {
    emit(state.copyWith(isLoadingRemoveBG: true, removeBGBytes: null));
    final assetEntity = state.listPhotos[state.currentIndex];

    final imageByte = await assetEntity.originBytes;

    if (imageByte == null) {
      emit(state.copyWith(isLoadingRemoveBG: false, removeBGBytes: null));
      add(
        SlideWipeEvent.showToast(
          assets.Assets.icons.cancel.svg(width: 24.w, height: 24.h),
          S.current.somethingWentWrong,
        ),
      );

      return;
    }


    final outImg = await BackgroundRemover.instance.removeBg(
      imageByte,
      enhanceEdges: state.isEnhanceEdges,
      smoothMask: state.isSmoothMask,
      threshold: state.threshold,
    );

    final byteData = await outImg.toByteData(format: ui.ImageByteFormat.png);
    final removeBGBytes = byteData!.buffer.asUint8List();

    add(SlideWipeEvent.showToast(null, S.current.backgroundRemoved));
    emit(
      state.copyWith(isLoadingRemoveBG: false, removeBGBytes: removeBGBytes),
    );


  }

  Future<void> _handleEventDownloadRemoveBG(
    Emitter<SlideWipeState> emit,
    _OnPressDownloadRemoveBG event,
  ) async {
    showLoading();
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      if (state.removeBGBytes == null) {
        add(
          SlideWipeEvent.showToast(
            assets.Assets.icons.cancel.svg(width: 24.w, height: 24.h),
            S.current.somethingWentWrong,
          ),
        );
        hideLoading();
        return;
      }
      final fileName = (state.listPhotos[state.currentIndex].title ?? '')
          .split('.')
          .first;
      debugPrint('fileName: $fileName');
      final asset = await PhotoManager.editor.saveImage(
        state.removeBGBytes!,
        filename: '${fileName}_${DateTime.now().millisecondsSinceEpoch}.png',
        title: '${fileName}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      print("Lưu ảnh thành công: ${asset}");
      hideLoading();
      add(
        SlideWipeEvent.showToast(
          assets.Assets.icons.success.svg(width: 24.w, height: 24.h),
          S.current.downloadedSuccessfully,
        ),
      );
    } else {
      hideLoading();

      add(
        SlideWipeEvent.showToast(
          assets.Assets.icons.cancel.svg(width: 24.w, height: 24.h),
          S.current.somethingWentWrong,
        ),
      );
      print("Không có quyền truy cập thư viện");
    }
  }

  Future<void> _handleEventShowToast(
    Emitter<SlideWipeState> emit,
    _ShowToast event,
  ) async {
    await AppToast.instance.show(
      icon: event.icon,
      title: Text(
        event.title,
        style: AppStyles.titleLBold13(AppColors.light100),
      ),
      spacingIcon: 10.w,
      backgroundColor: AppColors.dark100.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(13.r),
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
      margin: EdgeInsets.only(top: 15.h),
      isUseAnimation: event.icon == null,
    );
  }

  Future<void> _handleEventSwipe(
    Emitter<SlideWipeState> emit,
    _OnSwipe event,
  ) async {
    final Set<String> updatedListIds = Set<String>.from(
      state.listIdsPhotosDelete,
    );
    final bool isDelete = event.direction == CardSwiperDirection.left;
    final String photoId = state.listPhotos[event.previousIndex].id;
    if (isDelete) {
      updatedListIds.add(photoId);
    }

    if (event.currentIndex == null ||
        event.currentIndex! >= state.listPhotos.length) {
      getIt<AppRouter>().replace(
        ConfirmDeleteRoute(
          isVideo: false,
          listAssets: state.listPhotos,
          listIdsAssetsDelete: updatedListIds.toList(),
        ),
      );

      return;
    }
    emit(
      state.copyWith(
        currentIndex: event.currentIndex!,
        listIdsPhotosDelete: updatedListIds.toList(),
        removeBGBytes: null,
        cntWipe: state.cntWipe + 1,
      ),
    );
  }

  Future<void> _handleEventUndo(
    Emitter<SlideWipeState> emit,
    _OnPressUndo event,
  ) async {
    if (event.previousIndex != null) {
      final Set<String> updatedListIds = Set<String>.from(
        state.listIdsPhotosDelete,
      );
      updatedListIds.removeWhere(
        (element) => element == state.listPhotos[event.currentIndex].id,
      );

      emit(
        state.copyWith(
          currentIndex: event.currentIndex,
          listIdsPhotosDelete: updatedListIds.toList(),
          removeBGBytes: null,
        ),
      );
    }
  }

  Future<void> _handleEventConfirmDelete(
    Emitter<SlideWipeState> emit,
    _OnPressConfirmDelete event,
  ) async {
    final List<AssetEntity> deletedAssets = List.generate(
      state.currentIndex,
      (index) => state.listPhotos[index],
    );

    getIt<AppRouter>().push(
      ConfirmDeleteRoute(
        listAssets: deletedAssets,
        listIdsAssetsDelete: state.listIdsPhotosDelete,
        isVideo: false,
      ),
    );
  }

  CardSwiperController cardSwiperController = CardSwiperController();
}
