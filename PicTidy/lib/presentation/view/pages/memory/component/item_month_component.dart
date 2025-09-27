part of '../memory_page.dart';

class ItemMonthComponent extends StatefulWidget {
  const ItemMonthComponent({super.key, required this.listAssets});

  final List<AssetEntity> listAssets;

  @override
  State<ItemMonthComponent> createState() => _ItemMonthComponentState();
}

class _ItemMonthComponentState extends State<ItemMonthComponent>
    with AutomaticKeepAliveClientMixin {
  int angle1 = 0;
  int angle2 = 0;

  @override
  void initState() {
    generatePair();
    super.initState();
  }

  Widget _getWidgetImage(int index) {
    if (index < widget.listAssets.length) {
      return SizedBox(
        width: 110,
        height: 135,
        child: AssetEntityImage(
          widget.listAssets[index],
          isOriginal: false,
          thumbnailSize: const ThumbnailSize(110, 135),
          filterQuality: FilterQuality.low,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Shimmer.fromColors(
              baseColor: Colors.grey.shade600,
              highlightColor: Colors.grey.shade50,

              child: const RectanglePlaceholder(width: 110, height: 135),
            );

            final total = loadingProgress.expectedTotalBytes;
            final loaded = loadingProgress.cumulativeBytesLoaded;

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
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 32),
          ),
        ),
      );
    } else {
      return Container(width: 110, height: 135, color: const Color(0xFFE8ECEE));
    }
  }

  Widget _buildWidget(int index) {
    return Transform.rotate(
      angle: (index == 0 ? angle2 : angle1) * pi / 180,
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(13.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.2),
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(13.r),
          child: _getWidgetImage(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [_buildWidget(1), _buildWidget(0)],
    );
  }

  void generatePair() {
    final random = Random();
    int a, b;

    final bool isNegative = random.nextBool();

    if (isNegative) {
      // Nếu là số âm thì a sẽ là âm, b sẽ là dương
      a = random.nextInt(11) - 20; // từ -20 đến -10
      b = random.nextInt(11) + 10; // từ 10 đến 20
    } else {
      // Nếu là số dương thì a sẽ là dương, b sẽ là âm
      b = random.nextInt(11) - 20; // từ -20 đến -10
      a = random.nextInt(11) + 10; // từ 10 đến 20
    }

    setState(() {
      angle1 = a;
      angle2 = b;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
