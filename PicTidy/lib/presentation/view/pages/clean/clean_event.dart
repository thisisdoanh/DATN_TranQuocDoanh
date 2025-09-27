part of 'clean_bloc.dart';

@freezed
sealed class CleanEvent with _$CleanEvent {
  const factory CleanEvent.loadData() = _LoadData;
  const factory CleanEvent.onPressVideo() = _OnPressVideo;
  const factory CleanEvent.onPressPhoto() = _OnPressPhoto;
  const factory CleanEvent.onPressScreenShot() = _OnPressScreenShot;
  const factory CleanEvent.onPressSimilar() = _OnPressSimilar;
  const factory CleanEvent.onPressAlbum(Photo photo) =
      _OnPressAlbum;
}
