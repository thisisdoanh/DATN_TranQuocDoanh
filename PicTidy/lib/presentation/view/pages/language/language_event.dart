part of 'language_bloc.dart';

@freezed
sealed class LanguageEvent with _$LanguageEvent {
  const factory LanguageEvent.loadData() = _LoadData;

  const factory LanguageEvent.changeLanguage(Language language) =
      _ChangeLanguage;

  const factory LanguageEvent.saveLanguage() = _SaveLanguage;

  const factory LanguageEvent.backLanguage() = _BackLanguage;
}
