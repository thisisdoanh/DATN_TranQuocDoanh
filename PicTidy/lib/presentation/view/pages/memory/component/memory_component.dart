part of '../memory_page.dart';

class MemoryComponent extends StatelessWidget {
  const MemoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPressed: () =>
          context.read<MemoryBloc>().add(const MemoryEvent.memory()),
      rippleColor: AppColors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Assets.images.memoryBackground.image(width: 328.w, height: 173.h),
          Positioned(
            top: 12.h,
            left: 24.w,
            right: 24.w,
            child: Column(
              children: [
                Text(
                  S.of(context).throwbackMoment,
                  style: AppStyles.titleXLBold16(AppColors.green92A),
                ),
                BlocBuilder<MemoryBloc, MemoryState>(
                  buildWhen: (previous, current) {
                    if (previous.listMemory != current.listMemory) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state.listMemory.isNotEmpty) {
                      return CustomPaint(
                        size: Size(
                          AppUtils.instance
                              .getTextSize(
                                S.of(context).letsLookBackOnThisDayInThePast,
                                AppStyles.bodyLMedium12(
                                  AppColors.semanticBlue100,
                                ),
                              )
                              .width,
                          28.h,
                        ),
                        painter: TextWithBackgroundPainter(
                          text: S.of(context).letsLookBackOnThisDayInThePast,
                          colors: [
                            AppColors.white.withValues(alpha: 0),
                            AppColors.white.withValues(alpha: 1),
                            AppColors.white.withValues(alpha: 0),
                          ],
                          stops: [0, 0.43, 1],
                          textStyle: AppStyles.bodyLMedium12(
                            AppColors.semanticBlue100,
                          ),
                        ),
                      );
                    }

                    return CustomPaint(
                      size: Size(
                        AppUtils.instance
                            .getTextSize(
                              S.of(context).nothingToRememberToday,
                              AppStyles.bodyLMedium12(AppColors.dark300),
                            )
                            .width,
                        28.h,
                      ),
                      painter: TextWithBackgroundPainter(
                        text: S.of(context).nothingToRememberToday,
                        colors: [
                          AppColors.white.withValues(alpha: 0),
                          AppColors.white.withValues(alpha: 1),
                          AppColors.white.withValues(alpha: 0),
                        ],
                        stops: [0, 0.43, 1],
                        textStyle: AppStyles.bodyLMedium12(AppColors.dark300),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
