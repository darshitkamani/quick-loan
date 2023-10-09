import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';

enum FWT {
  bold,
  semiBold,
  medium,
  regular,
  light,
}

class FontUtils {
  static FontWeight getFontWeight(FWT fwt) {
    switch (fwt) {
      case FWT.light:
        return FontWeight.w200;
      case FWT.regular:
        return FontWeight.w400;
      case FWT.medium:
        return FontWeight.w500;
      case FWT.semiBold:
        return FontWeight.w600;
      case FWT.bold:
        return FontWeight.w700;
    }
  }

  static TextStyle h6({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 6,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h8({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 8,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h10({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 10,
      fontFamily: 'Barlow',
    );
  }
  static TextStyle h11({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 11,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h12({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 12,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h14({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
    double letterSpacing = 1.0,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 14,
      fontFamily: 'Barlow',
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h16({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
    double letterSpacing = 1.0,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 16,
      fontFamily: 'Barlow',
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h18({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 18,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h20({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 20,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h22({
    required Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 22,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h24({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 24,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h26({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 26,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h28({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 28,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h34({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 34,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h40({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 40,
      fontFamily: 'Barlow',
    );
  }

  static TextStyle h48({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? ColorUtils.themeColor.oxff000000,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 48,
      fontFamily: 'Barlow',
    );
  }
}
