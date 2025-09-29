import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../app_bloc.dart';
import '../../../../di/di.dart';
import '../../../../domain/enums/language.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/utils/share_preference_utils.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';

part 'language_bloc.freezed.dart';
part 'language_event.dart';
part 'language_state.dart';

@injectable
class LanguageBloc extends BaseBloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<LanguageEvent>((event, emit) async {
      try {
        final appBloc = getIt<AppBloc>();
        switch (event) {
          case _LoadData():
            if (!isFirstOpenLanguage) {
              emit(
                state.copyWith(
                  pageStatus: PageStatus.Loaded,
                  currentLanguage: appBloc.state.currentLanguage,
                ),
              );
            } else {
              emit(state.copyWith(pageStatus: PageStatus.Loaded));
            }

            break;
          case _ChangeLanguage():
            final Language language = event.language;

            if (language != state.currentLanguage) {
              emit(
                state.copyWith(
                  currentLanguage: language,
                ),
              );
              appBloc.add(AppEvent.changeAppLanguage(language));
            }
            break;
          case _SaveLanguage():
            if (state.currentLanguage == null) {
              return;
            }
            getIt<PreferenceUtils>().setString(
              'language_code',
              state.currentLanguage!.languageCode,
            );
            appBloc.add(AppEvent.changeAppLanguage(state.currentLanguage));
            if (isFirstOpenLanguage) {
              getIt<AppRouter>().replace(OnBoardingRoute());
            } else {
              getIt<AppRouter>().pop();
            }
            break;
          case _BackLanguage():
            final String languageCode =
                getIt<PreferenceUtils>().getString('language_code') ?? '';
            getIt<AppBloc>().add(
              AppEvent.changeAppLanguage(languageCode.fromCode()),
            );
            getIt<AppRouter>().pop();
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  bool isFirstOpenLanguage = true;

  final List<Language> listLanguages = Language.values;
}
