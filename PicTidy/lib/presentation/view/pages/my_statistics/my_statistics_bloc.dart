import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data/local/local_repository.dart';
import '../../../../di/di.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../../shared/extension/datetime.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';

part 'my_statistics_bloc.freezed.dart';
part 'my_statistics_event.dart';
part 'my_statistics_state.dart';

@injectable
class MyStatisticsBloc extends BaseBloc<MyStatisticsEvent, MyStatisticsState> {
  MyStatisticsBloc() : super(const MyStatisticsState()) {
    on<MyStatisticsEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            await _handleEventLoadData(event, emit);
            break;
          case _OnDaySelected():
            await _handleEventOnDaySelected(event, emit);
            break;
          case _OnRangeSelected():
            await _handleEventOnRangeSelected(event, emit);
            break;
          case _OnPageChanged():
            await _handleEventOnPageChanged(event, emit);
            break;
          case _Next():
            await _handleEventNext(event, emit);
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  Future<void> _handleEventNext(
    _Next event,
    Emitter<MyStatisticsState> emit,
  ) async {
    final deleteImageModel = LocalRepository.instance.getDataDeleteImageInRange(
      state.rangeStartDate ?? DateTime.now().zeroTime(),
      (state.rangeEndDate ?? state.rangeStartDate ?? DateTime.now().zeroTime())
          .add(const Duration(days: 1)),
    );
    getIt<AppRouter>().push(
      MyStatisticsDetailRoute(deleteImageModel: deleteImageModel),
    );
  }

  Future<void> _handleEventLoadData(
    _LoadData event,
    Emitter<MyStatisticsState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.Loaded));
  }

  Future<void> _handleEventOnDaySelected(
    _OnDaySelected event,
    Emitter<MyStatisticsState> emit,
  ) async {
    if (!isSameDay(event.selectedDay, state.selectedDate)) {
      emit(
        state.copyWith(
          selectedDate: event.selectedDay,
          focusedDate: event.focusedDay,
          rangeStartDate: null, // Important to clean those
          rangeEndDate: null,
          rangeSelectionMode: RangeSelectionMode.toggledOff,
        ),
      );
    }
  }

  Future<void> _handleEventOnRangeSelected(
    _OnRangeSelected event,
    Emitter<MyStatisticsState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDate: null,
        focusedDate: event.focusedDay,
        rangeStartDate: event.start, // Important to clean those
        rangeEndDate: event.end,
        rangeSelectionMode: RangeSelectionMode.toggledOn,
      ),
    );
  }

  Future<void> _handleEventOnPageChanged(
    _OnPageChanged event,
    Emitter<MyStatisticsState> emit,
  ) async {
    emit(state.copyWith(focusedDate: event.focusedDay));
  }
}
