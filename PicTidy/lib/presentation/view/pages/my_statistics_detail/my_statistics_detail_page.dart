import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/local/model/delete_image_model.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/extension/number.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_app_bar.dart';
import 'my_statistics_detail_bloc.dart';

@RoutePage()
class MyStatisticsDetailPage
    extends
        BasePage<
          MyStatisticsDetailBloc,
          MyStatisticsDetailEvent,
          MyStatisticsDetailState
        > {
  const MyStatisticsDetailPage({super.key, required this.deleteImageModel})
    : super(screenName: 'MyStatisticsDetailPage');

  final DeleteImageModel deleteImageModel;

  @override
  void onInitState(BuildContext context) {
    context.read<MyStatisticsDetailBloc>().add(
      const MyStatisticsDetailEvent.loadData(),
    );
    super.onInitState(context);
  }

  Widget _buildItemInfo({
    required SvgGenImage icon,
    required Color iconBGColor,
    required num value,
    required String title,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: iconBGColor, shape: BoxShape.circle),
          child: icon.svg(width: 20.w, height: 20.h),
        ),
        12.verticalSpace,
        Text(
          '${value is double ? value.toStringAsFixed(1) : value}',
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
      isUseBackgroundImage: true,
      backgroundImage: Assets.images.bgMyStatisticDetail,
      appBar: const CustomAppbar(colorBack: AppColors.dark200),
      child: Column(
        children: [
          130.verticalSpace,
          Assets.images.photoStatistic.image(
            height: 50.h,
            fit: BoxFit.fitHeight,
          ),
          8.verticalSpace,
          Text(
            S
                .of(context)
                .NPhotos(
                  deleteImageModel.imageRetain + deleteImageModel.imageDelete,
                ),
            style: AppStyles.titleXLSemi18(
              AppColors.dark100,
            ).copyWith(height: null, fontSize: 26.sp),
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildItemInfo(
                  icon: Assets.icons.trash,
                  iconBGColor: AppColors.red6D6,
                  value: deleteImageModel.imageDelete,
                  title: S.of(context).photoDeleted,
                ),
              ),
              Expanded(
                child: _buildItemInfo(
                  icon: Assets.icons.star,
                  iconBGColor: AppColors.blueAF6,
                  value: deleteImageModel.imageRetain,
                  title: S.of(context).photoRetained,
                ),
              ),
              Expanded(
                child: _buildItemInfo(
                  icon: Assets.icons.circleCheck,
                  iconBGColor: AppColors.mint200,
                  value: deleteImageModel.sizeFreedBytes
                      .fromBytesToMapValueUnit()
                      .key,
                  title:
                      '${deleteImageModel.sizeFreedBytes.fromBytesToMapValueUnit().value} ${S.of(context).freed}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
