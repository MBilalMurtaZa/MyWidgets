import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Clr {
  static Color colorPrimary = Colors.black;
  static Color colorSecondary = Colors.black;
  static const Color colorCyan = Colors.cyan;
  static const Color colorTransparent = Color(0x00000000);
  static const Color colorGreyLight = Color(0xFFF1F5F9);
  static const Color colorWhite = Colors.white;
  static const Color colorGreen = Colors.green;
  static const Color colorBlack = Colors.black;
  static Color colorTxt = Colors.black;
  static Color colorTxtInput = Colors.black;

  Clr._();
}

class Style {
  Style._();
  static TextStyle? textStyle;
  static TextStyle? labelInputStyle,
      hintInputStyle,
      styleInput,
      prefixInputStyle;
}

class Siz {
  Siz._();

  static const double extraLargeTitle100 = 100.0;
  static const double largeTitle34 = 34.0;
  static const double title28 = 28.0;
  static const double title22 = 22.0;
  static const double title20 = 20.0;
  static const double headline17 = 17.0;
  static const double body17 = 17;
  static const double callOut16 = 16;
  static const double subhead15 = 15;
  static const double footnote13 = 13;
  static const double caption12 = 12;
  static const double caption11 = 11;
  static const double caption8 = 8;

  static const double h0 = 100.0;
  static const double h1 = 40.0;
  static const double h2 = 25.0;
  static const double h3 = 20.0;
  static const double h4 = 17.0;
  static const double h5 = 14.0;
  static const double h6 = 12.0;
  static const double h7 = 10.0;
  static const double h8 = 8.0;
  static double defaultRadius = 8.0;
  static double defaultBtnHeight = 50;
  static const double standardPadding = 16.0;
  static const double standardMargin = 16.0;
  static const double profileImageSize = 150;
}

class Str {
  static String error = 'Error';
  static String success = 'Success';
  static String noDataFound = 'There is no data to show';
  static const String na = "N/A";

  Str._();
}

class EndPoints {
  static String products = 'products';
  EndPoints._();
}

class Static {
  static bool? txtInputHasBorder;
  static bool txtInputHasLabel = false;
  static bool txtInputHasLabelOnTop = false;
  static bool txtInputHasLabelWithStar = true;
  static bool defaultImageClick = true;
  static EdgeInsetsGeometry? txtInoutDefaultContentPadding;
  static FontWeight? fontWeight;
  static double? defaultFontSize;
  static String? currencySymbol;
  static String? fontFamily;
  static String? currencyLocale;
  static bool isCurrencyCompact = false;
  static int? currencyDecimal;
  static InputDecoration? inputDecoration;
  static InputBorder? enabledBorder;
  static InputBorder? focusedBorder;
  static InputBorder? errorBorder;
  static InputBorder? border;
  static Color? borderColor;
  static double? labelPadding;
  static Widget? txtInputPostFixErrorIcon;
  static TextStyle? txtInputErrorStyle;
  static double? txtInputHeight;
  static double? btnHeight;
  static FontWeight? btnFontWeight;
  static Widget? customBtnLoader;
  static double? btnRadius;
  static Color? btnBgColor;
  static Color? btnTextColor;
  static Color? btnBorderColor;
  static bool? appDirectionLeftToRight;
  static bool? defaultLoadingProIsIOS;
  static bool? useDefaultURl;
  static int stopDecodingFromErrorCode = 400;
  static Toast toastLength = Toast.LENGTH_SHORT;
  static Matrix4? onHoverDefaultMatrix4;
  static double? onHoverDefaultScale;
  static Duration? onHoverDefaultAnimatedDuration;
  static Color? webDialogBgColor;
  static Duration? dialogAnimationDuration;
  static String? defaultDateFormat;
  static String? defaultDateTimeFormat;
  static EdgeInsets? webDialogPadding;
  static EdgeInsets? webDialogMargin;

  static bool isHintCapitalizeFirst = false;

  static bool? usePreCheckFunctionInHttpCalls;

  Static._();
}
