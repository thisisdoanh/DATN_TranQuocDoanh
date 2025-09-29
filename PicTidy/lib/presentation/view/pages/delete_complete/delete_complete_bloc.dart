import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../di/di.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';

part 'delete_complete_bloc.freezed.dart';
part 'delete_complete_event.dart';
part 'delete_complete_state.dart';

@injectable
class DeleteCompleteBloc
    extends BaseBloc<DeleteCompleteEvent, DeleteCompleteState> {
  DeleteCompleteBloc() : super(const DeleteCompleteState()) {
    on<DeleteCompleteEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            emit(
              state.copyWith(
                pageStatus: PageStatus.Loaded,
                listAssets: event.listAssets,
                listIdsDeleted: event.listIdsDeleted,
                listIdsAssetsFailedOrSkipped:
                    event.listIdsAssetsFailedOrSkipped,
              ),
            );

            break;
          case _BackToHome():
            getIt<AppRouter>().popUntil(
              (route) => route.settings.name == HomeRoute.name,
            );
            break;
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }
}
