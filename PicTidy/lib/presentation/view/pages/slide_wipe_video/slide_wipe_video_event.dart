part of 'slide_wipe_video_bloc.dart';

@freezed
sealed class SlideWipeVideoEvent with _$SlideWipeVideoEvent {
  const factory SlideWipeVideoEvent.loadData({
    required List<AssetEntity> listVideos,
  }) = _LoadData;

  const factory SlideWipeVideoEvent.onPressUndo(
    int? previousIndex,
    int currentIndex,
  ) = _OnPressUndo;

  const factory SlideWipeVideoEvent.onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) = _OnSwipe;

  const factory SlideWipeVideoEvent.onPressConfirmDelete() =
      _OnPressConfirmDelete;

  const factory SlideWipeVideoEvent.updateCntWipe() = _UpdateCntWipe;

  const factory SlideWipeVideoEvent.onPressFavorite(String id) =
      _OnPressFavorite;
}
