import 'package:awesome_video_player/awesome_video_player.dart';
import 'package:awesome_video_player/src/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../resources/colors.dart';
import 'app_button_circle.dart';
import 'custom_progress_bar.dart';

class CustomControlPlayer extends StatefulWidget {
  const CustomControlPlayer({
    super.key,
    required this.controller,
    this.isLiked = false,
    this.onPressLike,
    required this.controlsConfiguration,
  });
  final BetterPlayerController? controller;
  final BetterPlayerControlsConfiguration controlsConfiguration;
  final bool isLiked;
  final Function(bool isLike)? onPressLike;

  @override
  State<CustomControlPlayer> createState() => _CustomControlPlayerState();
}

class _CustomControlPlayerState extends State<CustomControlPlayer> {
  VideoPlayerValue? _latestValue;
  double? _latestVolume;

  VideoPlayerController? get videoPlayerController =>
      widget.controller?.videoPlayerController;

  @override
  void initState() {
    videoPlayerController?.addListener(_updateState);
    _updateState();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(_updateState);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _latestValue = videoPlayerController?.value;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CustomControlPlayer oldWidget) {
    _latestValue = videoPlayerController?.value;

    if (oldWidget.controller != widget.controller ||
        oldWidget.isLiked != widget.isLiked) {
      debugPrint("CustomControlPlayer didUpdateWidget ${widget.controller}");
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _latestValue = videoPlayerController?.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 12.h,
      children: [
        AppButtonCircle(
          onPressed: () {
            if (_latestValue!.volume == 0) {
              widget.controller?.setVolume(_latestVolume ?? 0.5);
            } else {
              _latestVolume = videoPlayerController?.value.volume;
              widget.controller?.setVolume(0.0);
            }
            setState(() {});
          },
          width: 36.w,
          height: 36.h,
          backgroundColor: AppColors.blackD23.withValues(alpha: 0.6),
          child:
              (_latestValue?.volume == 0
                      ? Assets.icons.mute
                      : Assets.icons.unmute)
                  .svg(width: 20.w, height: 20.h),
        ),
        AppButtonCircle(
          onPressed: () {
            widget.controller?.isPlaying() == true
                ? widget.controller?.pause()
                : widget.controller?.play();
            setState(() {});
          },
          width: 36.w,
          height: 36.h,
          backgroundColor: AppColors.blackD23.withValues(alpha: 0.6),
          child:
              (widget.controller?.isPlaying() != false
                      ? Assets.icons.pause
                      : Assets.icons.play)
                  .svg(width: 20.w, height: 20.h),
        ),
        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: BetterPlayerCustomProgressBar(
                widget.controller?.videoPlayerController,
                widget.controller,
                colors: BetterPlayerProgressColors(
                  backgroundColor: AppColors.dark300,
                  bufferedColor: AppColors.transparent,
                  playedColor: AppColors.mint300,
                ),
              ),
            ),
            AppButtonCircle(
              onPressed: () {
                widget.onPressLike?.call(!widget.isLiked);
                setState(() {});
              },
              width: 36.w,
              height: 36.h,
              backgroundColor: AppColors.blackD23.withValues(alpha: 0.6),
              child: (widget.isLiked ? Assets.icons.liked : Assets.icons.like)
                  .svg(width: 20.w, height: 20.h),
            ),
          ],
        ),
      ],
    );
  }
}
