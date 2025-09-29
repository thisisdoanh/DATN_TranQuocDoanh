import 'dart:io';

import 'package:flutter/services.dart';

import '../shared/utils/app_log.dart';
import 'native_response_model.dart';

class NativeBridge {
  factory NativeBridge() => instance;

  NativeBridge._internal();

  static NativeBridge instance = NativeBridge._internal();

  static const _platformFramework = MethodChannel('method_channel');

  final String tag = '---Native Bridge: ${Platform.operatingSystem}';

  void handlerMethodCall() {
    _platformFramework.setMethodCallHandler((call) {
      switch (call.method) {
        case 'disableMethod':
          return Future.value(null); // hoặc giá trị khác nếu cần trả về
        default:
          AppLog.error(
            'Method not implements\nMethod: ${call.method}\nArguments: ${call.arguments}',
            tag: 'Native Bridge',
          );
          throw PlatformException(
            code: 'METHOD_NOT_IMPLEMENTED',
            message: 'Method ${call.method} not implemented',
          );
      }
    });
  }

  Future<NativeResponseModel<dynamic>> sendMethodToNative({
    required String methodName,
    Map<String, dynamic>? data,
  }) async {
    try {
      final dynamic result = await _platformFramework.invokeMethod(
        methodName,
        data,
      );

      _printMessage(result, methodName);
      return NativeResponseModel(isSuccess: true, data: result);
    } on PlatformException catch (platformException) {
      _printMessage(
        platformException.message ?? '',
        methodName,
        hasError: true,
      );
      throw PlatformException(
        code: platformException.code,
        message: 'Error native method: ${platformException.message}',
        details: platformException.details,
        stacktrace: platformException.stacktrace,
      );
    } catch (e) {
      _printMessage(e.toString(), methodName, hasError: true);
      throw Exception(e);
    }
  }

  void _printMessage(
    Object message,
    String methodName, {
    bool hasError = false,
  }) {
    if (!hasError) {
      AppLog.info('$methodName\n$message', tag: 'Native Bridge');
    } else {
      AppLog.error('$methodName\n$message', tag: 'Native Bridge');
    }
  }
}
