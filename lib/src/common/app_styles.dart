import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';
import 'sizes.dart';

class AppStyle {
  final ButtonStyle buttonStyle;
  final TextStyle textStyle;
  final BoxDecoration decorator;
  static final BorderRadius borderRadius =
      BorderRadius.circular(Sizes.borderRadius);
  static final BoxDecoration defaultBoxDecoration = BoxDecoration(
    borderRadius: borderRadius,
  );
  static const defaultTextStyle = TextStyle(
    inherit: true,
    fontWeight: FontWeight.bold,
    letterSpacing: Sizes.fontSpacingButton,
    fontSize: Sizes.fontSizeMedium,
  );

  AppStyle._internal(this.buttonStyle, this.textStyle, this.decorator);

  factory AppStyle.primary(BuildContext context) {
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.any((state) => state == MaterialState.disabled)) {
            return ColorName.darkGreenBtn;
          } else if (states.any((state) => state == MaterialState.selected)) {
            return ColorName.primaryTest;
          } else {
            return Colors.transparent;
          }
        }),
        maximumSize: MaterialStateProperty.all(
            const Size.fromWidth(Sizes.maxButtonSize)),
        overlayColor: MaterialStateProperty.all(ColorName.primaryTest),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: borderRadius)),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.any((state) => state == MaterialState.disabled)) {
            return Colors.black.withOpacity(0.6);
          }
          return ColorName.darkGrey;
        }));

    final decorator = defaultBoxDecoration.copyWith(
      gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            ColorName.primaryGreenBtnBottom,
            ColorName.primaryGreenBtnTop
          ]),
    );

    return AppStyle._internal(buttonStyle, defaultTextStyle, decorator);
  }

  factory AppStyle.secondary(BuildContext context) {
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.any((state) => state == MaterialState.disabled)) {
            return ColorName.secondaryGrayBtn;
          } else if (states.any((state) => state == MaterialState.selected)) {
            return ColorName.secondaryDarkIndigoGreyIntermediateBtn;
          } else if (states.any((state) => state == MaterialState.pressed)) {
            return ColorName.secondaryDarkIndigoGreyIntermediateBtn;
          } else {
            return Colors.transparent;
          }
        }),
        maximumSize: MaterialStateProperty.all(
            const Size.fromWidth(Sizes.maxButtonSize)),
        overlayColor: MaterialStateProperty.all(ColorName.strongPressedShadow),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: borderRadius)),
        foregroundColor: MaterialStateProperty.all(Colors.white));

    final decorator = defaultBoxDecoration.copyWith(
      color: ColorName.secondaryDarkIndigoBtn,
    );

    return AppStyle._internal(buttonStyle, defaultTextStyle, decorator);
  }

  factory AppStyle.tertiary(BuildContext context) {
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.any((state) => state == MaterialState.disabled)) {
            return ColorName.darkGreenBtn;
          } else if (states.any((state) => state == MaterialState.pressed)) {
            return ColorName.tertiaryDarkGrayBtn;
          } else {
            return Colors.black;
          }
        }),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))));

    final decorator = BoxDecoration(
      borderRadius: BorderRadius.circular(27),
      color: ColorName.tertiaryLightGrayBtn,
    );

    return AppStyle._internal(buttonStyle, defaultTextStyle, decorator);
  }

  factory AppStyle.outline(BuildContext context) {
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.any((state) => state == MaterialState.disabled)) {
            return ColorName.darkGreenBtn;
          } else if (states.any((state) => state == MaterialState.pressed)) {
            return const Color.fromARGB(20, 51, 51, 51);
          } else {
            return const Color.fromARGB(0, 0, 0, 0);
          }
        }),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))));

    final decorator = BoxDecoration(
      borderRadius: borderRadius,
      border: Border.all(color: ColorName.darkGrey),
      color: Colors.transparent,
    );

    return AppStyle._internal(buttonStyle, defaultTextStyle, decorator);
  }
}

extension WithStyle on ButtonStyleButton {
  Widget withDecorator(
          {required BoxDecoration decoration,
          double someHeight = Sizes.buttonSize}) =>
      Container(decoration: decoration, height: someHeight, child: this);

  static Widget build(AppStyle appStyle,
          Widget Function(AppStyle style) builderWithStyle) =>
      builderWithStyle(appStyle);
}
