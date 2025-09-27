import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/constant/app_constant.dart';
import '../../../../shared/extension/widget.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_app_bar.dart';
import 'component/item_permission.dart';
import 'permission_bloc.dart';

@RoutePage()
class PermissionPage
    extends BasePage<PermissionBloc, PermissionEvent, PermissionState> {
  const PermissionPage({super.key, this.isFirstRequestPermission = true})
    : super(screenName: 'PermissionPage', isSingletonBloc: true);

  final bool isFirstRequestPermission;

  @override
  void onInitState(BuildContext context) {
    context.read<PermissionBloc>().add(const PermissionEvent.loadData());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<PermissionBloc>().add(
        PermissionEvent.requestPermission(
          Permission.notification,
          S.of(context).notificationPermission,
          S.of(context).youMustGrantNotificationPermissionToUseThisApp,
          false,
        ),
      );
    });
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      appBar: CustomAppbar(
        titleText: S.of(context).permission,
        centerTitle: false,
        style: AppStyles.titleXXLSemi20(AppColors.dark100),
      ),
      child: Column(
        children: [
          38.verticalSpace,

          Expanded(
            child: BlocBuilder<PermissionBloc, PermissionState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Assets.images.permission.image(
                        width: 163.w,
                        height: 163.h,
                      ),
                      40.verticalSpace,
                      Text(
                        S
                            .of(context)
                            .appnameRequiresPermissionToUseTheDevicesFunction(
                              AppConstant.appName,
                            ),
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyXLRegular16(AppColors.dark100),
                      ),
                      20.verticalSpace,
                      ItemPermission(
                        permission: Permission.storage,
                        title: S.of(context).storage,
                        status: state.isStorageGrant,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      20.verticalSpace,
                      ItemPermission(
                        permission: Permission.notification,
                        title: S.of(context).notification,
                        status: state.isNotificationGrant,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ],
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 16.w),
          ),

          20.verticalSpace,

          AppButton(
            onPressed: () => context.read<PermissionBloc>().add(
              const PermissionEvent.nextScreen(),
            ),
            radius: 16,
            width: 328.w,
            height: 56.h,
            text: S.of(context).next,
          ),
          21.verticalSpace,
        ],
      ),
    );
  }
}
