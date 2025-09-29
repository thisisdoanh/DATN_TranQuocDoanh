import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app_bloc.dart';
import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/constant/app_constant.dart';
import '../../../../shared/extension/number.dart';
import '../../../../shared/utils/alert.dart';
import '../../../../shared/utils/app_utils.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/image_item_widget.dart';
import 'confirm_delete_bloc.dart';

@RoutePage()
class ConfirmDeletePage
    extends
        BasePage<ConfirmDeleteBloc, ConfirmDeleteEvent, ConfirmDeleteState> {
  const ConfirmDeletePage({
    super.key,
    required this.listAssets,
    required this.listIdsAssetsDelete,
    required this.isVideo,
  }) : super(screenName: 'ConfirmDeletePage');

  final List<AssetEntity> listAssets;
  final List<String> listIdsAssetsDelete;
  final bool isVideo;

  @override
  void onInitState(BuildContext context) {
    context.read<ConfirmDeleteBloc>().add(
      ConfirmDeleteEvent.loadData(listAssets, listIdsAssetsDelete),
    );
    context.read<ConfirmDeleteBloc>().isVideo = isVideo;
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      appBar: CustomAppbar(
        titleText: S.of(context).manageMedia,
        centerTitle: true,
        showBackButton: true,
      ),
      backgroundColor: AppColors.dark100,
      child: BlocBuilder<ConfirmDeleteBloc, ConfirmDeleteState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 100.h,
                    top: 8.h,
                  ),
                  itemCount: listAssets.length,
                  itemBuilder: (context, index) => ImageItemWidget(
                    entity: listAssets[index],
                    option: const ThumbnailOption(
                      size: ThumbnailSize.square(200),
                    ),
                    radius:
                        state.listIdsAssetsDelete.contains(listAssets[index].id)
                        ? 8.r
                        : 4.r,
                    onTap: () => context.read<ConfirmDeleteBloc>().add(
                      ConfirmDeleteEvent.togglePhotoSelection(index),
                    ),
                    coverWidget:
                        state.listIdsAssetsDelete.contains(listAssets[index].id)
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColors.black.withValues(alpha: 0.25),
                              border: Border.all(
                                width: 3.w,
                                color: AppColors.redD4D,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  width: 3.w,
                                  color: AppColors.white,
                                ),
                              ),
                              child: Center(
                                child: Assets.icons.minusCircle.svg(
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              Positioned(
                bottom: 24.h,
                left: 16.w,
                right: 16.w,
                child: AppButton(
                  onPressed: () {
                    if (state.listIdsAssetsDelete.isEmpty) {
                      return;
                    }
                    if (getIt<AppBloc>().deviceAPILevel >= 29) {
                      context.read<ConfirmDeleteBloc>().add(
                        const ConfirmDeleteEvent.confirmDelete(),
                      );
                    } else {
                      AppAlertDialog.show(
                        type: AppAlertType.alert,
                        title: isVideo
                            ? S
                                  .of(context)
                                  .allowAppToDeleteNVideo(
                                    AppConstant.appName,
                                    state.listIdsAssetsDelete.length,
                                  )
                            : S
                                  .of(context)
                                  .allowAppToDeleteNImage(
                                    AppConstant.appName,
                                    state.listIdsAssetsDelete.length,
                                  ),
                        message: S
                            .of(context)
                            .NSizeWillBeDeleted(
                              context
                                  .read<ConfirmDeleteBloc>()
                                  .sizeInBytes
                                  .fromBytesToText(),
                            ),

                        onConfirmBtnTap: () {
                          debugPrint(
                            'Confirm delete: ${state.listIdsAssetsDelete.length} items',
                          );
                          context.read<ConfirmDeleteBloc>().add(
                            const ConfirmDeleteEvent.confirmDelete(),
                          );
                        },
                      );
                    }
                  },
                  width: double.infinity,
                  height: 56.h,
                  radius: 16.r,
                  backgroundColor: state.listIdsAssetsDelete.isEmpty
                      ? AppColors.dark400
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S
                            .of(context)
                            .deleteNPhoto(state.listIdsAssetsDelete.length),
                        style: AppStyles.titleXLSemi18(
                          state.listIdsAssetsDelete.isEmpty
                              ? AppColors.light300
                              : AppColors.dark100,
                        ),
                      ),

                      if (state.listIdsAssetsDelete.isNotEmpty)
                        FutureBuilder<int>(
                          future: AppUtils.instance.getSizeInBytesOfList(
                            state.listAssets
                                .where(
                                  (element) => state.listIdsAssetsDelete
                                      .contains(element.id),
                                )
                                .toList(),
                          ),
                          builder: (context, snapshot) {
                            context.read<ConfirmDeleteBloc>().sizeInBytes =
                                snapshot.data ?? 0;
                            return Text(
                              (snapshot.data ?? 0).fromBytesToText(),
                              style: AppStyles.bodyXLRegular16(
                                AppColors.dark100,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
