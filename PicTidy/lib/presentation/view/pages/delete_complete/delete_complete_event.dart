part of 'delete_complete_bloc.dart';

@freezed
sealed class DeleteCompleteEvent with _$DeleteCompleteEvent {
  const factory DeleteCompleteEvent.loadData(
    List<AssetEntity> listAssets,
    List<String> listIdsDeleted,
    List<String> listIdsAssetsFailedOrSkipped,
  ) = _LoadData;

  const factory DeleteCompleteEvent.backToHome() = _BackToHome;
}
