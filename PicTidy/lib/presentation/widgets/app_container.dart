import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../shared/extension/context.dart';
import '../resources/colors.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.appBar,
    this.onPopInvoked,
    this.bottomNavigationBar,
    this.child,
    this.backgroundColor,
    this.coverScreenWidget,
    this.resizeToAvoidBottomInset = false,
    this.canPop = false,
    this.floatingActionButton,
    this.isUseBackgroundImage = false,
    this.backgroundImage,
    this.backgroundGradientColor,
    this.backgroundImageFit,
  });

  final PreferredSizeWidget? appBar;
  final bool canPop;
  final Function(bool)? onPopInvoked;
  final Widget? bottomNavigationBar;
  final Widget? child;
  final Color? backgroundColor;
  final Gradient? backgroundGradientColor;
  final Widget? coverScreenWidget;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final bool isUseBackgroundImage;
  final AssetGenImage? backgroundImage;
  final BoxFit? backgroundImageFit;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: onPopInvoked,
      child: Stack(
        children: [
          if (backgroundGradientColor != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(gradient: backgroundGradientColor),
              ),
            ),
          if (isUseBackgroundImage && backgroundImage != null)
            backgroundImage!.image(
              width: double.infinity,
              height: double.infinity,
              fit: backgroundImageFit ?? BoxFit.cover,
            ),

          Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor:
                isUseBackgroundImage || backgroundGradientColor != null
                ? AppColors.transparent
                : (backgroundColor ?? context.theme().scaffoldBackgroundColor),
            appBar: appBar,
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: child ?? const SizedBox.shrink(),
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
          coverScreenWidget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
