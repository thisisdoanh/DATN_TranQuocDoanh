part of '../memory_page.dart';

class RecentRandomComponent extends StatelessWidget {
  const RecentRandomComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryBloc, MemoryState>(
      buildWhen: (previous, current) {
        if (previous.listRecent != current.listRecent) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return SizedBox(
          height: 135.h,
          child: Stack(
            children: [
              Positioned(
                left: 16.w,
                width: 169.w,
                height: 135.h,
                child: AppTouchable(
                  onPressed: () => context.read<MemoryBloc>().add(
                    const MemoryEvent.recent(),
                  ),
                  rippleColor: AppColors.transparent,
                  child: Stack(
                    children: [
                      Assets.images.recentBackground.image(),
                      Positioned(
                        top: 12.h,
                        left: 16.w,
                        child: Text(
                          S.of(context).recent,
                          style: AppStyles.titleXLSemi16(AppColors.dark100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16.w,
                width: 169.w,
                height: 135.h,
                child: AppTouchable(
                  onPressed: () => context.read<MemoryBloc>().add(
                    const MemoryEvent.random(),
                  ),
                  rippleColor: AppColors.transparent,
                  child: Stack(
                    children: [
                      Assets.images.randomBackground.image(),
                      Positioned(
                        top: 12.h,
                        right: 16.w,
                        child: Text(
                          S.of(context).random,
                          style: AppStyles.titleXLSemi16(AppColors.dark100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.listRecent.isNotEmpty)
                Positioned(
                  left: 90.w,
                  top: 35.h,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.semanticRed200,
                    ),
                    padding: EdgeInsets.all(5.r),
                    alignment: Alignment.center,
                    child: Text(
                      state.listRecent.length.toString(),
                      style: AppStyles.titleXLSemi16(AppColors.light100),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
