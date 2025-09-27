import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../hive_registrar.g.dart';
import 'model/delete_image_model.dart';
import 'model/favorite_image_model.dart';

class HiveStore {
  HiveStore._();
  static late Box<FavoriteImageModel> favoriteImageBox;
  static late Box<DeleteImageModel> deleteImageBox;

  static Future<void> init() async {
    final appDocumentDirectory = await path_provider
        .getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapters();
    favoriteImageBox = await Hive.openBox('favoriteImageBox');
    deleteImageBox = await Hive.openBox('deleteImageBox');
  }
}
