import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../di/di.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../shared/constant/app_constant.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../widgets/app_dialog.dart';
import '../pages/permission/component/item_permission.dart';
import '../pages/permission/permission_bloc.dart';

class PermissionBottomSheet extends StatelessWidget {
  const PermissionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      widthDialog: 360.w,
      topWidget: Text(
        S.current.permission,
        style: AppStyles.titleXXLSemi20(AppColors.black),
      ),
      topPadding: EdgeInsets.only(top: 24.h, bottom: 46.h),
      titleWidget: Assets.images.permission.image(width: 125.w, height: 125.h),

      messageWidget: Text(
        S
            .of(context)
            .appnameRequiresPermissionToUseTheDevicesFunction(
              AppConstant.appName,
            ),
        style: AppStyles.bodyXLRegular16(AppColors.dark100),
        textAlign: TextAlign.center,
      ),
      messagePadding: EdgeInsets.only(
        top: 25.h,
        bottom: 20.h,
        left: 16.w,
        right: 16.w,
      ),
      bottomWidget: BlocBuilder<PermissionBloc, PermissionState>(
        bloc: getIt<PermissionBloc>(),
        builder: (context, state) {
          return Column(
            spacing: 20.h,
            children: [
              ItemPermission(
                permission: Permission.storage,
                title: S.of(context).storage,
                status: state.isStorageGrant,
                borderRadius: BorderRadius.circular(45),
              ),
              ItemPermission(
                permission: Permission.notification,
                title: S.of(context).notification,
                status: state.isNotificationGrant,
                borderRadius: BorderRadius.circular(45),
              ),
            ],
          );
        },
      ),
      bottomPadding: EdgeInsets.only(bottom: 40.h, left: 16.w, right: 16.w),
      isShowButton: false,
    );
  }
}
