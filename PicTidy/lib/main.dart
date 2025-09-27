import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

import 'app.dart';
import 'app_bloc.dart';
import 'data/local/hive_store.dart';
import 'di/di.dart';
import 'flavors.dart';
import 'shared/utils/app_log.dart';
import 'shared/utils/bloc_observer.dart';
import 'shared/utils/share_preference_utils.dart';

void main() {
  F.appFlavor = Flavor.values.firstWhere(
        (element) => element.name == appFlavor,
    orElse: () => Flavor.prod,
  );

  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      configureDeviceUI();
      await initSpineFlutter(enableMemoryDebugging: false);
      Bloc.observer = AppBlocObserver();
      await configureDependencies();
      await HiveStore.init();
      await getIt<PreferenceUtils>().init();

      VideoPlayerMediaKit.ensureInitialized(android: true);
      await _startApp();
    },
        (error, stack) {
      AppLog.error('Error: $error\n$stack', tag: 'Main');
    },
  );
}

void configureDeviceUI() {
  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Android-specific UI configuration
  if (Platform.isAndroid) {
    // Set transparent status and navigation bars
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    // Hide navigation bar initially
    hideSystemNavigationBar();

    // Auto-hide navigation bar if it becomes visible
    SystemChrome.setSystemUIChangeCallback((bool uiVisible) async {
      if (uiVisible) {
        Future<void>.delayed(
          const Duration(seconds: 3),
          hideSystemNavigationBar,
        );
      }
    });
  }
}

void hideSystemNavigationBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

Future _startApp() async {
  runApp(
    BlocProvider.value(
      value: getIt<AppBloc>()..add(const AppEvent.loadData()),
      child: const MyApp(),
    ),
  );
}
