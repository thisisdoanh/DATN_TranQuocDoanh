import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_log.dart';

@singleton
class PreferenceUtils {
  late final SharedPreferences _sharedPreferences;

  // call this method from iniState() function of mainApp().
  Future<void> init() async {
    AppLog.info('Share preference init');

    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// sets
  Future<bool> setBool(String key, bool value) async {
    final answer = await _sharedPreferences.setBool(key, value);

    if (answer) {
      AppLog.debug(
        'set bool success: [$value] -> [$key]',
        tag: 'Shared Preferences',
      );
    } else {
      AppLog.debug('set bool fail', tag: 'Shared Preferences');
    }

    return answer;
  }

  Future<bool> setDouble(String key, double value) async {
    final answer = await _sharedPreferences.setDouble(key, value);

    if (answer) {
      AppLog.debug(
        'set double success: [$value] -> [$key]',
        tag: 'Shared Preferences',
      );
    } else {
      AppLog.debug('set double fail', tag: 'Shared Preferences');
    }

    return answer;
  }

  Future<bool> setInt(String key, int value) async {
    final answer = await _sharedPreferences.setInt(key, value);

    if (answer) {
      AppLog.debug(
        'set int success: [$value] -> [$key]',
        tag: 'Shared Preferences',
      );
    } else {
      AppLog.debug('set int fail', tag: 'Shared Preferences');
    }

    return answer;
  }

  Future<bool> setString(String key, String value) async {
    final answer = await _sharedPreferences.setString(key, value);

    if (answer) {
      AppLog.debug(
        'set string success: [$value] -> [$key]',
        tag: 'Shared Preferences',
      );
    } else {
      AppLog.debug('[$key] -> [$value] fail', tag: 'Shared Preferences');
    }

    return answer;
  }

  Future<bool> setStringList(String key, List<String> value) async =>
      await _sharedPreferences.setStringList(key, value);

  /// gets
  bool? getBool(String key) {
    final bool? answer = _sharedPreferences.getBool(key);

    if (answer == null) {
      AppLog.debug('Get bool fails', tag: 'Shared Preferences');
    } else {
      AppLog.debug('Get bool: $answer', tag: 'Shared Preferences');
    }

    return answer;
  }

  double? getDouble(String key) {
    final double? answer = _sharedPreferences.getDouble(key);

    if (answer == null) {
      AppLog.debug('Get double fails', tag: 'Shared Preferences');
    } else {
      AppLog.debug('Get double: $answer', tag: 'Shared Preferences');
    }

    return answer;
  }

  int? getInt(String key) {
    final int? answer = _sharedPreferences.getInt(key);

    if (answer == null) {
      AppLog.debug('Get int fails', tag: 'Shared Preferences');
    } else {
      AppLog.debug('Get int: $answer', tag: 'Shared Preferences');
    }

    return answer;
  }

  String? getString(String key) {
    final String? answer = _sharedPreferences.getString(key);

    if (answer == null) {
      AppLog.debug('Get string fails', tag: 'Shared Preferences');
    } else {
      AppLog.debug('Get string: $answer', tag: 'Shared Preferences');
    }

    return answer;
  }

  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  /// delete
  Future<bool> remove(String key) async => await _sharedPreferences.remove(key);

  Future<bool> clear() async => await _sharedPreferences.clear();
}
