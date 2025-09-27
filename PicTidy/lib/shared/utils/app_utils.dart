import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

import '../../generated/l10n.dart';

class AppUtils {
  factory AppUtils() {
    return instance;
  }

  AppUtils._internal();

  static final AppUtils instance = AppUtils._internal();

  Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size;
  }

  Future<int> getSizeInBytesOfList(List<AssetEntity> images) async {
    final sizes = await Future.wait(images.map(getSizeInBytesOfItem));
    return sizes.fold<int>(0, (a, b) => a + b);
  }

  Future<int> getSizeInBytesOfItem(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null && file.existsSync()) {
      return file.lengthSync(); // Trả về kích thước tính bằng byte
    }
    return 0;
  }

  Future<void> shareAsset(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null && file.existsSync()) {
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } else {
      debugPrint('File is null or does not exist for asset: $asset');
      showToast(
        S.current.thereWasAnErrorSharingTheFilePleaseTryAgain,
        position: ToastPosition.bottom,
      );
    }
  }
}
