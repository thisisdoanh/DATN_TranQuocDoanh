import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/utils/share_preference_utils.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../router/router.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../../widgets/custom_bottom_navigation_bar_item.dart';
import 'home_bloc.dart';

@RoutePage()
class HomePage extends BasePage<HomeBloc, HomeEvent, HomeState> {
  const HomePage({super.key})
    : super(screenName: 'HomePage', isSingletonBloc: true);

  @override
  void onInitState(BuildContext context) {
    context.read<HomeBloc>().add(const HomeEvent.loadData());
    context.read<HomeBloc>().add(const HomeEvent.getPhotoAndVideo());
    getIt<PreferenceUtils>().setBool('is_first_open_app', false);

    super.onInitState(context);
  }

  List<PageRouteInfo<Object?>> get homeRoutes => [
    const CleanRoute(),
    const MemoryRoute(),
    const MoreRoute(),
  ];

  @override
  Widget builder(BuildContext context) {
    return AppContainer(
      child: AutoTabsRouter(
        routes: homeRoutes,
        builder: (context, child) {
          final tabRouter = AutoTabsRouter.of(context);
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: child),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Assets.images.blurHome.image(),
              ),
              Positioned(
                bottom: 20.h,
                left: 16.w,
                right: 16.w,
                child: CustomBottomNavigationBar(
                  spacing: 12.w,
                  currentIndex: tabRouter.activeIndex,
                  onPressed: (index) {
                    tabRouter.setActiveIndex(index);
                  },
                  selectedColor: AppColors.green789,
                  items: [
                    CustomBottomNavigationBarItem(
                      label: S.of(context).clean,
                      icon: Assets.icons.cleanTab,
                      disableIcon: Assets.icons.cleanTabDisable,
                    ),
                    CustomBottomNavigationBarItem(
                      label: S.of(context).memory,
                      icon: Assets.icons.memoryTab,
                      disableIcon: Assets.icons.memoryTabDisable,
                    ),
                    CustomBottomNavigationBarItem(
                      label: S.of(context).settings,
                      icon: Assets.icons.settingTab,
                      disableIcon: Assets.icons.settingTabDisable,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
