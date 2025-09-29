import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/extension/datetime.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/styles.dart';
import '../my_statistics_bloc.dart';

class StatisticCalendar extends StatelessWidget {
  const StatisticCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          color: AppColors.white,
          child: BlocBuilder<MyStatisticsBloc, MyStatisticsState>(
            builder: (context, state) {
              return TableCalendar(
                firstDay: DateTime(1970),
                lastDay: DateTime.now(),
                currentDay: DateTime.now(),
                focusedDay: state.focusedDate ?? DateTime.now(),
                rangeStartDay: state.rangeStartDate,
                rangeEndDay: state.rangeEndDate,
                selectedDayPredicate: (day) =>
                    isSameDay(state.selectedDate, day),
                availableGestures: AvailableGestures.horizontalSwipe,
                rangeSelectionMode: state.rangeSelectionMode,
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    border: Border.all(color: AppColors.green54B, width: 1.w),
                    shape: BoxShape.circle,
                  ),
                  rangeStartDecoration: BoxDecoration(
                    color: AppColors.greenAA6,
                    shape: BoxShape.circle,
                    border: isSameDay(state.rangeStartDate, DateTime.now())
                        ? Border.all(color: AppColors.green54B, width: 1.w)
                        : null,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: AppColors.greenAA6,
                    shape: BoxShape.circle,
                    border: isSameDay(state.rangeEndDate, DateTime.now())
                        ? Border.all(color: AppColors.green54B, width: 1.w)
                        : null,
                  ),
                  rangeHighlightColor: AppColors.greenEED,
                  defaultTextStyle: AppStyles.bodyXLMedium16(AppColors.dark100),
                  todayTextStyle: AppStyles.bodyXLMedium16(AppColors.dark100),
                  withinRangeTextStyle: AppStyles.bodyXLMedium16(
                    AppColors.dark100,
                  ),
                  rangeStartTextStyle: AppStyles.bodyXLMedium16(
                    AppColors.dark100,
                  ),
                  rangeEndTextStyle: AppStyles.bodyXLMedium16(
                    AppColors.dark100,
                  ),
                  disabledTextStyle: AppStyles.bodyXLMedium16(
                    AppColors.dark500,
                  ),
                  rowDecoration: BoxDecoration(color: AppColors.white),
                  cellPadding: EdgeInsets.zero,
                  cellMargin: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 4.w,
                  ),
                ),
                rowHeight: 50.h,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: AppStyles.titleXXLSemi20(AppColors.dark100),
                  decoration: BoxDecoration(color: AppColors.white),
                  headerMargin: EdgeInsets.zero,
                  headerPadding: EdgeInsets.zero,
                  rightChevronMargin: EdgeInsets.only(right: 40.w),
                  leftChevronMargin: EdgeInsets.only(left: 40.w),
                  rightChevronIcon: SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: Center(
                      child: Assets.icons.chevronRight.svg(
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  leftChevronIcon: SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: Center(
                      child: Assets.icons.chevronLeft.svg(
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: AppStyles.bodyLMedium14(AppColors.dark300),
                  weekendStyle: AppStyles.bodyLMedium14(AppColors.dark300),
                  dowTextFormatter: (date, locale) =>
                      date.formatPattern(pattern: 'EEE').substring(0, 1),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.light200, width: 1.h),
                    ),
                  ),
                ),
                daysOfWeekHeight: 50.h,
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<MyStatisticsBloc>().add(
                    MyStatisticsEvent.onDaySelected(selectedDay, focusedDay),
                  );
                },
                onPageChanged: (focusedDay) {
                  context.read<MyStatisticsBloc>().add(
                    MyStatisticsEvent.onPageChanged(focusedDay),
                  );
                },
                onRangeSelected: (start, end, focusedDay) {
                  context.read<MyStatisticsBloc>().add(
                    MyStatisticsEvent.onRangeSelected(start, end, focusedDay),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
