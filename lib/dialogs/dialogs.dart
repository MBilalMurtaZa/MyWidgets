import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';
import 'package:my_widgets/dialogs/dialog_for_page.dart';

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
  }) async {
    return showPlatformDialog(
      context: context ?? Get.context!,
      androidBarrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => BasicDialogAlert(
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
}
