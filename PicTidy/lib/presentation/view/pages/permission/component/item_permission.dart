import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../di/di.dart';
import '../../../../../generated/l10n.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/styles.dart';
import '../permission_bloc.dart';

class ItemPermission extends StatelessWidget {
  const ItemPermission({
    super.key,
    required this.permission,
    required this.title,
    required this.status,
    required this.borderRadius,
  });

  final Permission permission;
  final String title;
  final bool status;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.light200,
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.titleXLSemi16(AppColors.dark100),
            ),
          ),
          Switch(
            value: status,
            onChanged: (value) {
              if (permission == Permission.notification) {
                getIt<PermissionBloc>().add(
                  PermissionEvent.requestPermission(
                    permission ?? Permission.notification,
                    S.of(context).notificationPermission,
                    S
                        .of(context)
                        .youMustGrantNotificationPermissionToUseThisApp,
                    false,
                  ),
                );
                return;
              }

              if (permission == Permission.storage) {
                getIt<PermissionBloc>().add(
                  PermissionEvent.requestPermission(
                    permission,
                    S.of(context).storagePermission,
                    S.of(context).youMustGrantStoragePermissionToUseThisApp,
                    true,
                  ),
                );
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
