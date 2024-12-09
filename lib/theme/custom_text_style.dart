import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get sourceSansPro {
    return copyWith(fontFamily: 'Source Sans Pro');
  }

  TextStyle get roboto {
    return copyWith(fontFamily: 'Roboto');
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );

  static TextStyle get bodyLargeBlack90018 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 18,
      );

  static TextStyle get bodyLargeGray600 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray600,
      );

  static TextStyle get bodySmallGray400 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray400,
      );

  // Title text style
  static TextStyle get titleLargeRobotoGray800 => theme.textTheme.titleLarge!.roboto.copyWith(
        color: appTheme.gray800,
        fontSize: 23,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleSmallCyan900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.cyan900,
      );

  static TextStyle get titleSmallWhiteA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );
}
