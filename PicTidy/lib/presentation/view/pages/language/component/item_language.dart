import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../domain/enums/language.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../widgets/app_touchable.dart';
import '../language_bloc.dart';

class ItemLanguage extends StatelessWidget {
  const ItemLanguage({
    super.key,
    required this.language,
    this.isSelected = false,
  });

  final Language language;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      timeDebounce: 0,
      onPressed: () => context.read<LanguageBloc>().add(
        LanguageEvent.changeLanguage(language),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 6.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.blueCFB : null,
        border: isSelected
            ? Border.all(color: AppColors.blue7DC, width: 1.5)
            : Border.all(color: AppColors.light300, width: 1.5),
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white7D8, width: 0.5),
            ),
            child: language.image.image(
              width: 32.w,
              height: 32.h,
              fit: BoxFit.contain,
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 1.h,
              children: [
                Text(
                  language.nameEnglish,
                  style: GoogleFonts.hindMadurai(
                    color: AppColors.black21,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    height: 18 / 16,
                  ),
                ),
                Text(
                  language.name,
                  style: GoogleFonts.hindMadurai(
                    color: AppColors.black82,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 18 / 16,
                  ),
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          IgnorePointer(
            child: Radio(
              value: true,
              groupValue: isSelected,
              onChanged: (value) {},
              splashRadius: 0,
              activeColor: AppColors.mint400,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.mint400;
                }
                return AppColors.dark500;
              }),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
