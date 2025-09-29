import '../entities/photo.dart';

abstract class GetAllPhotoRepository {
  Future<List<Photo>> getAllPhotos();
}
