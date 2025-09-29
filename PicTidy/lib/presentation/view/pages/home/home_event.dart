part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadData() = _LoadData;
  const factory HomeEvent.getPhotoAndVideo() = _GetPhotoAndVideo;
  const factory HomeEvent.changeTab(int index) = _ChangeTab;
  const factory HomeEvent.toggleFavorite(String id) = _ToggleFavorite;
  const factory HomeEvent.deleteIds(List<String> listIds) = _DeleteIds;
}
