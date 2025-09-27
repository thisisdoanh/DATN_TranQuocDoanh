import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../data/local/model/delete_image_model.dart';
import '../../gen/assets.gen.dart';
import '../view/pages/clean/clean_page.dart';
import '../view/pages/confirm_delete/confirm_delete_page.dart';
import '../view/pages/delete_complete/delete_complete_page.dart';
import '../view/pages/empty_warning/empty_warning_page.dart';
import '../view/pages/home/home_page.dart';
import '../view/pages/language/language_page.dart';
import '../view/pages/memory/memory_page.dart';
import '../view/pages/more/more_page.dart';
import '../view/pages/my_statistics/my_statistics_page.dart';
import '../view/pages/my_statistics_detail/my_statistics_detail_page.dart';
import '../view/pages/on_boarding/on_boarding_page.dart';
import '../view/pages/permission/permission_page.dart';
import '../view/pages/similar/similar_page.dart';
import '../view/pages/slide_wipe/slide_wipe_page.dart';
import '../view/pages/slide_wipe_video/slide_wipe_video_page.dart';
import '../view/pages/splash/splash_page.dart';

part 'router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page|Dialog|Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(
      page: HomeRoute.page,
      children: [
        AutoRoute(page: CleanRoute.page, initial: true),
        AutoRoute(page: MemoryRoute.page),
        AutoRoute(page: MoreRoute.page),
      ],
    ),
    AutoRoute(page: PermissionRoute.page),
    AutoRoute(page: OnBoardingRoute.page),
    AutoRoute(page: EmptyWarningRoute.page),
    AutoRoute(page: SlideWipeRoute.page),
    AutoRoute(page: ConfirmDeleteRoute.page),
    AutoRoute(page: LanguageRoute.page),
    AutoRoute(page: SlideWipeVideoRoute.page),
    AutoRoute(page: DeleteCompleteRoute.page),
    AutoRoute(page: MyStatisticsRoute.page),
    AutoRoute(page: MyStatisticsDetailRoute.page),
    AutoRoute(page: SimilarRoute.page),
  ];
}
