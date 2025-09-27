import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../utils/alert.dart';
import 'error_entity/error_entity.dart';

abstract class ErrorHandler {
  static final _errorList = <String>[];

  static void handle(Object error, {VoidCallback? onPressed}) {
    final message = error is ErrorEntity ? error.message : S.current.errorSomething;

    if (_errorList.contains(message)) {
      return;
    }

    _errorList.add(message);

    void onConfirm() {
      onPressed?.call();
      _errorList.remove(message);
    }

    // if (error is SessionExpiredErrorEntity || error is UidInvalidErrorEntity) {
    //   AppAlertDialog.hideAll();
    //   _showErrorDialog(
    //     message,
    //     onPressed: () async {
    //       onConfirm.call();
    //       _errorList.clear();
    //       // await getIt<LogoutUseCase>().call(params: null);
    //       // getIt<AppRouter>().replaceAll([LoginRoute()]);
    //     },
    //   );
    //   return;
    // }
    _showErrorDialog(message, onPressed: onConfirm, );
  }

  static void _showErrorDialog(String message, {VoidCallback? onPressed}) {
    AppAlertDialog.show(
      title: S.current.error,
      message: message,
      type: AppAlertType.error,
      onConfirmBtnTap: onPressed,
      barrierDismissible: false,
      showCancelBtn: false,
    );
  }
}