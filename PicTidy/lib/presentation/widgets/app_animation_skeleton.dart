import 'package:flutter/material.dart';
import 'package:spine_flutter/spine_flutter.dart';

class AppAnimationSkeleton extends StatefulWidget {
  const AppAnimationSkeleton({
    super.key,
    required this.atlasPath,
    required this.skeletonPath,
    this.animation = 'animation',
    this.isLooping = true,
    this.time = 0,
    this.sizedByBounds = true,
  });

  final String atlasPath;
  final String skeletonPath;
  final String animation;
  final bool isLooping;
  final bool sizedByBounds;
  final int time;

  @override
  State<AppAnimationSkeleton> createState() => _AppAnimationSkeletonState();
}

class _AppAnimationSkeletonState extends State<AppAnimationSkeleton> {
  late final SpineWidgetController controller;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    reportLeaks();
    controller = SpineWidgetController(
      onInitialized: (controller) {
        controller.animationState.setAnimationByName(
          0,
          widget.animation,
          widget.isLooping,
        );
      },
    );

    if (widget.time > 0 && !widget.isLooping) {
      Future.delayed(Duration(milliseconds: widget.time), () {
        if (mounted && !isDone) {
          isDone = true;
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: isDone
          ? const SizedBox.shrink()
          : SpineWidget.fromAsset(
              widget.atlasPath,
              widget.skeletonPath,
              controller,
              boundsProvider: SkinAndAnimationBounds(
                animation: widget.animation,
              ),
              sizedByBounds: widget.sizedByBounds,
            ),
    );
  }
}
