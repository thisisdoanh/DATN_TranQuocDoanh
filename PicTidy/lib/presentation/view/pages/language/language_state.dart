part of 'language_bloc.dart';

@freezed
abstract class LanguageState extends BaseState with _$LanguageState {
  const factory LanguageState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    Language? currentLanguage,
  }) = _LanguageState;

  const LanguageState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
