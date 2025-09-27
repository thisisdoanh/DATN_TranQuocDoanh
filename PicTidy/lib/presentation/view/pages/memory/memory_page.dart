import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/entities/photo_by_month_year.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/extension/widget.dart';
import '../../../../shared/utils/app_utils.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/dimens.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_touchable.dart';
import '../../../widgets/placeholders.dart';
import '../home/home_bloc.dart';
import 'memory_bloc.dart';
import 'painter/text_with_background_painter.dart';

part 'component/item_month_component.dart';
part 'component/memory_component.dart';
part 'component/recent_random_component.dart';
part 'component/year_component.dart';

@RoutePage()
class MemoryPage extends BasePage<MemoryBloc, MemoryEvent, MemoryState> {
  const MemoryPage({super.key}) : super(screenName: 'MemoryPage');

  @override
  void onInitState(BuildContext context) {
    context.read<MemoryBloc>().add(const MemoryEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return Stack(
      children: [
        Assets.images.memoryTabBackground.image(
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return CustomScrollView(
              cacheExtent: 500, // Cache more items for smoother scrolling
              slivers: [
                SliverToBoxAdapter(
                  child: RepaintBoundary(
                    child: Column(
                      children: [
                        const MemoryComponent().paddingOnly(
                          top:
                              MediaQuery.paddingOf(context).top +
                              16.h +
                              Dimens.paddingTop,
                        ),
                        12.verticalSpace,
                        const RecentRandomComponent(),
                        16.verticalSpace,
                      ],
                    ),
                  ),
                ),
                DecoratedSliver(
                  decoration: BoxDecoration(color: AppColors.white),
                  sliver: SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    sliver: SliverList.builder(
                      itemBuilder: (context, index) {
                        final yearGroup =
                            state.albumPhotoByYear[index %
                                state
                                    .albumPhotoByYear
                                    .length]; // kiểu PhotoByYear
                        return YearComponent(yearGroup: yearGroup);
                      },

                      itemCount: state.albumPhotoByYear.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(height: 150.h, color: AppColors.white),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void onPressRecent(BuildContext context) {
    context.read<MemoryBloc>().add(const MemoryEvent.recent());
  }

  void onPressRandom(BuildContext context) {
    context.read<MemoryBloc>().add(const MemoryEvent.random());
  }
}
