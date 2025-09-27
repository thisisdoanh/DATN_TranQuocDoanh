import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

class Photo extends Equatable {
  const Photo({
    required this.albumName,
    this.albumId = '',
    this.assetCount = 0,
    this.isAll = false,
    this.photos = const [],
  });
  final String albumName;
  final String albumId;
  final int assetCount;
  final bool isAll;
  final List<AssetEntity> photos;

  @override
  List<Object?> get props => [albumName, albumId, assetCount, isAll, photos];

  Photo copyWith({
    String? albumName,
    String? albumId,
    int? assetCount,
    bool? isAll,
    List<AssetEntity>? photos,
  }) {
    return Photo(
      albumName: albumName ?? this.albumName,
      albumId: albumId ?? this.albumId,
      assetCount: assetCount ?? this.assetCount,
      isAll: isAll ?? this.isAll,
      photos: photos ?? this.photos,
    );
  }
}
