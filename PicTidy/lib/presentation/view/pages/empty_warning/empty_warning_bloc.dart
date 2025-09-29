import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';

part 'empty_warning_bloc.freezed.dart';
part 'empty_warning_event.dart';
part 'empty_warning_state.dart';

@injectable
class EmptyWarningBloc extends BaseBloc<EmptyWarningEvent, EmptyWarningState> {
  EmptyWarningBloc() : super(const EmptyWarningState()) {
    on<EmptyWarningEvent>((event, emit) async {
        try {
          switch(event) {
            case _LoadData():
              emit(state.copyWith(pageStatus: PageStatus.Loaded));
              break;
          }
        } catch(e,s) {
            handleError(emit, ErrorConverter.convert(e, s));
        }
    });
  }
}