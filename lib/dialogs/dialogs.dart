// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains dialogs.

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';
import 'package:my_widgets/dialogs/dialog_for_page.dart';
import 'package:my_widgets/dialogs/overlay_loading.dart';

class Dialogs {
  static Future showNativeDialog({
    BuildContext? context,
    String title = 'Info',
    Material? body,
    String message = 'Action cannot be undo.',
    String okBtn = 'OK',
    String? cancelBtn,
    Color? okButtonTextColor,
    Color? cancelButtonTextColor,
    TextStyle? okButtonTextStyle,
    TextStyle? cancelButtonTextStyle,
    Widget? okButton,
    Widget? cancelButton,
    List<Widget>? buttonList,
    bool isDismissible = true,
  }) async {
    return showPlatformDialog(
      context: context ?? Get.context!,
      androidBarrierDismissible: isDismissible,
      useRootNavigator: true,
      builder: (context) => PopScope(
        canPop: isDismissible,
        child: BasicDialogAlert(
          title: Text(title),
          content: body ?? Text(message),
          actions: buttonList ??
              <Widget>[
                okButton ??
                    BasicDialogAction(
                      title: Text(
                        okBtn,
                        style: okButtonTextStyle ??
                            TextStyle(color: okButtonTextColor),
                      ),
                      onPressed: () =>
                          Get.back(result: cancelBtn == null ? false : true),
                    ),
                if (cancelBtn != null || cancelButton != null)
                  cancelButton ??
                      BasicDialogAction(
                        title: Text(
                          cancelBtn ?? '',
                          style: cancelButtonTextStyle ??
                              TextStyle(color: cancelButtonTextColor),
                        ),
                        onPressed: () => Get.back(result: false),
                      ),
              ],
        ),
      ),
    );
  }

  static showCustomDialog(
      {BuildContext? context,
      dismissOnTap = false,
      required Widget body,
      Widget? closeBtn,
      Duration? animationTime}) async {
    return showDialog(
      barrierDismissible: dismissOnTap,
      context: context ?? Get.context!,
      builder: (BuildContext context) {
        return ShowCustomDialog(
          body,
          closeBtn: closeBtn,
          animationTime: animationTime ?? 200.milliseconds,
        );
      },
    );
  }

  static showOverlayLoadingDialog(
      {BuildContext? context,
      dismissOnTap = false,
      Duration? animationTime}) async {
    return showDialog(
      barrierDismissible: dismissOnTap,
      context: context ?? Get.context!,
      builder: (BuildContext context) {
        return OverlayLoadingDialog(
          animationTime: animationTime ?? 200.milliseconds,
        );
      },
    );
  }
}
