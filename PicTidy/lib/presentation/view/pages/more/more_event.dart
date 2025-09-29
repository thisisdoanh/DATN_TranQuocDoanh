part of 'more_bloc.dart';

@freezed
sealed class MoreEvent with _$MoreEvent {
  const factory MoreEvent.loadData() = _LoadData;
  const factory MoreEvent.favorite() = _Favorite;
  const factory MoreEvent.myStatistics() = _MyStatistics;
  const factory MoreEvent.language() =  _Language;

}