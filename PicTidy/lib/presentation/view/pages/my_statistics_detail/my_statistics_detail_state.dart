part of 'my_statistics_detail_bloc.dart';

@freezed
abstract class MyStatisticsDetailState extends BaseState with _$MyStatisticsDetailState {
  const factory MyStatisticsDetailState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
  }) = _MyStatisticsDetailState;

  const MyStatisticsDetailState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}