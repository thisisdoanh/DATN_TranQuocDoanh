import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/common/error_handler.dart';
import '../../shared/utils/alert.dart';
import 'base_state.dart';

abstract class BaseBloc<V, S extends BaseState> extends Bloc<V, S> {
  BaseBloc(super.initialState);

  Future<void> handleError<S>(Emitter<S> emit, Object error) async => ErrorHandler.handle(error);

  void showLoading() {
    AppAlertDialog.show(
      type: AppAlertType.loading,
      barrierDismissible: false,
    );
  }

  void hideLoading() {
    AppAlertDialog.hide();
  }
}
