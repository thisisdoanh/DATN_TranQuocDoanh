part of 'slide_wipe_video_bloc.dart';

@freezed
abstract class SlideWipeVideoState extends BaseState
    with _$SlideWipeVideoState {
  const factory SlideWipeVideoState({
    @Default(PageStatus.Uninitialized) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default([]) List<AssetEntity> listVideos,
    @Default([]) List<String> listIdsVideosDelete,
    @Default(0) int currentIndex,
    @Default(0) int cntWipe,
  }) = _SlideWipeVideoState;

  const SlideWipeVideoState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
