import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../resources/colors.dart';
import '../../../../widgets/app_touchable.dart';
import '../../../../widgets/marquee_widget.dart';
import '../clean_bloc.dart';
import '../painter/gradient_text_painter.dart';

class ScreenShotComponent extends StatefulWidget {
  const ScreenShotComponent({super.key});

  @override
  State<ScreenShotComponent> createState() => _ScreenShotComponentState();
}

class _ScreenShotComponentState extends State<ScreenShotComponent> {
  Size sizeText = Size.zero;

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPressed: () =>
          context.read<CleanBloc>().add(const CleanEvent.onPressScreenShot()),
      rippleColor: AppColors.transparent,
      child: Stack(
        children: [
          Assets.images.bgScreenshotHome.image(
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),

          Positioned(
            top: 8.h,
            left: 12.w,
            height: 30.h,
            width: 105.w,
            child: MarqueeWidget(
              padding: 0,
              maxWidth: 105.w,
              widgetWidth: sizeText.width,
              height: sizeText.height,
              child: CustomPaint(
                painter: GradientTextStrokePainter(
                  text: S.of(context).screenshot,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark100,
                    fontFamily: FontFamily.manrope,
                  ),
                  colors: [const Color(0xFF7AFBB4), const Color(0xFFFFFFFF)],
                  sizeCallback: (size) {
                    if (sizeText != size) {
                      sizeText = size;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    }
                  },
                  isHasShadow: false,
                ),
                child: Opacity(
                  opacity: 0,
                  child: Text(
                    S.of(context).screenshot,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark100,
                      fontFamily: FontFamily.manrope,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 31.w,
            bottom: 0.h,
            child: Assets.images.screenshotHomeComponent.image(
              height: 82.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
