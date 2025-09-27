import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'app_bloc.dart';
import 'di/di.dart';
import 'domain/enums/language.dart';
import 'generated/l10n.dart';
import 'presentation/resources/dimens.dart';
import 'presentation/resources/light/light_theme.dart';
import 'presentation/router/router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter appRouter;

  @override
  void initState() {
    appRouter = getIt<AppRouter>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Dimens.updatePaddingDevice(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) {
          if (previous.mode != current.mode) {
            return true;
          }
          if (previous.currentLanguage != current.currentLanguage) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return OKToast(
            child: MaterialApp.router(
              themeMode: state.mode,
              routerDelegate: getIt<AppRouter>().delegate(
                navigatorObservers: () => [
                  AutoRouteObserver(),
                  LoggingRouteObserver(),
                ],
              ),
              routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
              routeInformationProvider: getIt<AppRouter>()
                  .routeInfoProvider(),
              locale: state.currentLanguage.locale,
              debugShowCheckedModeBanner: false,
              theme: lightThemeData,
              builder: (context, child) {
                return Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (context) => child ?? const SizedBox.shrink(),
                    ),
                  ],
                );
              },
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}

class LoggingRouteObserver extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _log('PUSH', from: previousRoute, to: route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _log('POP', from: route, to: previousRoute);
  }

  void _log(String action, {Route? from, Route? to}) {
    final fromName = _getRouteName(from);
    final toName = _getRouteName(to);

    print('[ROUTE] $action: from $fromName → to $toName');
  }

  String _getRouteName(Route? route) {
    if (route == null) return 'null';
    return route.settings.name ?? route.runtimeType.toString();
  }
}
