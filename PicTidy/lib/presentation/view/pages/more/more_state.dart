part of 'more_bloc.dart';

@freezed
class MoreState extends BaseState with _$MoreState {
  const factory MoreState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
  }) = _MoreState;

  const MoreState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}