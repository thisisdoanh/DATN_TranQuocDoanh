part of 'permission_bloc.dart';

@freezed
abstract class PermissionState extends BaseState with _$PermissionState {
  const factory PermissionState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default(false) bool isStorageGrant,
    @Default(false) bool isNotificationGrant,
  }) = _PermissionState;

  const PermissionState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
