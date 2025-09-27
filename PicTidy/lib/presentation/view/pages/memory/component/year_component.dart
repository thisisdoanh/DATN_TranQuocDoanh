part of '../memory_page.dart';

class YearComponent extends StatelessWidget {
  const YearComponent({super.key, required this.yearGroup});

  final PhotoByMonthYear yearGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -2.5.h,
              right: -2.5.w,
              child: Assets.images.yearTextMemoryComponent.image(
                height: 12.h,
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              '${yearGroup.year}',
              style: AppStyles.titleXXLSemi20(AppColors.black),
            ),
          ],
        ),
        20.verticalSpace,

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 20.h,
          spacing: 16.w,
          children: [
            for (final month in yearGroup.months)
              AppTouchable(
                onPressed: () => context.read<MemoryBloc>().add(
                  MemoryEvent.onPressMonth(month),
                ),
                width: 156.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 160.h,
                      child: ItemMonthComponent(listAssets: month.photos),
                    ),
                    Text(
                      month.month,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.titleXLBold16(AppColors.dark200),
                    ),
                    Text(
                      '(${month.photos.length})',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyLRegular14(AppColors.dark200),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
