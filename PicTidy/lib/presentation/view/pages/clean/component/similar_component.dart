import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_gradiate/text_gradiate.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../resources/colors.dart';
import '../../../../widgets/app_touchable.dart';
import '../clean_bloc.dart';
import '../painter/gradient_text_painter.dart';
import '../painter/video_background_painter.dart';

class SimilarComponent extends StatelessWidget {
  const SimilarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPressed: () =>
          context.read<CleanBloc>().add(const CleanEvent.onPressSimilar()),
      rippleColor: AppColors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: VideoBackgroundPainter(),
            size: Size(328.w, 124.h),
          ),
          Positioned(
            top: 28.h,
            child: TextGradiate(
              text: Text(
                S.of(context).duplicate.toUpperCase(),
                style: GoogleFonts.zenTokyoZoo(
                  fontSize: 42.sp,
                  letterSpacing: 1.26,
                  height: 50 / 42,
                ),
              ),
              colors: [
                AppColors.white.withValues(alpha: 0.8),
                AppColors.white.withValues(alpha: 0.45),
                AppColors.white.withValues(alpha: 0.4),
              ],
              stops: const [-0.01, 0.67, 1],
            ),
          ),
          Positioned(
            right: 12.w,
            bottom: 8.5.h,
            child: Assets.images.videoHomeComponent.image(
              width: 170.w,
              height: 81.h,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 24.w,
            child: CustomPaint(
              painter: GradientTextStrokePainter(
                text: S.of(context).similar,
                textStyle: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark100,
                  fontFamily: FontFamily.manrope,
                ),
                colors: [const Color(0xFFFFFFFF), const Color(0xFF7AFBB4)],
              ),
              child: Opacity(
                opacity: 0,
                child: Text(
                  S.of(context).similar,
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
        ],
      ),
    );
  }
}
