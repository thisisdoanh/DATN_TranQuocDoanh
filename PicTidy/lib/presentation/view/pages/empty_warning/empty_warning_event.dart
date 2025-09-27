part of 'empty_warning_bloc.dart';

@freezed
sealed class EmptyWarningEvent with _$EmptyWarningEvent {
  const factory EmptyWarningEvent.loadData() = _LoadData;
}