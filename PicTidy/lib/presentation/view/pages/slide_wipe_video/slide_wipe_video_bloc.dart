import 'dart:async';

import 'package:awesome_video_player/awesome_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../di/di.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../resources/colors.dart';
import '../../../router/router.dart';
import '../home/home_bloc.dart';

part 'slide_wipe_video_bloc.freezed.dart';
part 'slide_wipe_video_event.dart';
part 'slide_wipe_video_state.dart';

@injectable
class SlideWipeVideoBloc
    extends BaseBloc<SlideWipeVideoEvent, SlideWipeVideoState> {
  SlideWipeVideoBloc() : super(const SlideWipeVideoState()) {
    on<SlideWipeVideoEvent>((event, emit) async {
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
          case _UpdateCntWipe():
            await _handleEventUpdateCntWipe(emit, event);
            break;
          case _OnPressFavorite():
            await _handleEventFavorite(emit, event);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  @override
  Future<void> close() {
    betterPlayerPlaylistStateKey.currentState?.betterPlayerPlaylistController
        ?.dispose();

    cardSwiperController.dispose();
    return super.close();
  }

  Future<void> _handleEventFavorite(
    Emitter<SlideWipeVideoState> emit,
    _OnPressFavorite event,
  ) async {
    getIt<HomeBloc>().add(HomeEvent.toggleFavorite(event.id));
  }

  Future<void> _handleEventUpdateCntWipe(
    Emitter<SlideWipeVideoState> emit,
    _UpdateCntWipe event,
  ) async {
    emit(state.copyWith(cntWipe: state.cntWipe + 1));
    betterPlayerPlaylistStateKey
        .currentState
        ?.betterPlayerPlaylistController
        ?.betterPlayerController
        ?.play();
  }

  Future<void> _handleEventLoadData(
    Emitter<SlideWipeVideoState> emit,
    _LoadData event,
  ) async {
    betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 9 / 16,
      fit: BoxFit.contain,
      placeholderOnTop: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      eventListener: (p0) {
        if (p0.betterPlayerEventType == BetterPlayerEventType.initialized &&
            state.cntWipe == 0) {
          betterPlayerPlaylistStateKey
              .currentState
              ?.betterPlayerPlaylistController
              ?.betterPlayerController
              ?.play();
          debugPrint(
            'BetterPlayerEventType.initialized: ${p0.betterPlayerEventType}',
          );
        }
      },
      allowedScreenSleep: false,
      autoPlay: false,
      fullScreenByDefault: false,
      looping: true,
      autoDispose: true,
      showPlaceholderUntilPlay: true,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        showControls: false,
        showControlsOnInitialize: false,
        backgroundColor: AppColors.black1E,
      ),
    );
    betterPlayerPlaylistConfiguration = const BetterPlayerPlaylistConfiguration(
      loopVideos: true,
      nextVideoDelay: Duration(milliseconds: 100),
    );
    emit(
      state.copyWith(
        pageStatus: PageStatus.Loaded,
        listVideos: event.listVideos,
      ),
    );
  }

  Future<void> _handleEventSwipe(
    Emitter<SlideWipeVideoState> emit,
    _OnSwipe event,
  ) async {
    final Set<String> updatedListIds = Set<String>.from(
      state.listIdsVideosDelete,
    );
    final bool isDelete = event.direction == CardSwiperDirection.left;
    final String photoId = state.listVideos[event.previousIndex].id;
    if (isDelete) {
      updatedListIds.add(photoId);
    }
    if (event.currentIndex == null ||
        event.currentIndex! >= state.listVideos.length) {
      getIt<AppRouter>().replace(
        ConfirmDeleteRoute(
          isVideo: true,
          listAssets: state.listVideos,
          listIdsAssetsDelete: updatedListIds.toList(),
        ),
      );

      return;
    }
    betterPlayerPlaylistStateKey.currentState?.betterPlayerPlaylistController
        ?.setupDataSource(event.currentIndex!);

    if (state.cntWipe % 4 == 2) {
      betterPlayerPlaylistStateKey
          .currentState
          ?.betterPlayerPlaylistController
          ?.betterPlayerController
          ?.pause();
    } else {
      betterPlayerPlaylistStateKey
          .currentState
          ?.betterPlayerPlaylistController
          ?.betterPlayerController
          ?.play();
    }

    emit(
      state.copyWith(
        currentIndex: event.currentIndex!,
        listIdsVideosDelete: updatedListIds.toList(),
        cntWipe: state.cntWipe + 1,
      ),
    );
  }

  Future<void> _handleEventUndo(
    Emitter<SlideWipeVideoState> emit,
    _OnPressUndo event,
  ) async {
    if (event.previousIndex != null) {
      final Set<String> updatedListIds = Set<String>.from(
        state.listIdsVideosDelete,
      );
      updatedListIds.removeWhere(
        (element) => element == state.listVideos[event.currentIndex].id,
      );

      betterPlayerPlaylistStateKey.currentState?.betterPlayerPlaylistController
          ?.setupDataSource(event.currentIndex);

      betterPlayerPlaylistStateKey
          .currentState
          ?.betterPlayerPlaylistController
          ?.betterPlayerController
          ?.play();

      emit(
        state.copyWith(
          currentIndex: event.currentIndex,
          listIdsVideosDelete: updatedListIds.toList(),
        ),
      );
    }
  }

  Future<void> _handleEventConfirmDelete(
    Emitter<SlideWipeVideoState> emit,
    _OnPressConfirmDelete event,
  ) async {
    final List<AssetEntity> deletedAssets = List.generate(
      state.currentIndex,
      (index) => state.listVideos[index],
    );
    getIt<AppRouter>().push(
      ConfirmDeleteRoute(
        listAssets: deletedAssets,
        listIdsAssetsDelete: state.listIdsVideosDelete,
        isVideo: true,
      ),
    );
  }

  Future<List<BetterPlayerDataSource>> setupData(
    List<AssetEntity> listVideo,
  ) async {
    for (final item in listVideo) {
      final file = await item.file;
      if (file == null || !file.existsSync()) {
        debugPrint('File is null for item: ${item.relativePath}');
        continue;
      }

      final path = file.path;

      debugPrint('Video path: $path');

      if (path.isNotEmpty) {
        dataSourceList.add(
          BetterPlayerDataSource(BetterPlayerDataSourceType.file, path),
        );
      }
    }

    return dataSourceList;
  }

  List<BetterPlayerDataSource> dataSourceList = [];
  late BetterPlayerConfiguration betterPlayerConfiguration;
  late BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration;
  final GlobalKey<BetterPlayerPlaylistState> betterPlayerPlaylistStateKey =
      GlobalKey();
  CardSwiperController cardSwiperController = CardSwiperController();
}
