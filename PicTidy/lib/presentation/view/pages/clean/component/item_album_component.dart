import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../domain/entities/photo.dart';
import '../../../../../shared/extension/widget.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/styles.dart';
import '../../../../widgets/image_item_widget.dart';
import '../../../../widgets/placeholders.dart';
import '../clean_bloc.dart';
import '../painter/item_album_background_painter.dart';

class ItemAlbumComponent extends StatefulWidget {
  const ItemAlbumComponent({super.key, required this.photo});

  final Photo photo;

  @override
  State<ItemAlbumComponent> createState() => _ItemAlbumComponentState();
}

class _ItemAlbumComponentState extends State<ItemAlbumComponent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Flexible(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: ItemAlbumBackgroundPainter(),
              child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: ImageItemWidget(
                      key: ValueKey<String>(
                        '${widget.photo.albumId}_${widget.photo.photos.first.id}',
                      ),
                      entity: widget.photo.photos.first,
                      option: const ThumbnailOption(
                        size: ThumbnailSize.square(200),
                        quality: 20,
                      ),
                      fit: BoxFit.cover,
                      onTap: () => context.read<CleanBloc>().add(
                        CleanEvent.onPressAlbum(widget.photo),
                      ),

                    ),
                  ).withPadding(
                    EdgeInsets.only(
                      top: 15.h,
                      bottom: 5.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.photo.albumName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.titleLBold14(AppColors.dark200),
        ),
        Text(
          '(${widget.photo.photos.length})',
          textAlign: TextAlign.center,
          style: AppStyles.bodyLRegular14(AppColors.dark200),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
