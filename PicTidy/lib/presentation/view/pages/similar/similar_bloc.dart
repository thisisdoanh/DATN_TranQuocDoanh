import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pictidy/presentation/view/pages/home/home_bloc.dart';
import 'package:pictidy/shared/extension/iterable.dart';
import 'package:pictidy/shared/utils/find_similar_utils.dart';

import '../../../../app_bloc.dart';
import '../../../../data/local/local_repository.dart';
import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../router/router.dart';
import '../../../widgets/app_animation_skeleton.dart';
import '../../../widgets/custom_alert_dialog.dart';

part 'similar_bloc.freezed.dart';

part 'similar_event.dart';

part 'similar_state.dart';

@injectable
class SimilarBloc extends BaseBloc<SimilarEvent, SimilarState> {
  SimilarBloc(this.appBloc, this.homeBloc) : super(const SimilarState()) {
    on<SimilarEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            await _handleEventLoadData(emit, event);
            break;
          case _FindSimilar():
            await _handleFindSimilar(emit, event);
            break;
          case _FindExact():
            await _handleFindExact(emit, event);
            break;
          case _OnToggleTab():
            await _handleOnToggleTab(emit, event);
            break;
          case _TogglePhotoSelection():
            await _handleEventTogglePhotoSelection(emit, event);
            break;
          case _ConfirmDelete():
            await _handleConfirmDelete(emit, event);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  Future<void> _handleEventLoadData(
    Emitter<SimilarState> emit,
    _LoadData event,
  ) async {
    showPrepareData();
    final allPhoto =
        homeBloc.state.albumPhoto
            .safeFirstWhere((element) => element.isAll == true)
            ?.photos ??
        [];
    await FindSimilarUtils.instance.calculateAllAssetInfo(allPhoto);
    hidePrepareData();
    emit(state.copyWith(pageStatus: PageStatus.Loaded));
    add(SimilarEvent.findSimilar());
    add(SimilarEvent.findExact());
    add(SimilarEvent.onToggleTab(0));
  }

  Future<void> _handleFindSimilar(
    Emitter<SimilarState> emit,
    _FindSimilar event,
  ) async {
    final listAsset = FindSimilarUtils.instance.findSimilarAssets(8);
    emit(state.copyWith(listSetSimilar: listAsset));
  }

  Future<void> _handleFindExact(
    Emitter<SimilarState> emit,
    _FindExact event,
  ) async {
    final listAsset = FindSimilarUtils.instance.findExactDuplicateAssets();
    emit(state.copyWith(listSetExact: listAsset));
  }

  Future<void> _handleOnToggleTab(
    Emitter<SimilarState> emit,
    _OnToggleTab event,
  ) async {
    final listSetShow = event.index == 0
        ? state.listSetSimilar
        : state.listSetExact;

    final listAsset = listSetShow.expand((e) => e).toList();
    emit(
      state.copyWith(
        indexTab: event.index,
        listAssets: listAsset,
        listIdsAssetsDelete: [],
      ),
    );
  }

  Future<void> _handleEventTogglePhotoSelection(
    Emitter<SimilarState> emit,
    _TogglePhotoSelection event,
  ) async {
    final updatedListIndex = List<String>.from(state.listIdsAssetsDelete);
    final photoIds = event.asset.id;
    if (updatedListIndex.contains(photoIds)) {
      updatedListIndex.remove(photoIds);
    } else {
      updatedListIndex.add(photoIds);
    }
    emit(state.copyWith(listIdsAssetsDelete: updatedListIndex));
  }

  Future<void> _handleConfirmDelete(
    Emitter<SimilarState> emit,
    _ConfirmDelete event,
  ) async {
    final result = await PhotoManager.editor.deleteWithIds(
      state.listIdsAssetsDelete,
    );

    if (result.isNotEmpty) {
      getIt<HomeBloc>().add(HomeEvent.deleteIds(result));

      final Set<String> failedOrSkippedIds = state.listAssets
          .map((asset) => asset.id)
          .toSet()
          .difference(result.toSet());

      await LocalRepository.instance.saveDeleteImageData(
        DateTime.now(),
        sizeInBytes,
        result.length,
        failedOrSkippedIds.length,
      );

      getIt<AppRouter>().replace(
        DeleteCompleteRoute(
          listAssets: state.listAssets,
          listIdsAssetsDeleted: result,
          listIdsAssetsFailedOrSkipped: failedOrSkippedIds.toList(),
          isVideo: false,
        ),
      );
    }
  }

  void showPrepareData() {
    if (getIt<AppRouter>().current.name != SimilarRoute.name) {
      return;
    }
    final context = getIt<AppRouter>().navigatorKey.currentContext;
    if (context == null) {
      return;
    }
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
              S.of(context).preparingDataPleaseWaitAMoment,
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
    if (getIt<AppRouter>().current.name != SimilarRoute.name) {
      return;
    }
    getIt<AppRouter>().popUntil(
      (route) => route.settings.name == SimilarRoute.name,
    );
  }

  final AppBloc appBloc;
  final HomeBloc homeBloc;
  int sizeInBytes = 0;
}
