part of 'slide_wipe_bloc.dart';

@freezed
abstract class SlideWipeState extends BaseState with _$SlideWipeState {
  const factory SlideWipeState({
    @Default(PageStatus.Uninitialized) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default([]) List<AssetEntity> listPhotos,
    @Default([]) List<String> listIdsPhotosDelete,
    @Default(0) int currentIndex,
    @Default(null) Uint8List? removeBGBytes,
    @Default(false) isLoadingRemoveBG,
    @Default(0) int cntWipe,
    @Default(0.5) double threshold,
    @Default(true) bool isSmoothMask,
    @Default(true) bool isEnhanceEdges,
  }) = _SlideWipeState;

  const SlideWipeState._({
    super.pageStatus = PageStatus.Uninitialized,
    super.pageErrorMessage,
  });
}
