import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../data/local/local_repository.dart';
import '../../../../di/di.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';
import '../home/home_bloc.dart';

part 'confirm_delete_bloc.freezed.dart';
part 'confirm_delete_event.dart';
part 'confirm_delete_state.dart';

@injectable
class ConfirmDeleteBloc
    extends BaseBloc<ConfirmDeleteEvent, ConfirmDeleteState> {
  ConfirmDeleteBloc() : super(const ConfirmDeleteState()) {
    on<ConfirmDeleteEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            emit(
              state.copyWith(
                pageStatus: PageStatus.Loaded,
                listAssets: event.listAssets,
                listIdsAssetsDelete: event.listIdsDelete,
              ),
            );
            break;
          case _TogglePhotoSelection():
            final updatedListIndex = List<String>.from(
              state.listIdsAssetsDelete,
            );
            final photoIds = state.listAssets[event.index].id;
            if (updatedListIndex.contains(photoIds)) {
              updatedListIndex.remove(photoIds);
            } else {
              updatedListIndex.add(photoIds);
            }
            emit(state.copyWith(listIdsAssetsDelete: updatedListIndex));
            break;
          case _ConfirmDelete():
            final result = await PhotoManager.editor.deleteWithIds(
              state.listIdsAssetsDelete,
            );

            if (result.isNotEmpty) {
              getIt<HomeBloc>().add(HomeEvent.deleteIds(result));
              final Set<String> failedOrSkippedIds = state.listAssets
                  .map((asset) => asset.id)
                  .toSet()
                  .difference(result.toSet());

              await LocalRepository.instance.saveDeleteImageData(
                DateTime.now(),
                sizeInBytes,
                result.length,
                failedOrSkippedIds.length,
              );

              getIt<AppRouter>().replace(
                DeleteCompleteRoute(
                  listAssets: state.listAssets,
                  listIdsAssetsDeleted: result,
                  listIdsAssetsFailedOrSkipped: failedOrSkippedIds.toList(),
                  isVideo: isVideo,
                ),
              );
            }
            break;
        }
      } catch (e, s) {
        hideLoading();
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  int sizeInBytes = 0;
  bool isVideo = false;
}
