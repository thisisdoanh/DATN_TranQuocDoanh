import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../repositories/get_all_video_repository.dart';
import 'use_case.dart';

@injectable
class GetAllVideoUseCase extends UseCase<void, GetAllVideoParam> {
  GetAllVideoUseCase(this._getAllVideoRepository);

  @override
  Future<List<AssetEntity>> call({required GetAllVideoParam params}) async {
    return await _getAllVideoRepository.getAllVideos();
  }

  final GetAllVideoRepository _getAllVideoRepository;
}

class GetAllVideoParam {
  GetAllVideoParam();
}
