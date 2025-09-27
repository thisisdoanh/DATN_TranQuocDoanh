import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/app_ignore_button.dart';
import '../../../widgets/custom_app_bar.dart';
import 'component/statistic_calendar.dart';
import 'my_statistics_bloc.dart';

@RoutePage()
class MyStatisticsPage
    extends BasePage<MyStatisticsBloc, MyStatisticsEvent, MyStatisticsState> {
  const MyStatisticsPage({super.key}) : super(screenName: "MyStatisticsPage");

  @override
  void onInitState(BuildContext context) {
    context.read<MyStatisticsBloc>().add(const MyStatisticsEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      isUseBackgroundImage: true,
      backgroundImage: Assets.images.bgMyStatistic,
      appBar: const CustomAppbar(colorBack: AppColors.dark200),
      child: Column(
        children: [
          45.verticalSpace,
          const StatisticCalendar(),
          32.verticalSpace,
          BlocBuilder<MyStatisticsBloc, MyStatisticsState>(
            buildWhen: (previous, current) {
              // Rebuild only when ignore state changes
              if (previous.rangeStartDate != current.rangeStartDate ||
                  previous.rangeEndDate != current.rangeEndDate) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              return AppIgnoreButton(
                isIgnore: state.rangeStartDate == null,
                opacity: 0,
                child: AppButton(
                  onPressed: () {
                    context.read<MyStatisticsBloc>().add(
                      const MyStatisticsEvent.next(),
                    );
                  },
                  width: 328.w,
                  height: 56.h,
                  radius: 16.r,
                  text: S.of(context).next,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
