import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import 'package:photo_manager/photo_manager.dart';

class FindSimilarUtils {
  FindSimilarUtils._internal();

  static final FindSimilarUtils instance = FindSimilarUtils._internal();

  factory FindSimilarUtils() => instance;

  Map<AssetEntity, String> mapHashed = {};
  Map<AssetEntity, Uint8List> mapImageData = {};

  Future<void> calculateAllAssetInfo(List<AssetEntity> assets) async {
    final stopwatch = Stopwatch()..start();
    print('Bắt đầu tìm độ tương đồng...: ${stopwatch.elapsedMilliseconds}ms');

    await Future.wait(
      assets.map((asset) async {
        final thumb = await asset.thumbnailDataWithSize(ThumbnailSize(64, 64));
        if (thumb == null) return;

        final image = img.decodeImage(thumb);
        if (image == null) return;

        mapImageData[asset] = thumb;
        final hash = _computeHash(image);
        mapHashed[asset] = hash;
      }),
    );

    print(
      'Đã hash xong ${assets.length} ảnh thu được ${mapHashed.length} hash: ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  List<List<AssetEntity>> findSimilarAssets(int maxDistance) {
    final stopwatch = Stopwatch()..start();
    if (mapHashed.isEmpty) {
      throw Exception('Chưa tính toán hash cho ảnh nào.');
    }

    final clusters = _clusterImages(
      mapHashed,
      maxDistance,
    ); //  khoảng cách tối đa giữa 2 ảnh giống

    print('Lọc similar <=5: ${stopwatch.elapsedMilliseconds}ms');

    // ❌ Bỏ cụm chỉ có 1 ảnh
    final filteredClusters = clusters.where((c) => c.length > 1).toList();

    // In ra thông tin các cụm ảnh hợp lệ
    for (int i = 0; i < filteredClusters.length; i++) {
      debugPrint('📂 Cụm ${i + 1}: ${filteredClusters[i].length} ảnh');
      for (final asset in filteredClusters[i]) {
        debugPrint('  - ${asset.id}');
      }
    }

    return filteredClusters;
  }

  List<List<AssetEntity>> findExactDuplicateAssets() {
    final visited = <AssetEntity>{};
    final clusters = <List<AssetEntity>>[];

    for (final entry1 in mapImageData.entries) {
      if (visited.contains(entry1.key)) continue;

      final cluster = <AssetEntity>[entry1.key];
      visited.add(entry1.key);

      for (final entry2 in mapImageData.entries) {
        if (visited.contains(entry2.key)) continue;

        if (_areBytesEqual(entry1.value, entry2.value)) {
          cluster.add(entry2.key);
          visited.add(entry2.key);
        }
      }

      if (cluster.length > 1) {
        clusters.add(cluster);
      }
    }

    return clusters;
  }

  bool _areBytesEqual(Uint8List a, Uint8List b) {
    if (a.lengthInBytes != b.lengthInBytes) return false;
    return listEquals(a, b);
  }

  List<List<AssetEntity>> _clusterImages(
    Map<AssetEntity, String> hashes,
    int maxDistance,
  ) {
    final visited = <AssetEntity>{};
    final clusters = <List<AssetEntity>>[];

    for (final entry in hashes.entries) {
      if (visited.contains(entry.key)) continue;

      final cluster = <AssetEntity>[entry.key];
      visited.add(entry.key);

      for (final other in hashes.entries) {
        if (visited.contains(other.key)) continue;

        final dist = _hammingDistance(entry.value, other.value);
        if (dist <= maxDistance) {
          cluster.add(other.key);
          visited.add(other.key);
        }
      }

      clusters.add(cluster);
    }

    return clusters;
  }

  String _computeHash(img.Image image) {
    // Resize ảnh 8x8 và chuyển grayscale
    final resized = img.copyResize(image, width: 8, height: 8);
    final grayscale = img.grayscale(resized);

    // Tính độ sáng trung bình
    final pixels = grayscale.getBytes();
    final avg = pixels.reduce((a, b) => a + b) ~/ pixels.length;

    // Tạo hash
    return pixels.map((e) => e > avg ? '1' : '0').join();
  }

  int _hammingDistance(String hash1, String hash2) {
    int diff = 0;
    for (int i = 0; i < hash1.length; i++) {
      if (hash1[i] != hash2[i]) diff++;
    }
    return diff;
  }
}
