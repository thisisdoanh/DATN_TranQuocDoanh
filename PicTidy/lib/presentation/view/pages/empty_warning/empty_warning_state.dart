part of 'empty_warning_bloc.dart';

@freezed
class EmptyWarningState extends BaseState with _$EmptyWarningState {
  const factory EmptyWarningState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
  }) = _EmptyWarningState;

  const EmptyWarningState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}