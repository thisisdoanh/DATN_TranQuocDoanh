part of 'on_boarding_bloc.dart';

@freezed
sealed class OnBoardingEvent with _$OnBoardingEvent {
  const factory OnBoardingEvent.loadData() = _LoadData;
  const factory OnBoardingEvent.nextPage(int? value) = _NextPage;
}