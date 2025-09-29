import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_app_bar.dart';
import 'component/item_setting_component.dart';
import 'more_bloc.dart';

@RoutePage()
class MorePage extends BasePage<MoreBloc, MoreEvent, MoreState> {
  const MorePage({super.key}) : super(screenName: "MorePage");

  @override
  void onInitState(BuildContext context) {
    context.read<MoreBloc>().add(const MoreEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      appBar: CustomAppbar(
        titleText: S.of(context).settings,
        style: AppStyles.bodyLSemi14(
          AppColors.dark100,
        ).copyWith(height: null, fontSize: 24.sp),
        centerTitle: false,
        showBackButton: false,
      ),
      backgroundGradientColor: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFA3EACC), Color(0xFFCCEEC2)],
        stops: [0, 0.32],
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16.h,
          children: [
            0.verticalSpace,
            ItemSettingComponent(
              onPressed: () {
                context.read<MoreBloc>().add(const MoreEvent.favorite());
              },
              icon: Assets.icons.likeWhite,
              title: S.of(context).favorites,
            ),
            ItemSettingComponent(
              onPressed: () {
                context.read<MoreBloc>().add(const MoreEvent.myStatistics());
              },
              icon: Assets.icons.statistics,
              title: S.of(context).myStatistics,
            ),
            ItemSettingComponent(
              onPressed: () {
                context.read<MoreBloc>().add(const MoreEvent.language());
              },
              icon: Assets.icons.language,
              title: S.of(context).languages,
            ),

            150.verticalSpace,
          ],
        ),
      ),
    );
  }
}
