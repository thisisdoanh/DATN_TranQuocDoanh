part of 'slide_wipe_bloc.dart';

@freezed
sealed class SlideWipeEvent with _$SlideWipeEvent {
  const factory SlideWipeEvent.loadData(List<AssetEntity> listPhotos) =
      _LoadData;

  const factory SlideWipeEvent.onPressUndo(
    int? previousIndex,
    int currentIndex,
  ) = _OnPressUndo;

  const factory SlideWipeEvent.onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) = _OnSwipe;

  const factory SlideWipeEvent.onPressConfirmDelete() = _OnPressConfirmDelete;

  const factory SlideWipeEvent.onPressRemoveBG() = _OnPressRemoveBG;

  const factory SlideWipeEvent.onPressFavorite(String id) = _OnPressFavorite;

  const factory SlideWipeEvent.onPressDownloadRemoveBG() =
      _OnPressDownloadRemoveBG;

  const factory SlideWipeEvent.showToast(Widget? icon, String title) =
      _ShowToast;

  const factory SlideWipeEvent.backFromRemoveBG() = _BackFromRemoveBG;

  const factory SlideWipeEvent.updateCntWipe() = _UpdateCntWipe;

  const factory SlideWipeEvent.updateEnhanceEdges(bool value) = _UpdateEnhanceEdges;
  const factory SlideWipeEvent.updateSmoothMask(bool value) = _UpdateSmoothMask;
  const factory SlideWipeEvent.updateThreshold(double value) = _UpdateThreshold;
}
