import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite_image_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class FavoriteImageModel {
  FavoriteImageModel({required this.id});

  factory FavoriteImageModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteImageModelToJson(this);

  @HiveField(1)
  final String id;
}
