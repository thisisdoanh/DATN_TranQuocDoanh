import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/dimens.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_button_circle.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/app_touchable.dart';
import 'delete_complete_bloc.dart';

@RoutePage()
class DeleteCompletePage
    extends
        BasePage<DeleteCompleteBloc, DeleteCompleteEvent, DeleteCompleteState> {
  const DeleteCompletePage({
    super.key,
    required this.listAssets,
    required this.listIdsAssetsDeleted,
    required this.listIdsAssetsFailedOrSkipped,
    required this.isVideo,
  }) : super(screenName: 'DeleteCompletePage');

  final List<AssetEntity> listAssets;
  final List<String> listIdsAssetsDeleted;
  final List<String> listIdsAssetsFailedOrSkipped;
  final bool isVideo;

  @override
  void onInitState(BuildContext context) {
    context.read<DeleteCompleteBloc>().add(
      DeleteCompleteEvent.loadData(
        listAssets,
        listIdsAssetsDeleted,
        listIdsAssetsFailedOrSkipped,
      ),
    );
    super.onInitState(context);
  }

  Widget _buildItemInfo({
    required Widget icon,
    required int value,
    required String title,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        icon,
        12.verticalSpace,
        Text(
          value.toString(),
          style: AppStyles.titleXXLBold20(AppColors.dark100),
        ),
        6.verticalSpace,
        Text(title, style: AppStyles.bodyLRegular14(AppColors.dark300)),
      ],
    );
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      child: Stack(
        children: [
          Assets.images.bgDeleteComplete.image(
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
          Positioned.fill(
            top:
                (MediaQuery.of(context).padding.top + Dimens.paddingTop + 10).h,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTouchable(
                    onPressed: () {
                      context.read<DeleteCompleteBloc>().add(
                        const DeleteCompleteEvent.backToHome(),
                      );
                    },
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    margin: EdgeInsets.only(right: 16.w),
                    child: Text(
                      S.of(context).goHome,
                      style: AppStyles.titleXLSemi16(AppColors.mint400),
                    ),
                  ),
                ),
                252.verticalSpace,
                Text(
                  S.of(context).done,
                  style: AppStyles.titleXXLMedium22(
                    AppColors.semanticGreen100,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                35.verticalSpace,
                BlocBuilder<DeleteCompleteBloc, DeleteCompleteState>(
                  builder: (context, state) {
                    return Row(
                      spacing: 24.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItemInfo(
                          icon: AppButtonCircle(
                            backgroundColor: AppColors.semanticRed50,
                            width: 60.w,
                            height: 60.h,
                            child: Assets.icons.trash.svg(
                              width: 30.w,
                              height: 30.h,
                            ),
                          ),
                          value: state.listIdsDeleted.length,
                          title: isVideo
                              ? S.of(context).videoDeleted
                              : S.of(context).imageDeleted,
                        ),
                        _buildItemInfo(
                          icon: AppButtonCircle(
                            backgroundColor: AppColors.blueAF6,
                            width: 60.w,
                            height: 60.h,
                            child: Assets.icons.star.svg(
                              width: 30.w,
                              height: 30.h,
                            ),
                          ),
                          value: state.listIdsAssetsFailedOrSkipped.length,
                          title: isVideo
                              ? S.of(context).videoRetained
                              : S.of(context).imageRetained,
                        ),
                      ],
                    );
                  },
                ),
                41.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
