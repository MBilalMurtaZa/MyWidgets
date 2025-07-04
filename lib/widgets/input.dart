// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains input.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_widgets/widgets/dividers.dart';
import '../utils/utils.dart';

class TxtFormInput<T> extends StatefulWidget {
  final TextEditingController? controller;
  final String? errorMessage, hintText, labelText, prefixText;
  final String? errorLengthMessage;
  final String? fontFamily;
  final int? maxLines, minLines, maxLength, validationLength;
  final double? textSize,
      hintTextSize,
      radius,
      prefixTextSize,
      postFixTextSize,
      height;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Color? textColor, hintTextColor, prefixTextColor, postFixTextColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final double? labelPadding;
  final bool isPassword;
  final bool enabled;
  final bool isOptional;
  final bool removeAllBorders;
  final bool autofocus;
  final bool hasCounter;
  final bool? showCursor;
  final bool? hasBorder, hasLabel, showLabelStar, hasLabelOnTop;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final Widget? postFix, preFix;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormState>? formKey;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor, borderColor, cursorColor;
  final TextStyle? labelStyle, hintStyle, style, prefixStyle, postFixStyle;
  final BorderSide? borderSide;
  final bool? appDirectionLeftToRight;
  final bool? ignoringWithOnTap;
  final bool? readOnly;
  final String? Function()? validationConditionAddOn;

  final double errorHeight;
  final bool showDropDown;
  final List<DropdownMenuItem<T>>? listDropDown;
  final T? selectedDropDownValue;
  final Function(T? val)? onDropDownChanged;

  const TxtFormInput({
    super.key,
    this.controller,
    this.errorMessage,
    this.errorLengthMessage,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.sentences,
    this.textSize,
    this.hintTextSize,
    this.textColor,
    this.onChanged,
    this.onTap,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onEditingComplete,
    this.focusNode,
    this.hintText = '',
    this.hintTextColor,
    this.enabled = true,
    this.hasLabel,
    this.hasBorder,
    this.hasLabelOnTop,
    this.showLabelStar,
    this.postFix,
    this.preFix,
    this.postFixStyle,
    this.decoration,
    this.validator,
    this.formKey,
    this.isOptional = false,
    this.validationLength,
    this.labelText,
    this.labelPadding,
    this.radius,
    this.borderRadius,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 2,
    this.autofocus = false,
    this.removeAllBorders = false,
    this.prefixText,
    this.prefixTextSize,
    this.postFixTextSize,
    this.prefixTextColor,
    this.postFixTextColor,
    this.height,
    this.labelStyle,
    this.hintStyle,
    this.style,
    this.prefixStyle,
    this.hasCounter = false,
    this.borderSide,
    this.appDirectionLeftToRight,
    this.showCursor,
    this.readOnly,
    this.ignoringWithOnTap,
    this.validationConditionAddOn,
    this.cursorColor,
    this.errorHeight = 23,
    this.showDropDown = false,
    this.listDropDown,
    this.selectedDropDownValue,
    this.onDropDownChanged,
    this.fontFamily,
  });

  @override
  State<TxtFormInput> createState() => _TxtFormInputState();
}

class _TxtFormInputState extends State<TxtFormInput> {
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    if (Static.inputDecoration != null && widget.hintText != null) {
      Static.inputDecoration =
          Static.inputDecoration!.copyWith(hintText: widget.hintText ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.showDropDown ? dropDownTextField() : buildTxtInput();
  }

  Widget buildTxtInput() {
    // ignoring: widget.onTap == null ? false : widget.ignoringWithOnTap ?? true,
    return Container(
      color: Clr.colorTransparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hasLabelOnTop ?? Static.txtInputHasLabelOnTop) ...[
            (widget.hasLabel ?? Static.txtInputHasLabel)
                ? (Text.rich(TextSpan(
                    text: widget.labelText ?? widget.hintText,
                    children: <InlineSpan>[
                      if (widget.showLabelStar ??
                          Static.txtInputHasLabelWithStar)
                        TextSpan(
                          text: widget.isOptional ? '' : ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                          ),
                        ),
                    ],
                    style: widget.labelStyle ??
                        Style.labelInputStyle ??
                        TextStyle(
                            fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                            color: widget.hintTextColor,
                            fontSize: widget.hintTextSize ?? widget.textSize),
                  )))
                : Container(),
            MyDivider(
              height: widget.labelPadding ?? Static.labelPadding ?? 1,
            ),
          ],
          SizedBox(
            height: widget.height == null
                ? null
                : hasError
                    ? widget.height! + widget.errorHeight
                    : widget.height,
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.redAccent,
                primaryColorDark: Colors.red,
              ),
              child: TextFormField(
                controller: widget.controller,
                showCursor: widget.showCursor,
                maxLines: widget.isPassword ? 1 : widget.maxLines,
                minLines: widget.minLines,
                readOnly: widget.readOnly == null
                    ? widget.onTap == null
                        ? false
                        : true
                    : widget.readOnly!,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                textAlign: widget.textAlign,
                textCapitalization: widget.textCapitalization,
                style: widget.style ??
                    Style.styleInput ??
                    TextStyle(
                      fontSize: widget.textSize,
                      color: widget.textColor ?? Clr.colorTxt,
                      fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                    ),
                obscureText: widget.isPassword,
                cursorColor: widget.cursorColor,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged ??
                    (widget.formKey != null
                        ? (value) {
                            if (value.isNotEmpty) {
                              widget.formKey!.currentWidget;
                            }
                          }
                        : null),
                textInputAction: widget.textInputAction,
                onEditingComplete: widget.onEditingComplete,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                onTap: widget.onTap,
                decoration: widget.decoration ??
                    Static.inputDecoration ??
                    InputDecoration(
                      // label: hasLabel?Text(hasLabel?(hintText! + (isOptional?'':' *')): ''):null,
                      label: ((widget.hasLabel ?? Static.txtInputHasLabel) &&
                              !(widget.hasLabelOnTop ??
                                  Static.txtInputHasLabelOnTop))
                          ? (Text.rich(TextSpan(
                              text: widget.labelText ?? widget.hintText,
                              children: <InlineSpan>[
                                if (widget.showLabelStar ??
                                    Static.txtInputHasLabelWithStar)
                                  TextSpan(
                                    text: widget.isOptional ? '' : ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                                    ),
                                  ),
                              ],
                              style: widget.labelStyle ??
                                  Style.labelInputStyle ??
                                  TextStyle(
                                    color: widget.hintTextColor,
                                    fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                                  ),
                            )))
                          : null,

                      errorBorder: Static.errorBorder,
                      enabledBorder: widget.hasBorder ??
                              Static.txtInputHasBorder ??
                              false
                          ? Static.enabledBorder ??
                              OutlineInputBorder(
                                borderRadius: widget.borderRadius ??
                                    BorderRadius.all(Radius.circular(
                                        widget.radius ?? Siz.defaultRadius)),
                                borderSide: BorderSide(
                                    width: widget.borderWidth,
                                    color: widget.borderColor ??
                                        Static.borderColor ??
                                        Clr.colorGreyLight,
                                    style: widget.removeAllBorders
                                        ? BorderStyle.none
                                        : BorderStyle.solid),
                              )
                          : null,
                      focusedBorder: widget.hasBorder ??
                              Static.txtInputHasBorder ??
                              false
                          ? Static.focusedBorder ??
                              OutlineInputBorder(
                                borderRadius: widget.borderRadius ??
                                    BorderRadius.all(Radius.circular(
                                        widget.radius ?? Siz.defaultRadius)),
                                borderSide: BorderSide(
                                    width: widget.borderWidth,
                                    color: widget.borderColor ??
                                        Static.borderColor ??
                                        Clr.colorGreyLight,
                                    style: widget.removeAllBorders
                                        ? BorderStyle.none
                                        : BorderStyle.solid),
                              )
                          : null,
                      border: widget.hasBorder ??
                              Static.txtInputHasBorder ??
                              false
                          ? Static.border ??
                              OutlineInputBorder(
                                borderRadius: widget.borderRadius ??
                                    BorderRadius.all(Radius.circular(
                                        widget.radius ?? Siz.defaultRadius)),
                                borderSide: widget.removeAllBorders
                                    ? BorderSide.none
                                    : widget.borderSide ??
                                        BorderSide(
                                            width: widget.borderWidth,
                                            color: widget.borderColor ??
                                                Static.borderColor ??
                                                Clr.colorGreyLight,
                                            style: widget.removeAllBorders
                                                ? BorderStyle.none
                                                : BorderStyle.solid),
                              )
                          : widget.removeAllBorders
                              ? InputBorder.none
                              : null,
                      hintText: Static.isHintCapitalizeFirst
                          ? (widget.hintText!).capitalizeFirst
                          : (widget.hintText!),
                      hintStyle: widget.hintStyle ??
                          Style.hintInputStyle ??
                          TextStyle(
                            fontSize: widget.hintTextSize ?? widget.textSize,
                            color: widget.hintTextColor,
                            fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                          ),
                      labelStyle: widget.labelStyle ?? Style.labelInputStyle,
                      suffixIcon: widget.postFix,
                      prefixIcon: widget.preFix,
                      counterText: widget.hasCounter ? null : '',
                      enabled: widget.enabled,
                      contentPadding: (widget.contentPadding ??
                          Static.txtInoutDefaultContentPadding),
                      fillColor: widget.fillColor,
                      filled: widget.fillColor != null,
                      suffixStyle: widget.postFixStyle ??
                          Style.styleInput ??
                          TextStyle(
                            fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                            color: widget.postFixTextColor ??
                                widget.textColor ??
                                Clr.colorTxt,
                            fontSize: widget.postFixTextSize ?? widget.textSize,
                          ),
                      prefixText: widget.prefixText,
                      prefixStyle: widget.prefixStyle ??
                          Style.styleInput ??
                          TextStyle(
                            fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                            color: widget.prefixTextColor ??
                                widget.textColor ??
                                Clr.colorTxt,
                            fontSize: widget.prefixTextSize ?? widget.textSize,
                          ),
                    ),
                validator: widget.isOptional
                    ? null
                    : (widget.validator ??
                        (value) {
                          setState(() {
                            hasError = true;
                          });
                          if (value == null || value.isEmpty) {
                            return widget.errorMessage ??
                                ((widget.appDirectionLeftToRight ??
                                        Static.appDirectionLeftToRight ??
                                        true)
                                    ? '${'Please Enter'.tr} ${widget.hintText}'
                                    : '${widget.hintText} ${'Please Enter'.tr}');
                          }
                          if (widget.validationLength != null) {
                            if (value.length < widget.validationLength!) {
                              return widget.errorLengthMessage ??
                                  'At least ${widget.validationLength} character required';
                            }
                          }
                          setState(() {
                            hasError = false;
                          });

                          if (widget.validationConditionAddOn != null) {
                            String? response =
                                widget.validationConditionAddOn!();
                            if (response != null) {
                              return response;
                            }
                          }

                          return null;
                        }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownTextField<T>() {
    return Stack(
      children: [
        IgnorePointer(
          ignoring:
              widget.onTap == null ? false : widget.ignoringWithOnTap ?? true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hasLabelOnTop ?? Static.txtInputHasLabelOnTop) ...[
                (widget.hasLabel ?? Static.txtInputHasLabel)
                    ? (Text.rich(TextSpan(
                        text: widget.labelText ?? widget.hintText,
                        children: <InlineSpan>[
                          if (widget.showLabelStar ??
                              Static.txtInputHasLabelWithStar)
                            TextSpan(
                              text: widget.isOptional ? '' : ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                              ),
                            ),
                        ],
                        style: widget.labelStyle ??
                            Style.labelInputStyle ??
                            TextStyle(
                                fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                                color: widget.hintTextColor,
                                fontSize:
                                    widget.hintTextSize ?? widget.textSize),
                      )))
                    : Container(),
                MyDivider(
                  height: widget.labelPadding ?? Static.labelPadding ?? 1,
                ),
              ],
              SizedBox(
                height: widget.height == null
                    ? null
                    : hasError
                        ? widget.height! + widget.errorHeight
                        : widget.height,
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.redAccent,
                    primaryColorDark: Colors.red,
                  ),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: widget.selectedDropDownValue,
                    items: widget.listDropDown,
                    onChanged: widget.onDropDownChanged!,
                    style: widget.style ??
                        Style.styleInput ??
                        TextStyle(
                          fontSize: widget.textSize,
                          color: widget.textColor ?? Clr.colorTxt,
                          fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                        ),
                    focusNode: widget.focusNode,
                    autofocus: widget.autofocus,
                    decoration: widget.decoration ??
                        Static.inputDecoration ??
                        InputDecoration(
                          // label: hasLabel?Text(hasLabel?(hintText! + (isOptional?'':' *')): ''):null,
                          label:
                              ((widget.hasLabel ?? Static.txtInputHasLabel) &&
                                      !(widget.hasLabelOnTop ??
                                          Static.txtInputHasLabelOnTop))
                                  ? (Text.rich(TextSpan(
                                      text: widget.labelText ?? widget.hintText,
                                      children: <InlineSpan>[
                                        if (widget.showLabelStar ??
                                            Static.txtInputHasLabelWithStar)
                                          TextSpan(
                                            text: widget.isOptional ? '' : ' *',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                                            ),
                                          ),
                                      ],
                                      style: widget.labelStyle ??
                                          Style.labelInputStyle ??
                                          TextStyle(
                                            color: widget.hintTextColor,
                                            fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                                          ),
                                    )))
                                  : null,

                          errorBorder: Static.errorBorder,
                          enabledBorder: widget.hasBorder ??
                                  Static.txtInputHasBorder ??
                                  false
                              ? Static.enabledBorder ??
                                  OutlineInputBorder(
                                    borderRadius: widget.borderRadius ??
                                        BorderRadius.all(Radius.circular(
                                            widget.radius ??
                                                Siz.defaultRadius)),
                                    borderSide: BorderSide(
                                        width: widget.borderWidth,
                                        color: widget.borderColor ??
                                            Static.borderColor ??
                                            Clr.colorGreyLight,
                                        style: widget.removeAllBorders
                                            ? BorderStyle.none
                                            : BorderStyle.solid),
                                  )
                              : null,
                          focusedBorder: widget.hasBorder ??
                                  Static.txtInputHasBorder ??
                                  false
                              ? Static.focusedBorder ??
                                  OutlineInputBorder(
                                    borderRadius: widget.borderRadius ??
                                        BorderRadius.all(Radius.circular(
                                            widget.radius ??
                                                Siz.defaultRadius)),
                                    borderSide: BorderSide(
                                        width: widget.borderWidth,
                                        color: widget.borderColor ??
                                            Static.borderColor ??
                                            Clr.colorGreyLight,
                                        style: widget.removeAllBorders
                                            ? BorderStyle.none
                                            : BorderStyle.solid),
                                  )
                              : null,
                          border: widget.hasBorder ??
                                  Static.txtInputHasBorder ??
                                  false
                              ? Static.border ??
                                  OutlineInputBorder(
                                    borderRadius: widget.borderRadius ??
                                        BorderRadius.all(Radius.circular(
                                            widget.radius ??
                                                Siz.defaultRadius)),
                                    borderSide: widget.removeAllBorders
                                        ? BorderSide.none
                                        : widget.borderSide ??
                                            BorderSide(
                                                width: widget.borderWidth,
                                                color: widget.borderColor ??
                                                    Static.borderColor ??
                                                    Clr.colorGreyLight,
                                                style: widget.removeAllBorders
                                                    ? BorderStyle.none
                                                    : BorderStyle.solid),
                                  )
                              : widget.removeAllBorders
                                  ? InputBorder.none
                                  : null,
                          hintText: (widget.hintText!),
                          hintStyle: widget.hintStyle ??
                              Style.hintInputStyle ??
                              TextStyle(
                                fontSize:
                                    widget.hintTextSize ?? widget.textSize,
                                color: widget.hintTextColor,
                                fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily
                              ),
                          labelStyle:
                              widget.labelStyle ?? Style.labelInputStyle,
                          suffixIcon: widget.postFix,
                          suffixStyle: widget.postFixStyle ??
                              Style.styleInput ??
                              TextStyle(
                                fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                                color: widget.postFixTextColor ??
                                    widget.textColor ??
                                    Clr.colorTxt,
                                fontSize:
                                    widget.postFixTextSize ?? widget.textSize,
                              ),
                          prefixIcon: widget.preFix,
                          counterText: widget.hasCounter ? null : '',
                          enabled: widget.enabled,
                          contentPadding: (widget.contentPadding ??
                              Static.txtInoutDefaultContentPadding),
                          fillColor: widget.fillColor,
                          filled: widget.fillColor != null,
                          prefixText: widget.prefixText,
                          prefixStyle: widget.prefixStyle ??
                              Style.styleInput ??
                              TextStyle(
                                fontFamily: widget.fontFamily??Static.txtInputFontFamily??Static.fontFamily,
                                color: widget.prefixTextColor ??
                                    widget.textColor ??
                                    Clr.colorTxt,
                                fontSize:
                                    widget.prefixTextSize ?? widget.textSize,
                              ),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.onTap != null)
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              color: Clr.colorTransparent,
              height: (widget.hasLabelOnTop ?? false)
                  ? 70 + (widget.labelPadding ?? Static.labelPadding ?? 1)
                  : 48,
              width: double.infinity,
            ),
          )
      ],
    );
  }
}
