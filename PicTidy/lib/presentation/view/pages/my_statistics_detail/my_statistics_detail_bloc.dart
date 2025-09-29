import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';

part 'my_statistics_detail_bloc.freezed.dart';
part 'my_statistics_detail_event.dart';
part 'my_statistics_detail_state.dart';

@injectable
class MyStatisticsDetailBloc extends BaseBloc<MyStatisticsDetailEvent, MyStatisticsDetailState> {
  MyStatisticsDetailBloc() : super(const MyStatisticsDetailState()) {
    on<MyStatisticsDetailEvent>((event, emit) async {
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