import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../domain/repositories/get_all_video_repository.dart';

@Injectable(as: GetAllVideoRepository)
class GetAllVideoRepositoryImpl extends GetAllVideoRepository {
  GetAllVideoRepositoryImpl();

  @override
  Future<List<AssetEntity>> getAllVideos() async {
    final status = await PhotoManager.getPermissionState(
      requestOption: const PermissionRequestOption(),
    );
    if (!status.hasAccess) {
      return [];
    }

    // Get all albums containing video
    final List<AssetPathEntity> listPathVideo =
        await PhotoManager.getAssetPathList(
          type: RequestType.video,
          onlyAll: true,
          filterOption: FilterOptionGroup(
            imageOption: const FilterOption(
              sizeConstraint: SizeConstraint(ignoreSize: true),
            ),
            orders: [
              const OrderOption(type: OrderOptionType.createDate, asc: false),
            ],
          ),
        );

    if (listPathVideo.isEmpty) {
      return []; // Return empty if no video albums found
    }

    final List<AssetEntity> listVideo = [];

    for (final album in listPathVideo) {
      final int assetCount = await album.assetCountAsync;
      if (assetCount == 0) {
        continue; // Skip empty albums
      }
      final List<AssetEntity> videos = await album.getAssetListRange(
        start: 0,
        end: assetCount, // Adjust the size as needed
      );

      final videoValid = videos
          .where(
            (video) =>
                video.width > 0 && video.height > 0 && video.duration > 0,
          )
          .toList();

      listVideo.addAll(videoValid);
    }
    return listVideo;
  }
}
