import 'package:injectable/injectable.dart';

import '../../di/di.dart';
import '../../shared/utils/share_preference_utils.dart';
import 'use_case.dart';

@injectable
class ToggleAppThemeUseCase extends UseCase<void, ToggleAppThemeParam> {
  ToggleAppThemeUseCase();

  @override
  Future<bool> call({required ToggleAppThemeParam params}) async {
    final isDark = getIt<PreferenceUtils>().getBool('isDark') ?? false;
    await getIt<PreferenceUtils>().setBool('isDark', !isDark);
    return !isDark;
  }
}

class ToggleAppThemeParam {
  ToggleAppThemeParam();
}