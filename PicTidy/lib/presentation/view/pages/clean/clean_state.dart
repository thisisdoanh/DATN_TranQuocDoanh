part of 'clean_bloc.dart';

@freezed
abstract class CleanState extends BaseState with _$CleanState {
  const factory CleanState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
  }) = _CleanState;

  const CleanState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
