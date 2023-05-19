library my_widgets;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_widgets/services/http_calls.dart';
import 'package:my_widgets/utils/dates.dart';
import 'package:my_widgets/widgets/get_images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/utils.dart';

enum RouteType { push, pushReplace, pushRemoveUntil, pushReplaceAll }

enum URLType { call, sms, web, email }

var pTimeout = 20;

class MyWidgets {}

BoxDecoration pBoxDecoration({
  Color? color,
  BorderRadius? borderRadius,
  double? radius,
  double borderWidth = 1,
  String? image,
  bool isAsset = true,
  BoxFit? fit,
  DecorationImage? decorationImage,
  BoxBorder? border,
  bool hasBorder = false,
  Color? borderColor,
  List<BoxShadow>? boxShadow,
  Color shadowColor = Clr.colorWhite,
  double shadowRadius = 0,
  Offset shadowOffset = const Offset(0.0, 0.0),
  Gradient? gradient,
  BorderStyle borderStyle = BorderStyle.solid,
  BoxShape shape = BoxShape.rectangle,
}) {
  return BoxDecoration(
      borderRadius: borderRadius ??
          BorderRadius.all(Radius.circular(radius ?? Siz.defaultRadius)),
      border: border ??
          (hasBorder
              ? Border.all(
                  color: borderColor ?? Clr.colorTransparent,
                  width: borderWidth,
                  style: borderStyle)
              : null),
      color: color,
      shape: shape,
      image: decorationImage ??
          (image != null
              ? isAsset
                  ? DecorationImage(
                      image: AssetImage(image),
                      fit: fit,
                    )
                  : DecorationImage(
                      image: NetworkImage(
                        image,
                      ),
                      fit: fit,
                    )
              : null),
      boxShadow: boxShadow ??
          [
            BoxShadow(
                color: shadowColor,
                blurRadius: shadowRadius,
                offset: shadowOffset),
          ],
      gradient: gradient);
}

pShowToast(
    {required String message,
    Color colorText = Colors.white,
    Color? backgroundColor,
    bool isError = false,
    ToastGravity? toastGravity,
    Toast toastLength = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: toastGravity ?? ToastGravity.TOP,
    backgroundColor: backgroundColor ?? Clr.colorPrimary,
    textColor: colorText,
    fontSize: 16.0,
  );
}

pFocusOut({BuildContext? context, bool isHide = true, FocusNode? focusNode}) {
  FocusScope.of(context ?? Get.context!).requestFocus(focusNode ?? FocusNode());
  if (isHide) {
    return;
  }

  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Widget pSetCard(
    {Widget? child,
    Color? shadowColor,
    double elevation = 10,
    GestureTapCallback? onTap,
    EdgeInsetsGeometry? padding,
    double paddingSize = 0,
    double? radius}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding ??
          EdgeInsets.only(
              left: paddingSize, right: paddingSize, top: paddingSize),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? Siz.defaultRadius),
        ),
        elevation: elevation,
        shadowColor: shadowColor ?? Clr.colorPrimary,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    ),
  );
}

Future<dynamic> pSetRout(
    {required dynamic page,
    RouteType routeType = RouteType.push,
    bool fullscreenDialog = false,
    BuildContext? context,
    Duration? duration,
    Curve? curve,
    Transition? transition}) async {
  pFocusOut();
  switch (routeType) {
    case RouteType.push:
      // return Navigator.push(context, MaterialPageRoute(builder: (context)=> page, fullscreenDialog: fullscreenDialog));
      return Get.to(
        page,
        fullscreenDialog: fullscreenDialog,
        duration: duration,
        curve: curve,
        transition: transition,
      );
    case RouteType.pushReplace:
      return Get.off(page, fullscreenDialog: fullscreenDialog);
    case RouteType.pushReplaceAll:
      return Get.offAll(page, fullscreenDialog: fullscreenDialog);
    // return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page, fullscreenDialog: fullscreenDialog));
    case RouteType.pushRemoveUntil:
      return Navigator.pushAndRemoveUntil(context ?? Get.context!,
          MaterialPageRoute(builder: (context) => page), (route) => false);
    // return Get.offUntil(MaterialPageRoute(builder: (context)=> page), (route) => false);
  }
}

Widget pDropDownButton(
    String labelHint,
    String hintText,
    List<DropdownMenuItem<int>> listDropDown,
    int? selectedValue,
    Function(int? val) onChange,
    {bool isExpanded = true,
    double paddingHorizontal = 0.0,
    bool enabled = true,
    FocusNode? focusNode,
    bool hasBorder = false}) {
  return IgnorePointer(
    ignoring: !enabled,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      margin: const EdgeInsets.only(bottom: 5),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: labelHint,
          border: hasBorder ? const OutlineInputBorder() : null,
        ),
        focusNode: focusNode,
        isExpanded: true,
        value: selectedValue,
        items: listDropDown,
        onChanged: onChange,
      ),
    ),
  );
}

Future<void> pLaunchURL(String action,
    {URLType urlType = URLType.web,
    LaunchMode? mode,
    String? webOnlyWindowName,
    WebViewConfiguration? webViewConfiguration,
    String? emailBody}) async {
  if (action == Str.na) {
    pShowToast(message: "Invalid Content");
  } else {
    String url = '';
    String error = '';
    switch (urlType) {
      case URLType.call:
        url = 'tel:$action';
        error = 'Could not dial $action';
        break;
      case URLType.sms:
        url = 'sms:$action';
        error = 'Could not sms on $action';
        break;
      case URLType.web:
        url = action;
        error = 'Could not open $action';
        break;
      case URLType.email:
        final Uri params = Uri(
          scheme: 'mailto',
          path: action,
          query: emailBody ?? '', //add subject and body here
        );
        url = params.toString();
        error = 'Could not send an email on $action';
        break;
    }

    debugPrint(url);
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: mode ?? LaunchMode.platformDefault,
          webOnlyWindowName: webOnlyWindowName,
          webViewConfiguration:
              webViewConfiguration ?? const WebViewConfiguration());
    } else {
      pShowToast(message: error);
    }
  }
}

pSnackBar(
    {String title = 'Info',
    required String? message,
    Color colorText = Clr.colorWhite,
    Color? backgroundColor,
    bool isError = false,
    SnackPosition snackPosition = SnackPosition.TOP}) {
  Get.snackbar(isError ? 'Error' : title, message ?? '',
      colorText: isError ? Colors.white : colorText,
      backgroundColor:
          isError ? Colors.red : backgroundColor ?? Clr.colorPrimary,
      borderColor: Colors.white,
      snackPosition: snackPosition,
      borderWidth: 2.0);
}

Future<void> pSetSettings(
    {
      required Color primaryColor,
      required Color secondaryColor,
      String baseUrlLive = '',
      String baseUrlTest = '',
      bool useDefaultURl = true,
      bool isLive = true,
      String defaultImage = 'assets/default.png',
      bool defImageIsAsset = true,
      httpCallsDefaultResponse = true,
      double defaultFontSize = 14.0,
      double defaultRadius = 8.0,
      double defaultBtnHeight = 50,
      bool? txtInputHasBorder,
      bool txtInputHasLabel = false,
      bool txtInputHasLabelOnTop = false,
      bool txtInputHasLabelWithStar = true,
      bool defaultImageClick = true,
      EdgeInsetsGeometry? txtInoutDefaultContentPadding,
      bool httpCallsWithStream = false,
      bool httpResponseUtf8Convert = false,
      String? internetIssueMessage,
      localization,
      FontWeight? fontWeight,
      TextStyle? txtStyle,
      TextStyle? labelInputStyle,
      TextStyle? hintInputStyle,
      TextStyle? styleInput,
      TextStyle? prefixInputStyle,
      Color? txtColor,
      Color? txtInputColor,
      String? currencySymbol,
      String? currencyLocale,
      int? currencyDecimal,
      bool isCurrencyCompact = false,
      InputDecoration? inputDecoration,
      Map<String, String>? httpHeader,
      Map<String, String>? httpHeaderAddOns,
      InputBorder? txtInputEnabledBorder,
      InputBorder? txtInputFocusedBorder,
      InputBorder? txtInputErrorBorder,
      InputBorder? txtInputBorder,
      Color? txtInputBorderColor,
      double? txtInputLabelPadding,
      double? btnHeight,
      double? btnRadius,
      Color? btnBgColor,
      Color? btnBorderColor,
      bool? appDirectionLeftToRight,
      String? fontFamily,
    }
) async {
  await Dates.initializeDateFormat();
  Clr.colorPrimary = primaryColor;
  Clr.colorSecondary = secondaryColor;
  HttpCalls.live = baseUrlLive;
  HttpCalls.testing = baseUrlTest;
  HttpCalls.isLive = isLive;
  GetImage.defaultImage = defaultImage;
  GetImage.defImageIsAsset = defImageIsAsset;
  HttpCalls.httpCallsDefaultResponse = httpCallsDefaultResponse;
  Siz.defaultRadius = defaultRadius;
  Siz.defaultBtnHeight = defaultBtnHeight;
  HttpCalls.httpCallsWithStream = httpCallsWithStream;
  HttpCalls.httpResponseUtf8Convert = httpResponseUtf8Convert;
  if (internetIssueMessage != null) {
    HttpCalls.internetIssue = internetIssueMessage;
  }
  Static.txtInputHasBorder = txtInputHasBorder;
  Static.txtInputHasLabel = txtInputHasLabel;
  Static.txtInputHasLabelOnTop = txtInputHasLabelOnTop;
  Static.txtInputHasLabelWithStar = txtInputHasLabelWithStar;
  Static.txtInoutDefaultContentPadding = txtInoutDefaultContentPadding;
  Static.fontWeight = fontWeight;
  Static.defaultImageClick = defaultImageClick;
  Static.defaultFontSize = defaultFontSize;
  HttpCalls.localization = localization;
  HttpCalls.httpHeader = httpHeader;
  HttpCalls.headerAddOns = httpHeaderAddOns;
  Clr.colorTxt = txtColor ?? Clr.colorBlack;
  Clr.colorTxtInput = txtInputColor ?? Clr.colorBlack;
  Style.textStyle = txtStyle;
  Style.labelInputStyle = labelInputStyle;
  Style.hintInputStyle = hintInputStyle;
  Style.styleInput = styleInput;
  Style.prefixInputStyle = prefixInputStyle;
  Static.currencyLocale = currencyLocale;
  Static.currencySymbol = currencySymbol;
  Static.isCurrencyCompact = isCurrencyCompact;
  Static.inputDecoration = inputDecoration;
  Static.enabledBorder = txtInputEnabledBorder;
  Static.focusedBorder = txtInputFocusedBorder;
  Static.errorBorder = txtInputErrorBorder;
  Static.border = txtInputBorder;
  Static.borderColor = txtInputBorderColor;
  Static.labelPadding = txtInputLabelPadding;
  Static.btnHeight = btnHeight;
  Static.btnRadius = btnRadius;
  Static.btnBgColor = btnBgColor;
  Static.btnBgColor = btnBorderColor;
  Static.appDirectionLeftToRight = appDirectionLeftToRight;
  HttpCalls.useDefaultURl = useDefaultURl;
  Static.fontFamily = fontFamily;



}

String pRemoveHtmlIfNeeded(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
}

pCurrencyFormat(dynamic value,
    {String? locale,
    String? symbol,
    int? decimalDigits,
    bool? isCurrencyCompact}) {
  try {
    if (value == null || value == '') {
      value = 0;
    }
    double price = double.parse((value).toString());
    if (isCurrencyCompact ?? Static.isCurrencyCompact) {
      return NumberFormat.compactCurrency(
              locale: locale ?? Static.currencyLocale,
              symbol: symbol ?? Static.currencySymbol,
              decimalDigits: decimalDigits ?? Static.currencyDecimal)
          .format(price);
    } else {
      return NumberFormat.currency(
              locale: locale ?? Static.currencyLocale,
              symbol: symbol ?? Static.currencySymbol,
              decimalDigits: decimalDigits ?? Static.currencyDecimal)
          .format(price);
    }
  } catch (e) {
    // Dialogs.showNativeDialog(title: 'Alert', message: 'You Enter Wrong Prices');
    pShowToast(message: 'You Enter Invalid Amount');
    value = 0;
  }
}
