import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pictidy/presentation/widgets/image_item_widget.dart';
import 'package:pictidy/shared/extension/number.dart';

import '../../../../app_bloc.dart';
import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/constant/app_constant.dart';
import '../../../../shared/utils/alert.dart';
import '../../../../shared/utils/app_utils.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_app_bar.dart';
import 'similar_bloc.dart';

@RoutePage()
class SimilarPage extends BasePage<SimilarBloc, SimilarEvent, SimilarState> {
  const SimilarPage({super.key}) : super(screenName: 'SimilarPage');

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      appBar: CustomAppbar(
        titleText: S.of(context).similarImage,
        centerTitle: true,
        showBackButton: true,
      ),
      backgroundColor: AppColors.dark100,
      child: BlocBuilder<SimilarBloc, SimilarState>(
        builder: (context, state) {
          final listSetShow = state.indexTab == 0
              ? state.listSetSimilar
              : state.listSetExact;
          return Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    AnimatedToggleSwitch<int>.size(
                      current: state.indexTab,
                      values: const [0, 1],
                      onChanged: (value) => context.read<SimilarBloc>().add(
                        SimilarEvent.onToggleTab(value),
                      ),
                      indicatorSize: Size.fromWidth(120.w),
                      style: ToggleStyle(
                        borderRadius: BorderRadius.circular(15.r),
                        borderColor: AppColors.transparent,
                        backgroundColor: AppColors.dark200,
                        indicatorColor: AppColors.dark100,
                      ),
                      spacing: 2.w,
                      borderWidth: 3.r,
                      iconBuilder: (index) {
                        String text = [
                          S.of(context).similar,
                          S.of(context).exact,
                        ][index]; // Lấy index của từng item trong danh sách
                        return Text(
                          text, // Hiển thị text tương ứng với giá trị
                          textAlign: TextAlign.center,
                          style: AppStyles.titleXLSemi16(
                            Color.lerp(
                              AppColors.dark300,
                              AppColors.light100,
                              state.indexTab == index ? 1 : 0,
                            )!,
                          ),
                        );
                      },
                      selectedIconScale: 1,
                      iconOpacity: 1,
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => 16.verticalSpace,
                        itemBuilder: (context, index) {
                          final asset = listSetShow[index];
                          return Column(
                            spacing: 8.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${S.of(context).setIndex(index + 1)}:',
                                style: AppStyles.titleXLSemi16(AppColors.white),
                              ),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: [
                                  ...asset.map((e) {
                                    return SizedBox(
                                      width: 104.w,
                                      height: 104.w,
                                      child: ImageItemWidget(
                                        radius:
                                            state.listIdsAssetsDelete.contains(
                                              e.id,
                                            )
                                            ? 8.r
                                            : 4.r,
                                        entity: e,
                                        option: ThumbnailOption(
                                          size: ThumbnailSize(
                                            100.w.toInt(),
                                            100.w.toInt(),
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                        onTap: () =>
                                            context.read<SimilarBloc>().add(
                                              SimilarEvent.togglePhotoSelection(
                                                e,
                                              ),
                                            ),
                                        coverWidget:
                                            state.listIdsAssetsDelete.contains(
                                              e.id,
                                            )
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                  color: AppColors.black
                                                      .withValues(alpha: 0.25),
                                                  border: Border.all(
                                                    width: 3.w,
                                                    color: AppColors.redD4D,
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5.r,
                                                        ),
                                                    border: Border.all(
                                                      width: 3.w,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Assets
                                                        .icons
                                                        .minusCircle
                                                        .svg(
                                                          width: 24.w,
                                                          height: 24.h,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          );
                        },
                        itemCount: listSetShow.length,
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 100.h,
                          top: 8.h,
                        ),
                      ),
                    ),
                  ],
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
                      context.read<SimilarBloc>().add(
                        const SimilarEvent.confirmDelete(),
                      );
                    } else {
                      AppAlertDialog.show(
                        type: AppAlertType.alert,
                        title: S
                            .of(context)
                            .allowAppToDeleteNImage(
                              AppConstant.appName,
                              state.listIdsAssetsDelete.length,
                            ),
                        message: S
                            .of(context)
                            .NSizeWillBeDeleted(
                              context
                                  .read<SimilarBloc>()
                                  .sizeInBytes
                                  .fromBytesToText(),
                            ),

                        onConfirmBtnTap: () {
                          debugPrint(
                            'Confirm delete: ${state.listIdsAssetsDelete.length} items',
                          );
                          context.read<SimilarBloc>().add(
                            const SimilarEvent.confirmDelete(),
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
                            context.read<SimilarBloc>().sizeInBytes =
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

  @override
  void onInitState(BuildContext context) {
    context.read<SimilarBloc>().add(const SimilarEvent.loadData());
    super.onInitState(context);
  }
}
