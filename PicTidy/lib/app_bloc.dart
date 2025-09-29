import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'di/di.dart';
import 'domain/enums/language.dart';
import 'domain/usecases/toogle_app_theme_use_case.dart';
import 'presentation/base/base_bloc.dart';
import 'presentation/base/base_state.dart';
import 'presentation/base/page_status.dart';
import 'shared/utils/share_preference_utils.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

@singleton
class AppBloc extends BaseBloc<AppEvent, AppState> {
  AppBloc(this._toggleThemeUseCase) : super(AppState()) {
    on<AppEvent>((event, emit) async {
      switch (event) {
        case _LoadData():
          final isDark = getIt<PreferenceUtils>().getBool('isDark') ?? false;
          emit(state.copyWith(mode: isDark ? ThemeMode.dark : ThemeMode.light));
          break;
        case _ChangeAppLanguage():
          final Language? language = event.language;
          if (language != null) {
            emit(state.copyWith(currentLanguage: language));
          }
          break;
        case _ToggleAppTheme():
          final isDark = await _toggleThemeUseCase.call(
            params: ToggleAppThemeParam(),
          );
          emit(state.copyWith(mode: isDark ? ThemeMode.dark : ThemeMode.light));
          break;
      }
    });
  }

  final ToggleAppThemeUseCase _toggleThemeUseCase;

  int deviceAPILevel = 0;
  bool isFirstOpenApp = true;
}
