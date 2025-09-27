import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_image_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class DeleteImageModel {
  DeleteImageModel({
    required this.deletedAt,
    required this.sizeFreedBytes,
    required this.imageDelete,
    required this.imageRetain,
  });

  factory DeleteImageModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteImageModelToJson(this);

  @HiveField(1)
  final DateTime deletedAt;
  @HiveField(2)
  final int sizeFreedBytes;
  @HiveField(3)
  final int imageDelete;
  @HiveField(4)
  final int imageRetain;
}
