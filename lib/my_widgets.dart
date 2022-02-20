library my_widgets;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/utils.dart';


enum RouteType { push, pushReplace, pushRemoveUntil, pushReplaceAll }
enum URLType { call, sms, web, email }

var pTimeout = 20;

BoxDecoration pBoxDecoration({Color? color, BorderRadius? borderRadius, double radius = Siz.defaultRadius, String? image, BoxFit? fit, DecorationImage? decorationImage,Border? border,bool hasBorder = false, Color? borderColor}  ) {
  return BoxDecoration(
    borderRadius: borderRadius??BorderRadius.all(Radius.circular(radius)),
    border: border??(hasBorder?Border.all(color: borderColor??Clr.colorTransparent):null),
    color: color,
    image: decorationImage??(image != null?DecorationImage(
      image: AssetImage(image),
      fit: fit,
    ):null),
  );
}

pShowToast({ required String message,Color colorText = Colors.white, Color? backgroundColor,bool isError = false,ToastGravity? toastGravity}){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: toastGravity??ToastGravity.CENTER,
    backgroundColor: backgroundColor,
    textColor: colorText,
    fontSize: 16.0,
  );
}

pFocusOut({BuildContext? context, bool isHide = true,FocusNode? focusNode }) {
  FocusScope.of(context??Get.context!).requestFocus(focusNode??FocusNode());
  if(isHide) {
    return;
  }

  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Widget pSetCard({Widget? child, Color? shadowColor, double elevation = 10, GestureTapCallback? onTap, EdgeInsetsGeometry? padding, double paddingSize = 0, double radius = Siz.defaultRadius,}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding:padding??EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: elevation,
        child: child,
        shadowColor: shadowColor??Clr.colorPrimary,
        clipBehavior: Clip.antiAlias,
      ),
    ),
  );
}

Future<bool?> pSetRout({required dynamic page,RouteType routeType = RouteType.push,bool fullscreenDialog = false, BuildContext? context}) async{
  pFocusOut();
  switch(routeType){
    case RouteType.push:
    // return Navigator.push(context, MaterialPageRoute(builder: (context)=> page, fullscreenDialog: fullscreenDialog));
      return Get.to(page, fullscreenDialog: fullscreenDialog);
    case RouteType.pushReplace:
      return Get.off(page, fullscreenDialog: fullscreenDialog);
    case RouteType.pushReplaceAll:
      return Get.offAll(page, fullscreenDialog: fullscreenDialog);
  // return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page, fullscreenDialog: fullscreenDialog));
    case RouteType.pushRemoveUntil:
      return Navigator.pushAndRemoveUntil(context??Get.context!, MaterialPageRoute(builder: (context)=> page), (route) => false);
  // return Get.offUntil(MaterialPageRoute(builder: (context)=> page), (route) => false);
  }
}

Widget pDropDownButton(String labelHint, String hintText,List<DropdownMenuItem<int>> listDropDown,int? selectedValue, Function(int? val) onChange,{bool isExpanded = true,double paddingHorizontal = 0.0, bool enabled=true, FocusNode? focusNode}) {
  return IgnorePointer(
    ignoring: !enabled,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      margin: const EdgeInsets.only(bottom: 5),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: labelHint,
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

Future<void> pLaunchURL(String action,{URLType urlType = URLType.web}) async {

  if (action == Str.NA) {
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
        url = 'mailto:$action';
        error = 'Could not send an email on $action';
        break;
    }

    debugPrint(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      pShowToast(message: error);
    }
  }
}

pSetMyColors({required Color primaryColor, required Color secondaryColor}) {
  Clr.colorPrimary = primaryColor;
  Clr.colorSecondary = secondaryColor;
}
