import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/widgets/txt.dart';

/// Flutter code sample for [Overlay].

class ShowSnackBar {
  static OverlayEntry? overlayEntry;

  static Future<void> createHighlightOverlay({
    String? text,
    BuildContext? context,
    Color? bgColor,
    Color? borderColor,
    Color? textColor,
    bool hasCloseIcon = true,
    Widget? closeIcon,
    Duration? duration,
    double? radius,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Alignment? alignment,
    Function()? onClosedTap,
    bool autoClose = true,
    Widget? body,
  }) async {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    duration ??= 5.seconds;

    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        // Align is used to position the highlight overlay
        // relative to the NavigationBar destination.
        return SafeArea(
          child: Align(
            alignment: alignment ?? Alignment.topRight,
            heightFactor: 1.0,
            child: body ??
                Container(
                  decoration: pBoxDecoration(
                    color: bgColor ?? Colors.blueAccent,
                    radius: radius ?? 6,
                    borderColor: borderColor,
                    hasBorder: borderColor != null,
                  ),
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: margin ?? const EdgeInsets.all(30),
                  constraints: BoxConstraints(
                      minWidth: Get.width * 0.4,
                      maxHeight: Get.width * 0.8,
                      minHeight: 0.0,
                      maxWidth: Get.height * 0.8),
                  height: height == null ? null : (height + 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Txt(
                        text,
                        textColor: textColor,
                      )),
                      if (hasCloseIcon)
                        IconButton(
                          onPressed: onClosedTap ??
                              () {
                                removeHighlightOverlay();
                              },
                          icon: const Icon(Icons.close),
                          visualDensity: VisualDensity.compact,
                        )
                    ],
                  ),
                ),
          ),
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context ?? Get.context!).insert(overlayEntry!);
    if (autoClose) {
      await Future.delayed(duration);
      removeHighlightOverlay();
    }
  }

  // Remove the OverlayEntry.
  static void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }
}
