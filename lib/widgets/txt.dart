// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains txt.

import 'package:flutter/material.dart';
import 'package:my_widgets/my_widgets.dart';

import '../utils/utils.dart';

class Txt extends StatelessWidget {
  final String? text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final bool hasBold,
      hasItalic,
      hasUnderLine,
      hasLineThrough,
      checkOverFlow,
      removeHTML;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? fontSize, lineHeight;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextAlign textAlign;
  final TextDecoration? textDecoration;
  final Function()? onTap;

  const Txt(
    this.text, {
    this.hasBold = false,
    this.hasItalic = false,
    this.hasUnderLine = false,
    this.hasLineThrough = false,
    this.textColor,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.checkOverFlow = false,
    this.maxLine,
    this.textAlign = TextAlign.start,
    this.fontFamily,
    this.textDecoration,
    this.removeHTML = false,
    this.onTap,
    this.lineHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        removeHTML ? pRemoveHtmlIfNeeded(text ?? '') : text ?? '',
        style: textStyle ??
            Style.textStyle ??
            TextStyle(
              fontWeight: hasBold
                  ? fontWeight ?? Static.fontWeight ?? FontWeight.bold
                  : FontWeight.normal,
              fontStyle: hasItalic ? FontStyle.italic : FontStyle.normal,
              decoration: textDecoration ??
                  (hasUnderLine
                      ? TextDecoration.underline
                      : hasLineThrough
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
              color: textColor ?? Clr.colorTxt,
              fontSize: fontSize ?? Static.defaultFontSize,
              overflow: overflow ??
                  (checkOverFlow
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible),
              fontFamily: fontFamily,
              height: lineHeight,
            ),
        maxLines: maxLine,
        textAlign: textAlign,
      ),
    );
  }
}
