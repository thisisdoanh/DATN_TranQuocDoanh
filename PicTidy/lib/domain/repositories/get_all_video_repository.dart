import 'package:photo_manager/photo_manager.dart';

abstract class GetAllVideoRepository {
  Future<List<AssetEntity>> getAllVideos();
}
