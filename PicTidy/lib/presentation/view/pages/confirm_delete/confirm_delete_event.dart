part of 'confirm_delete_bloc.dart';

@freezed
sealed class ConfirmDeleteEvent with _$ConfirmDeleteEvent {
  const factory ConfirmDeleteEvent.loadData(
    List<AssetEntity> listAssets,
    List<String> listIdsDelete,
  ) = _LoadData;
  const factory ConfirmDeleteEvent.togglePhotoSelection(int index) =
      _TogglePhotoSelection;
  const factory ConfirmDeleteEvent.confirmDelete() = _ConfirmDelete;
}
