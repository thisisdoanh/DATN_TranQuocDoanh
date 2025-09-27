part of 'my_statistics_bloc.dart';

@freezed
sealed class MyStatisticsEvent with _$MyStatisticsEvent {
  const factory MyStatisticsEvent.loadData() = _LoadData;

  const factory MyStatisticsEvent.onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
  ) = _OnDaySelected;

  const factory MyStatisticsEvent.onRangeSelected(
    DateTime? start,
    DateTime? end,
    DateTime focusedDay,
  ) = _OnRangeSelected;

  const factory MyStatisticsEvent.onPageChanged(DateTime focusedDay) =
      _OnPageChanged;

  const factory MyStatisticsEvent.next() = _Next;
}
