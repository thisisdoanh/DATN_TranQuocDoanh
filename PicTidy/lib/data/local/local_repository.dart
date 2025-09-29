import '../../shared/extension/datetime.dart';
import '../../shared/utils/app_log.dart';
import 'hive_store.dart';
import 'model/delete_image_model.dart';
import 'model/favorite_image_model.dart';

class LocalRepository {
  factory LocalRepository() => instance;
  LocalRepository._internal();
  static final LocalRepository instance = LocalRepository._internal();

  Future<void> saveFavorite(String id) async {
    await HiveStore.favoriteImageBox.add(FavoriteImageModel(id: id));
  }

  Future<void> deleteFavorite(String id) async {
    final key = HiveStore.favoriteImageBox.keys.firstWhere(
      (k) => HiveStore.favoriteImageBox.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await HiveStore.favoriteImageBox.delete(key);
    }
  }

  List<String> getAllFavorite() {
    return HiveStore.favoriteImageBox.values
        .map((e) => e.id)
        .whereType<String>()
        .toList();
  }

  Future<void> toggleFavorite(String id) async {
    final key = HiveStore.favoriteImageBox.keys.firstWhere(
      (k) => HiveStore.favoriteImageBox.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await deleteFavorite(id);
    } else {
      await saveFavorite(id);
    }
  }

  bool isFavorite(String id) {
    return HiveStore.favoriteImageBox.containsKey(id);
  }

  Future<void> saveDeleteImageData(
    DateTime dateTime,
    int valueFreedBytes,
    int imageDelete,
    int imageRetain,
  ) async {
    await HiveStore.deleteImageBox.add(
      DeleteImageModel(
        deletedAt: dateTime,
        sizeFreedBytes: valueFreedBytes,
        imageDelete: imageDelete,
        imageRetain: imageRetain,
      ),
    );
  }

  int getByteAllDataDeleteImage() {
    return HiveStore.deleteImageBox.values
        .map((e) => e.sizeFreedBytes)
        .whereType<int>()
        .toList()
        .fold<int>(0, (previousValue, element) => previousValue + element);
  }

  int getByteDataDeleteImageInRange(DateTime start, DateTime end) {
    return HiveStore.deleteImageBox.values
        .map((e) => e.deletedAt.isBetween(start, end))
        .whereType<int>()
        .toList()
        .fold<int>(0, (previousValue, element) => previousValue + element);
  }

  DeleteImageModel getDataDeleteImageInRange(DateTime start, DateTime end) {
    final filtered = HiveStore.deleteImageBox.values
        .where((e) => e.deletedAt.isAfter(start) && e.deletedAt.isBefore(end))
        .toList();

    AppLog.info(
      'getDataDeleteImageInRange: ${HiveStore.deleteImageBox.values.map((e) => e.deletedAt).join(', ')}\nstart: $start, end: $end',
      tag: 'LocalRepository',
    );

    if (filtered.isEmpty) {
      return DeleteImageModel(
        deletedAt: start,
        sizeFreedBytes: 0,
        imageDelete: 0,
        imageRetain: 0,
      );
    }

    final totalSize = filtered.fold<int>(0, (sum, e) => sum + e.sizeFreedBytes);
    final totalDeleted = filtered.fold<int>(0, (sum, e) => sum + e.imageDelete);
    final totalRetained = filtered.fold<int>(
      0,
      (sum, e) => sum + e.imageRetain,
    );

    return DeleteImageModel(
      deletedAt: start,
      sizeFreedBytes: totalSize,
      imageDelete: totalDeleted,
      imageRetain: totalRetained,
    );
  }
}
