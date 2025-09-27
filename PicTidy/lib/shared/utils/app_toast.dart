import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../gen/assets.gen.dart';
import '../../presentation/widgets/app_animation_skeleton.dart';

class AppToast {
  factory AppToast() => instance;
  AppToast._internal();

  static final AppToast instance = AppToast._internal();

  Future<void> show({
    BuildContext? context,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Widget? icon,
    Widget? title,
    Widget? description,
    Border? border,
    double? spacingIcon,
    double? spacingContent,
    EdgeInsets? padding,
    EdgeInsets? margin,
    List<BoxShadow>? shadows,
    ToastPosition? position,
    bool isUseAnimation = false,
  }) async {
    showToastWidget(
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: padding,
            margin: margin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: border,
              boxShadow: shadows,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: spacingIcon ?? 0,
              children: [
                ?icon,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: spacingContent ?? 0,
                  children: [?title, ?description],
                ),
              ],
            ),
          ),
          if (isUseAnimation)
            Positioned.fill(
              child: AppAnimationSkeleton(
                atlasPath: Assets.anim.blingBlingAtlas,
                skeletonPath: Assets.anim.blingBlingJson,
              ),
            ),
        ],
      ),
      position: position ?? ToastPosition.top,
      context: context,
    );
  }
}
