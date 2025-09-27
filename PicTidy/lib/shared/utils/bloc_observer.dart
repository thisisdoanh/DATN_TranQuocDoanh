import 'package:flutter_bloc/flutter_bloc.dart';

import 'logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    loggerNoStack.i('${bloc.runtimeType} Created');
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    loggerNoStack.i('${bloc.runtimeType}\nOn Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    // final message =
    //     '${bloc.runtimeType}\n'
    //     'Current State: ${_shorten(change.currentState)}\n'
    //     'Next State: ${_shorten(change.nextState)}';

    // loggerNoStack.i(message);
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    loggerNoStack.i('${bloc.runtimeType} Close');
    super.onClose(bloc);
  }

  String _shorten(Object state, {int maxLength = 200}) {
    final text = state.toString();
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...'; // cắt kèm dấu ...
  }
}
