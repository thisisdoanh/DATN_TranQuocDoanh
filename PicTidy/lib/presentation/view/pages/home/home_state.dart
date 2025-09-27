part of 'home_bloc.dart';

@freezed
abstract class HomeState extends BaseState with _$HomeState {
  const factory HomeState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default(0) int currentPage,
    @Default(0) int freedInByte,
    @Default([]) List<Photo> albumPhoto,
    @Default([]) List<PhotoByMonthYear> albumPhotoByYear,
    @Default([]) List<AssetEntity> albumVideos,
    @Default([]) List<String> listFavoriteId,
  }) = _HomeState;

  const HomeState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
