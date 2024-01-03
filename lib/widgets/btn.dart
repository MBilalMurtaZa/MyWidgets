import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'package:my_widgets/widgets/loading.dart';

import '../utils/utils.dart';

class Btn extends StatefulWidget {
  final String? text;
  final Function(Function(bool))? onPressed;
  final Function(bool, Function(bool))? onHover;
  final Color? textColor,
      bgColor,
      foregroundColor,
      shadowColor,
      onSurface,
      borderColor,
  loadingColor;
  final bool hasBorder, isLoose, hasBold, isTextOnly, makeInverse;
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
  final Widget? loadingWidget;

  const Btn(
      {super.key,
      required this.text,
      this.onPressed,
      this.onHover,
      this.textColor,
      this.bgColor,
      this.foregroundColor,
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
      this.makeInverse = false,
        this.loadingWidget,
        this.loadingColor
      });

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  Color? textColor;
  Color? bgColor;
  Color? loadingColor;
  Color? foregroundColor;
  bool isLoading = false;

  Function(bool, Function(bool))? onHover;

  @override
  void initState() {
    textColor = widget.textColor;
    bgColor = widget.bgColor;
    onHover = widget.onHover;
    loadingColor = widget.loadingColor??widget.textColor;
    foregroundColor = widget.foregroundColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? Static.btnHeight ?? Siz.defaultBtnHeight,
      width: widget.width,
      child: buildButton(),
    );
  }

  Widget buildButton() {
    if (widget.preFix != null && widget.postFix == null) {
      return button(
        Row(
          mainAxisSize: widget.isLoose ? MainAxisSize.max : MainAxisSize.min,
          children: [
            widget.preFix!,
            MyVerticalDivider(width: widget.verticalPadding!),
            showText(),
          ],
        ),
      );
    } else if (widget.preFix != null && widget.postFix != null) {
      return button(
        Row(
          mainAxisSize: widget.isLoose ? MainAxisSize.max : MainAxisSize.min,
          children: [
            widget.preFix!,
            MyVerticalDivider(width: widget.verticalPadding!),
            showText(),
            MyVerticalDivider(width: widget.verticalPadding!),
            widget.postFix!,
          ],
        ),
      );
    } else if (widget.postFix != null && widget.preFix == null) {
      return button(
        Row(
          mainAxisSize: widget.isLoose ? MainAxisSize.max : MainAxisSize.min,
          children: [
            showText(),
            MyVerticalDivider(width: widget.verticalPadding!),
            widget.postFix!,
          ],
        ),
      );
    } else {
      return button(Row(
        mainAxisSize: widget.isLoose ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: widget.mainAxisAlignment,
        children: [
          showText(),
        ],
      ));
    }
  }


  showText(){
    return Text(widget.text!, style: widget.textStyle ?? textStyleLocal());
  }

  Widget button(Widget child) {
    return ElevatedButton(
      style: widget.style ??
          ElevatedButton.styleFrom(
              backgroundColor: widget.isTextOnly
                  ? Clr.colorTransparent
                  : ((bgColor ?? Static.btnBgColor)),
              foregroundColor: widget.foregroundColor ?? textColor,
              disabledForegroundColor: widget.onSurface,
              elevation: widget.isTextOnly ? 0 : widget.elevation,
              shadowColor: widget.shadowColor,
              shape: widget.shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        widget.radius ?? Static.btnRadius ?? Siz.defaultRadius),
                  ),
              side: widget.side ??
                  (widget.hasBorder
                      ? BorderSide(
                          color: widget.isTextOnly
                              ? Clr.colorTransparent
                              : widget.borderColor ??
                                  Static.btnBorderColor ??
                                  Clr.colorPrimary,
                          width: widget.borderWidth!)
                      : null)),
      onPressed: widget.onPressed != null?()=> widget.onPressed!(onLoadingChange):null,
      onHover: onHover != null?(val)=> onHover!(val, onHoverLocal) : onHoverLocal,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          isLoading?(widget.loadingWidget??LoadingPro(size: 20,valueColor: loadingColor??textColor,)):Container()
        ],
      ),
    );
  }

  onHoverLocal(bool val) {
    if (widget.makeInverse) {
      setState(() {
        if (val) {
          textColor = widget.bgColor;
          bgColor = widget.textColor;
          if(isLoading){
            textColor = loadingColor;
          }
        } else {
          textColor = widget.textColor;
          bgColor = widget.bgColor;
          if(isLoading){
            textColor = loadingColor;
          }
        }

        if(loadingColor == widget.bgColor){
          loadingColor = widget.textColor;
        }else{
          loadingColor = widget.bgColor;
        }


      });
    }
  }
  onLoadingChange(bool start){
    setState(() {
      isLoading = start;
      if(start){
        textColor = widget.bgColor;
        foregroundColor = widget.bgColor;
        loadingColor = widget.textColor;
      }else{
        textColor = widget.textColor;
        foregroundColor = widget.foregroundColor;
        loadingColor = widget.loadingColor;
      }
      if (widget.makeInverse){
        onHoverLocal(start);
      }

    });
  }

  textStyleLocal() {
    return TextStyle(
        color: widget.isTextOnly ? (textColor ?? Clr.colorBlack) : textColor,
        fontSize: widget.textSize,
        fontWeight: widget.hasBold ? FontWeight.bold : FontWeight.normal);
  }
}
