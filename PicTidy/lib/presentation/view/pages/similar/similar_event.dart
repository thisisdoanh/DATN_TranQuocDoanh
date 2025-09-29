part of 'similar_bloc.dart';

@freezed
sealed class SimilarEvent with _$SimilarEvent {
  const factory SimilarEvent.loadData() = _LoadData;
  const factory SimilarEvent.findSimilar() = _FindSimilar;
  const factory SimilarEvent.findExact() = _FindExact;
  const factory SimilarEvent.onToggleTab(int index) = _OnToggleTab;
  const factory SimilarEvent.togglePhotoSelection(AssetEntity asset) =
  _TogglePhotoSelection;
  const factory SimilarEvent.confirmDelete() = _ConfirmDelete;}