import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
}

class BorderRadiusStyle {
  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(10.h);

  static BorderRadius get roundedBorder144 => BorderRadius.circular(144.h);

  static BorderRadius get roundedBorder72 => BorderRadius.circular(72.h);
}
