
import 'package:dio/dio.dart';
import '../../generated/l10n.dart';
import '../utils/logger.dart';
import 'error_entity/error_entity.dart';

class ErrorConverter {
  static ErrorEntity convert(dynamic exception, [StackTrace? stacktrace]) {
    if (exception is ErrorEntity) {
      return exception;
    }

    if (exception is DioException) {
      final type = exception.type;

      switch (type) {
        case DioExceptionType.unknown:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ErrorEntity(message: S.current.timeoutErrorOccurred);
        default:
      }
    }

    logger.e('$exception $stacktrace');
    return ErrorEntity(
      message: exception.toString(),
    );
  }
}