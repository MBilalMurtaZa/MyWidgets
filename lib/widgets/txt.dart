import 'package:flutter/material.dart';
class Txt extends StatelessWidget {
  final String text;
  final bool hasBold, hasItalic, hasUnderLine, checkOverFlow;
  final Color textColor;
  final TextStyle? textStyle;
  final double? fontSize;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextAlign textAlign;
  const Txt(
      this.text,
      {this.hasBold = false,
        this.hasItalic = false,
        this.hasUnderLine = false,
        this.textColor = Colors.black,
        this.textStyle,
        this.fontSize,
        this.overflow,
        this.checkOverFlow = false,
        this.maxLine,
        this.textAlign = TextAlign.start,
      Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: textStyle??TextStyle(
        fontWeight: hasBold?FontWeight.bold:FontWeight.normal,
        fontStyle: hasItalic?FontStyle.italic:FontStyle.normal,
        decoration: hasItalic?TextDecoration.underline: TextDecoration.none,
        color: textColor,
        fontSize: fontSize,
        overflow: overflow??(checkOverFlow?TextOverflow.ellipsis:TextOverflow.visible),
      ),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }
}
