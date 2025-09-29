part of 'my_statistics_bloc.dart';

@freezed
abstract class MyStatisticsState extends BaseState with _$MyStatisticsState {
  const factory MyStatisticsState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    DateTime? selectedDate,
    DateTime? rangeStartDate,
    DateTime? rangeEndDate,
    DateTime? focusedDate,
    @Default(RangeSelectionMode.toggledOn)
    RangeSelectionMode rangeSelectionMode,
  }) = _MyStatisticsState;

  const MyStatisticsState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
