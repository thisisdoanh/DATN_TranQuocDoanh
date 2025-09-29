import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../gen/assets.gen.dart';
import '../resources/colors.dart';

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    super.key,
    required this.entity,
    required this.option,
    this.onTap,
    this.topRightWidget = const SizedBox.shrink(),
    this.topLeftWidget = const SizedBox.shrink(),
    this.coverWidget = const SizedBox.shrink(),
    this.isShowTopLeftWidget = false,
    this.isShowTopRightWidget = false,
    this.radius = 0,
    this.placeholderWidget,
    this.bottomLeftWidget,
    this.bottomRightWidget,
    this.imageData,
    this.fit = BoxFit.cover,
    this.scale = 1,
  });

  final AssetEntity entity;
  final Uint8List? imageData;
  final ThumbnailOption option;
  final GestureTapCallback? onTap;
  final Widget topRightWidget;
  final Widget topLeftWidget;
  final Widget? bottomLeftWidget;
  final Widget? bottomRightWidget;
  final Widget coverWidget;
  final Widget? placeholderWidget;
  final bool isShowTopLeftWidget;
  final bool isShowTopRightWidget;
  final double radius;
  final BoxFit fit;
  final double scale;

  Widget _buildImageWidget(
    BuildContext context,
    AssetEntity entity,
    ThumbnailOption option,
  ) {
    final ratio = entity.width / entity.height;
    final shouldRotate = ratio > (4 / 3); // hoặc tùy bạn, ví dụ > 1.5 cũng được

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.black1E),
            ),
          ),
          Positioned.fill(child: placeholderWidget ?? const SizedBox.shrink()),
          Positioned.fill(
            child: RepaintBoundary(
              child: imageData != null
                  ? _buildUIImage(shouldRotate)
                  : Transform.scale(
                      scale: shouldRotate ? scale : 1,
                      child: Transform.rotate(
                        angle: shouldRotate ? -pi / 2 : 0,
                        child: AssetEntityImage(
                          entity,
                          isOriginal: false,
                          thumbnailSize: shouldRotate
                              ? ThumbnailSize(
                                  option.size.height,
                                  option.size.width,
                                )
                              : option.size,
                          thumbnailFormat: option.format,
                          filterQuality: FilterQuality.low,
                          fit: fit,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            if (placeholderWidget != null) {
                              return placeholderWidget!;
                            }
                            final total = loadingProgress.expectedTotalBytes;
                            final loaded =
                                loadingProgress.cumulativeBytesLoaded;

                            double? progress;
                            if (total != null && total > 0) {
                              progress = loaded / total;
                            }

                            return Center(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator(
                                  value: progress, // null = indeterminate
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) =>
                                  child,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              ),
                        ),
                      ),
                    ),
            ),
          ),
          if (isShowTopLeftWidget || isShowTopRightWidget)
            Positioned(
              top: 8.h,
              left: 10.w,
              right: 10.w,
              child: Row(
                children: [
                  if (isShowTopLeftWidget) topLeftWidget,
                  const Spacer(),
                  if (isShowTopRightWidget) topRightWidget,
                ],
              ),
            ),

          if (bottomLeftWidget != null)
            Positioned(
              left: 6.w,
              bottom: 8.h,
              right: 6.w,
              child: Row(
                children: [
                  ?bottomLeftWidget,
                  const Spacer(),
                  ?bottomRightWidget,
                ],
              ),
            ),

          Positioned.fill(child: coverWidget),
        ],
      ),
    );
  }

  Widget _buildUIImage(bool shouldRotate) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Assets.images.bgRemove.image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Transform.scale(
            scale: shouldRotate ? scale : 1,
            child: Transform.rotate(
              angle: shouldRotate ? -pi / 2 : 0,
              child: Image.memory(imageData!, fit: fit),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: _buildImageWidget(context, entity, option),
    );
  }
}
