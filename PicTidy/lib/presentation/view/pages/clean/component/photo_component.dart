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

class PhotoComponent extends StatefulWidget {
  const PhotoComponent({super.key});

  @override
  State<PhotoComponent> createState() => _PhotoComponentState();
}

class _PhotoComponentState extends State<PhotoComponent> {
  Size sizeText = Size.zero;

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPressed: () =>
          context.read<CleanBloc>().add(const CleanEvent.onPressPhoto()),
      rippleColor: AppColors.transparent,
      child: Stack(
        children: [
          // Background image - cached
          RepaintBoundary(
            child: Assets.images.bgPhotoHome.image(
              width: double.maxFinite,
              fit: BoxFit.fitWidth,
            ),
          ),

          // Gradient text with optimization
          Positioned(
            top: 8.h,
            left: 12.w,
            width: 105.w,
            height: 30.h,
            child: MarqueeWidget(
              padding: 0,
              maxWidth: 105.w,
              widgetWidth: sizeText.width,
              height: sizeText.height,
              child: CustomPaint(
                painter: GradientTextStrokePainter(
                  text: S.of(context).photo,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark100,
                    fontFamily: FontFamily.manrope,
                  ),
                  colors: const [Color(0xFF7AFBB4), Color(0xFFFFFFFF)],
                  isHasShadow: false,
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
                ),
                child: Opacity(
                  opacity: 0,
                  child: Text(
                    S.of(context).photo,
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
          // Photo icon - cached
          Positioned(
            left: 16.w,
            bottom: 2.h,
            child: RepaintBoundary(
              child: Assets.images.photoHomeComponent.image(
                width: 120.w,
                height: 70.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
