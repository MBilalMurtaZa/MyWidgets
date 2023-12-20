import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/dividers.dart';

import '../utils/utils.dart';

class Btn extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? textColor, bgColor, shadowColor, onSurface, borderColor;
  final bool hasBorder, isLoose, hasBold, isTextOnly;
  final double? radius,
      textSize,
      verticalPadding,
      elevation,
      borderWidth,
      width,
      height;
  final Widget? preFix;
  final Widget? postFix;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize, maximumSize, fixedSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MainAxisAlignment mainAxisAlignment;

  const Btn({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.bgColor,
    this.borderColor,
    this.hasBorder = true,
    this.isLoose = false,
    this.hasBold = false,
    this.isTextOnly = false,
    this.radius,
    this.textSize,
    this.preFix,
    this.postFix,
    this.textStyle,
    this.verticalPadding = 4,
    this.borderWidth = 1,
    this.style,
    this.shadowColor,
    this.onSurface,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.fixedSize,
    this.side,
    this.shape,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Static.btnHeight ?? Siz.defaultBtnHeight,
      width: width,
      child: buildButton(),
    );
  }

  Widget buildButton() {
    if (preFix != null && postFix == null) {
      return button(
        Row(
          mainAxisSize: isLoose ? MainAxisSize.max : MainAxisSize.min,
          children: [
            preFix!,
            MyVerticalDivider(width: verticalPadding!),
            Text(text!, style: textStyle ?? textStyleLocal()),
          ],
        ),
      );
    } else if (preFix != null && postFix != null) {
      return button(
        Row(
          mainAxisSize: isLoose ? MainAxisSize.max : MainAxisSize.min,
          children: [
            preFix!,
            MyVerticalDivider(width: verticalPadding!),
            Text(text!, style: textStyle ?? textStyleLocal()),
            MyVerticalDivider(width: verticalPadding!),
            postFix!,
          ],
        ),
      );
    } else if (postFix != null && preFix == null) {
      return button(
        Row(
          mainAxisSize: isLoose ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Text(text!, style: textStyle ?? textStyleLocal()),
            MyVerticalDivider(width: verticalPadding!),
            postFix!,
          ],
        ),
      );
    } else {
      return button(Row(
        mainAxisSize: isLoose ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(text!, style: textStyle ?? textStyleLocal()),
        ],
      ));
    }
  }

  Widget button(Widget child) {
    return ElevatedButton(
      style: style ??
          ElevatedButton.styleFrom(
              backgroundColor: isTextOnly
                  ? Clr.colorTransparent
                  : (bgColor ?? Static.btnBgColor),
              foregroundColor: textColor,
              disabledForegroundColor: onSurface,
              elevation: isTextOnly ? 0 : elevation,
              shadowColor: shadowColor,
              shape: shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        radius ?? Static.btnRadius ?? Siz.defaultRadius),
                  ),
              side: side ??
                  (hasBorder
                      ? BorderSide(
                          color: isTextOnly
                              ? Clr.colorTransparent
                              : borderColor ??
                                  Static.btnBorderColor ??
                                  Clr.colorPrimary,
                          width: borderWidth!)
                      : null)),
      onPressed: onPressed,
      child: child,
    );
  }

  textStyleLocal() {
    return TextStyle(
        color: isTextOnly ? (textColor ?? Clr.colorBlack) : textColor,
        fontSize: textSize,
        fontWeight: hasBold ? FontWeight.bold : FontWeight.normal);
  }
}
