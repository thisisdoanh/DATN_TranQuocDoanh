import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../domain/entities/photo.dart';
import '../../domain/repositories/get_all_photo_repository.dart';

@Injectable(as: GetAllPhotoRepository)
class GetAllPhotoRepositoryImpl extends GetAllPhotoRepository {
  GetAllPhotoRepositoryImpl();

  @override
  Future<List<Photo>> getAllPhotos() async {
    final status = await PhotoManager.getPermissionState(
      requestOption: const PermissionRequestOption(),
    );
    if (!status.hasAccess) {
      return [];
    }
    // Get all albums containing images
    final List<AssetPathEntity> listPathImage =
        await PhotoManager.getAssetPathList(
          type: RequestType.image,
          filterOption: FilterOptionGroup(
            imageOption: const FilterOption(
              sizeConstraint: SizeConstraint(ignoreSize: true),
            ),
            orders: [
              const OrderOption(type: OrderOptionType.createDate, asc: false),
            ],
          ),
          pathFilterOption: const PMPathFilter(
            ohos: PMOhosPathFilter(subType: [PMOhosAlbumSubtype.camera]),
          ),
        );

    if (listPathImage.isEmpty) {
      return []; // Return empty if no image albums found
    }

    final List<Photo> listPhoto = [];

    for (final album in listPathImage) {
      final int assetCount = await album.assetCountAsync;
      if (assetCount == 0) {
        continue; // Skip empty albums
      }
      final List<AssetEntity> photos = await album.getAssetListRange(
        start: 0,
        end: assetCount, // Adjust the size as needed
      );

      final photoValid = photos.where((photo) => photo.width > 0 && photo.height > 0).toList();

      listPhoto.add(
        Photo(
          albumName: album.name,
          photos: photoValid,
          albumId: album.id,
          assetCount: assetCount,
          isAll: album.isAll,
        ),
      );
    }
    return listPhoto;
  }
}
