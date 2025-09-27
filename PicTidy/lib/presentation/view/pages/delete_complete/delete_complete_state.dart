part of 'delete_complete_bloc.dart';

@freezed
abstract class DeleteCompleteState extends BaseState
    with _$DeleteCompleteState {
  const factory DeleteCompleteState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default([]) List<AssetEntity> listAssets,
    @Default([]) List<String> listIdsDeleted,
    @Default([]) List<String> listIdsAssetsFailedOrSkipped,
  }) = _DeleteCompleteState;

  const DeleteCompleteState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
