import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/enums/language.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../base/base_page.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/app_container.dart';
import '../../../widgets/app_touchable.dart';
import '../../../widgets/custom_app_bar.dart';
import 'component/item_language.dart';
import 'language_bloc.dart';

@RoutePage()
class LanguagePage
    extends BasePage<LanguageBloc, LanguageEvent, LanguageState> {
  const LanguagePage({super.key, this.isFirstOpenLanguage = true})
    : super(screenName: 'language_page');

  final bool isFirstOpenLanguage;

  @override
  void onInitState(BuildContext context) {
    context.read<LanguageBloc>().isFirstOpenLanguage = isFirstOpenLanguage;
    context.read<LanguageBloc>().add(const LanguageEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      buildWhen: (previous, current) =>
          previous.currentLanguage != current.currentLanguage,
      builder: (context, state) {
        return AppContainer(
          appBar: CustomAppbar(
            titleText: S.of(context).languages,
            style: AppStyles.titleXXLSemi20(AppColors.dark100),
            centerTitle: true,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            colorBack: AppColors.dark200,
            actions: [
              if (state.currentLanguage != null)
                AppTouchable(
                  onPressed: () => context.read<LanguageBloc>().add(
                    const LanguageEvent.saveLanguage(),
                  ),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Assets.icons.check.svg(width: 24.w, height: 24.h),
                ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      8.verticalSpace,
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => ItemLanguage(
                            language: Language.values[index],
                            isSelected:
                                state.currentLanguage == Language.values[index],
                          ),
                          separatorBuilder: (context, index) =>
                              12.verticalSpace,
                          itemCount: Language.values.length,
                          padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  LanguageBloc createBloc() {
    return LanguageBloc();
  }
}
