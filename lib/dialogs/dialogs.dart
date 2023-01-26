import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';

class Dialogs {
  static Future showNativeDialog({
    BuildContext? context,
    String title = 'Info',
    Widget? body,
    String message = 'Action cannot be undo.',
    String okBtn = 'OK',
    String? cancelBtn,
  }) async {
    return showPlatformDialog(
      context: context ?? Get.context!,
      androidBarrierDismissible: true,
      builder: (context) => BasicDialogAlert(
        title: Text(title),
        content: body ?? Text(message),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(okBtn),
            onPressed: () => Get.back(result: cancelBtn == null ? false : true),
          ),
          if (cancelBtn != null)
            BasicDialogAction(
              title: Text(cancelBtn),
              onPressed: () => Get.back(result: false),
            ),
        ],
      ),
    );
  }
}
