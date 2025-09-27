import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' as pm;

import '../../../../di/di.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/utils/alert.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';
import '../../bottom_sheet/permission_bottom_sheet.dart';

part 'permission_bloc.freezed.dart';
part 'permission_event.dart';
part 'permission_state.dart';

@singleton
class PermissionBloc extends BaseBloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(const PermissionState()) {
    on<PermissionEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            emit(state.copyWith(pageStatus: PageStatus.Uninitialized));

            final bool isStorageGrant =
                (await pm.PhotoManager.getPermissionState(
                  requestOption: const pm.PermissionRequestOption(),
                )).hasAccess;

            final bool isNotificationGrant =
                await Permission.notification.isGranted;

            emit(
              state.copyWith(
                pageStatus: PageStatus.Loaded,
                isStorageGrant: isStorageGrant,
                isNotificationGrant: isNotificationGrant,
              ),
            );
            if (!_completer.isCompleted) {
              _completer.complete();
            }
            break;
          case _RequestPermission(permission: final permission):
            final bool status = event.isStoragePermission
                ? await requestStoragePermission(
                    event.titleDenied,
                    event.contentDenied,
                  )
                : await requestPermission(
                    event.permission,
                    event.titleDenied,
                    event.contentDenied,
                  );
            if (permission == Permission.notification) {
              emit(state.copyWith(isNotificationGrant: status));
            }

            if (event.isStoragePermission) {
              emit(state.copyWith(isStorageGrant: status));
            }
            break;
          case _NextScreen():
            getIt<AppRouter>().replace(const HomeRoute());
            break;
          case _RequestMultiPermission():
            for (int i = 0; i < event.permissions.length; i++) {
              final Permission permission = event.permissions[i];
              final bool status = await requestPermission(
                permission,
                event.listTitleDenied[i],
                event.listContentDenied[i],
              );
              if (permission == Permission.notification) {
                emit(state.copyWith(isNotificationGrant: status));
              }
            }

            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  Future<bool> requestPermission(
    Permission permission,
    String? titleDenied,
    String? contentDenied,
  ) async {
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await AppAlertDialog.show(
        type: AppAlertType.permission,
        title: titleDenied ?? S.current.permissionDenied,
        message:
            contentDenied ??
            S.current.youNeedToAllowThisPermissionToUseTheFeature,
        onConfirmBtnTap: () async {
          await openAppSettings();
        },
      );

      return await permission.isGranted;
    } else {
      await permission.request();
      status = await permission.status;
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> requestStoragePermission(
    String? titleDenied,
    String? contentDenied,
  ) async {
    pm.PermissionState permissionStatus =
        await pm.PhotoManager.getPermissionState(
          requestOption: const pm.PermissionRequestOption(),
        );
    if (permissionStatus.hasAccess) {
      return true;
    } else {
      permissionStatus = await pm.PhotoManager.requestPermissionExtend();
      if (permissionStatus.hasAccess) {
        return true;
      }

      await AppAlertDialog.show(
        type: AppAlertType.permission,
        title: titleDenied ?? S.current.permissionDenied,
        message:
            contentDenied ??
            S.current.youNeedToAllowThisPermissionToUseTheFeature,
        onConfirmBtnTap: () async {
          await openAppSettings();
        },
      );

      return false;
    }
  }

  Future<bool> checkAppPermission() async {
    if (isHasPermission()) {
      return true;
    }

    final context = getIt<AppRouter>().navigatorKey.currentContext;

    if (context == null) {
      return false;
    }

    await showModalBottomSheet(
      context: context,
      builder: (context) => const PermissionBottomSheet(),
      isScrollControlled: true, // cho phép chiếm toàn bộ chiều cao nếu cần
      isDismissible: false,
    );
    if (isHasPermission()) {
      return true;
    } else {
      return false;
    }
  }

  bool isHasPermission() {
    return state.isStorageGrant;
  }

  Future<void> waitForLoadData() async {
    if (!_completer.isCompleted) {
      await _completer.future;
    }
  }

  // Future<bool> requestMediaPermissions() async {
  //   if (getIt<AppBloc>().deviceAPILevel >= 33) {
  //     debugPrint('Requesting photos permissions for Android 13+');
  //     return await requestPermission(Permission.photos);
  //   } else {
  //     debugPrint('Requesting storage permissions for Android 12 and below');
  //     return await requestPermission(Permission.storage);
  //   }
  // }

  final Completer<void> _completer = Completer<void>();
}
