part of 'permission_bloc.dart';

@freezed
sealed class PermissionEvent with _$PermissionEvent {
  const factory PermissionEvent.loadData() = _LoadData;

  const factory PermissionEvent.requestPermission(
    Permission permission,
    String? titleDenied,
    String? contentDenied,
    bool isStoragePermission,
  ) = _RequestPermission;

  const factory PermissionEvent.requestMultiPermission(
    List<Permission> permissions,
    List<String> listTitleDenied,
    List<String> listContentDenied,
  ) = _RequestMultiPermission;

  const factory PermissionEvent.nextScreen() = _NextScreen;
}
