part of 'confirm_delete_bloc.dart';

@freezed
abstract class ConfirmDeleteState extends BaseState with _$ConfirmDeleteState {
  const factory ConfirmDeleteState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default([]) List<AssetEntity> listAssets,
    @Default([]) List<String> listIdsAssetsDelete,
  }) = _ConfirmDeleteState;

  const ConfirmDeleteState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
