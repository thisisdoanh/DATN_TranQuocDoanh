import 'package:injectable/injectable.dart';

import '../entities/photo.dart';
import '../repositories/get_all_photo_repository.dart';
import 'use_case.dart';

@injectable
class GetAllPhotoUseCase extends UseCase<void, GetAllPhotoParam> {
  GetAllPhotoUseCase(this._getAllPhotoRepository);

  @override
  Future<List<Photo>> call({required GetAllPhotoParam params}) async {
    return await _getAllPhotoRepository.getAllPhotos();
  }

  final GetAllPhotoRepository _getAllPhotoRepository;
}

class GetAllPhotoParam {
  GetAllPhotoParam();
}
