import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_gradiate/text_gradiate.dart';

import '../../../../../domain/entities/photo.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../shared/extension/number.dart';
import '../../../../../shared/utils/app_utils.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/styles.dart';
import '../../../../widgets/app_animation_skeleton.dart';
import '../../../../widgets/marquee_text.dart';
import '../../home/home_bloc.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  Widget _buildItem({
    required String title,
    required int valueInKB,
    required double maxWidth,
  }) {
    return Container(
      constraints: BoxConstraints(minWidth: 55.w, maxWidth: maxWidth),
      child: Column(
        spacing: 2.h,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            valueInKB.fromBytesToText(fractionDigit: 1),
            style: AppStyles.titleLBold14(AppColors.light100),
            textAlign: TextAlign.center,
          ),
          MarqueeText(
            title,
            textAlign: TextAlign.center,
            padding: 2.w,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
              height: 16 / 11,
              color: AppColors.light200,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6.w,
      children: [
        Expanded(
          child: TextGradiate(
            text: Text(
              'Photo Cleaner',
              style: GoogleFonts.hankenGrotesk(
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
              ),
            ),
            colors: const [
              Color(0xFF22F3F8),
              Color(0xFF29F479),
              Color(0xFF8FF594),
            ],
            stops: const [0, 0.3, 0.9],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: 160.w,
                minHeight: 60.h,
                maxWidth: 175.w,
                maxHeight: 70.h,
              ),
              child: AppAnimationSkeleton(
                atlasPath: Assets.anim.anhsangAtlas,
                skeletonPath: Assets.anim.anhsangJson,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 160.w,
                minHeight: 60.h,
                maxWidth: 175.w,
                maxHeight: 70.h,
              ),
              padding: EdgeInsets.fromLTRB(12.w, 13.h, 8.w, 13.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<int>(
                    future: AppUtils.instance.getSizeInBytesOfList(
                      context
                          .watch<HomeBloc>()
                          .state
                          .albumPhoto
                          .firstWhere(
                            (element) => element.isAll == true,
                            orElse: () => const Photo(albumName: 'Empty'),
                          )
                          .photos,
                    ),
                    builder: (context, snapshot) {
                      final isLoading =
                          snapshot.connectionState == ConnectionState.waiting;
                      final hasError = snapshot.hasError;
                      final sizeInBytes = snapshot.data ?? 0;

                      if (isLoading || hasError) {
                        return const CircularProgressIndicator();
                      }

                      return Expanded(
                        child: _buildItem(
                          title: S.of(context).useInPhoto,
                          valueInKB: sizeInBytes, // chuyển sang KB nếu cần
                          maxWidth: 65.w,
                        ),
                      );
                    },
                  ),
                  _buildItem(
                    title: S.of(context).freed,
                    valueInKB: context.watch<HomeBloc>().state.freedInByte,
                    maxWidth: 60.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
