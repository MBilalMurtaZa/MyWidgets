import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/dividers.dart';

import '../utils/utils.dart';


class Btn extends StatelessWidget {

  final String? text;
  final VoidCallback? onPressed;
  final Color? textColor, bgColor, shadowColor, onSurface, borderColor;
  final bool hasBorder, isLoose;
  final double? radius, textSize, verticalPadding, elevation, borderWidth, width,height;
  final Widget? preFix;
  final Widget? postFix;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize, maximumSize, fixedSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MainAxisAlignment mainAxisAlignment;


  const Btn(
      {
        Key? key,
        required this.text,
        this.onPressed,
        this.textColor,
        this.bgColor,
        this.borderColor = Clr.colorPrimary,
        this.hasBorder = true,
        this.isLoose = false,
        this.radius = Siz.defaultRadius,
        this.textSize,
        this.preFix,
        this.postFix,
        this.textStyle,
        this.verticalPadding = 4,
        this.borderWidth = 1,
        this.style, this.shadowColor, this.onSurface, this.elevation, this.padding, this.minimumSize, this.maximumSize, this.fixedSize, this.side, this.shape,
        this.mainAxisAlignment = MainAxisAlignment.center,
        this.width,
        this.height
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: buildButton(),
    );
  }

  Widget buildButton() {

    if(preFix != null && postFix == null){
      return button(
        Row(
          mainAxisSize: isLoose?MainAxisSize.max: MainAxisSize.min,
          children: [
            preFix!,
            MyVerticalDivider(width: verticalPadding!),
            Text(text!, style: textStyle??textStyleLocal()),
          ],
        ),
      );
    }else if(preFix != null && postFix != null){
      return button(
        Row(
          mainAxisSize: isLoose?MainAxisSize.max: MainAxisSize.min,
          children: [
            preFix!,
            MyVerticalDivider(width: verticalPadding!),
            Text(text!, style: textStyle??textStyleLocal()),
            MyVerticalDivider(width: verticalPadding!),
            postFix!,
          ],
        ),
      );
    }else if(postFix != null && preFix == null){
      return button(
        Row(
          mainAxisSize: isLoose?MainAxisSize.max: MainAxisSize.min,
          children: [
            Text(text!, style: textStyle??textStyleLocal()),
            MyVerticalDivider(width: verticalPadding!),
            postFix!,
          ],
        ),
      );
    }else{
      return button(Row(
        mainAxisSize: isLoose?MainAxisSize.max: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(text!, style: textStyle??textStyleLocal()),
        ],
      ));
    }


  }

  Widget button(Widget child){
    return ElevatedButton(
      style: style??ElevatedButton.styleFrom(
        primary: bgColor,
        onPrimary: textColor,
        onSurface: onSurface,
        elevation: elevation,
        shadowColor: shadowColor,
        shape: shape??RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!),
        ),
        side: side??(hasBorder?BorderSide(
          color: borderColor!,
          width: borderWidth!
        ):null)

      ),
      onPressed: onPressed,
      child: child,
    );
  }

  textStyleLocal(){
    TextStyle(
      color: textColor,
      fontSize: textSize,
    );
  }
}
