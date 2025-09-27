part of 'app_bloc.dart';

@freezed
class AppState extends BaseState with _$AppState {
  AppState({
    super.pageStatus = PageStatus.Loaded,
    this.mode = ThemeMode.light,
    this.currentLanguage = Language.english,
  });

  @override
  ThemeMode mode;

  @override
  Language currentLanguage;
}
