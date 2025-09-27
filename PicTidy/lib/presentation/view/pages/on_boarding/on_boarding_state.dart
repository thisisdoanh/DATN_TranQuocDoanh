part of 'on_boarding_bloc.dart';

@freezed
class OnBoardingState extends BaseState with _$OnBoardingState {
  const factory OnBoardingState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default(0) int currentIndex,
  }) = _OnBoardingState;

  const OnBoardingState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
    required this.currentIndex,
  });

  @override
  final int currentIndex;
}