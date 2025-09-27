part of 'my_statistics_detail_bloc.dart';

@freezed
sealed class MyStatisticsDetailEvent with _$MyStatisticsDetailEvent {
  const factory MyStatisticsDetailEvent.loadData() = _LoadData;
}