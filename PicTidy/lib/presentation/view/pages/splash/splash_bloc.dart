import 'package:device_info_plus/device_info_plus.dart';
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
import '../permission/permission_bloc.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  SplashBloc(this.appBloc) : super(const SplashState()) {
    on<SplashEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            bool isFirstOpen =
                getIt<PreferenceUtils>().getBool('is_first_open_app') ?? true;
            final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            final AndroidDeviceInfo info = await deviceInfo.androidInfo;
            getIt<AppBloc>().deviceAPILevel = info.version.sdkInt;
            getIt<PermissionBloc>().add(const PermissionEvent.loadData());
            await getIt<PermissionBloc>().waitForLoadData();

            final String languageCode =
                getIt<PreferenceUtils>().getString('language_code') ?? '';

            appBloc.add(AppEvent.changeAppLanguage(languageCode.fromCode()));
            await Future.delayed(const Duration(seconds: 2));
            if (isFirstOpen) {
              getIt<AppRouter>().replace(
                LanguageRoute(isFirstOpenLanguage: true),
              );
            } else {
              getIt<AppRouter>().replace(const HomeRoute());
            }
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }
  final AppBloc appBloc;
}
