import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_widgets/widgets/dividers.dart';
import '../utils/utils.dart';


class TxtFormInput extends StatelessWidget {

  final TextEditingController? controller;
  final String? errorMessage, hintText, labelText, prefixText;
  final String? errorLengthMessage;
  final int? maxLines,minLines,  maxLength, validationLength;
  final double? textSize, hintTextSize, radius, prefixTextSize, height;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Color? textColor, hintTextColor, prefixTextColor;
  final List<MaskTextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool isPassword, enabled, isOptional, removeAllBorders, autofocus, hasCounter;
  final bool? hasBorder, hasLabel, showLabelStat, hasLabelOnTop;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final Widget? postFix, preFix;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormState>? formKey;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor, borderColor;
  final TextStyle? labelStyle, hintStyle, style, prefixStyle;


  const TxtFormInput({
    Key? key,
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
    this.showLabelStat,
    this.postFix,
    this.preFix,
    this.decoration,
    this.validator,
    this.formKey,
    this.isOptional = false,
    this.validationLength,
    this.labelText,
    this.radius,
    this.borderRadius,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 2,
    this.autofocus = false,
    this.removeAllBorders = false, this.prefixText, this.prefixTextSize, this.prefixTextColor,
    this.height,
    this.labelStyle,
    this.hintStyle,
    this.style,
    this.prefixStyle,
    this.hasCounter = false,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: onTap == null ? false : true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(hasLabelOnTop ?? Static.txtInputHasLabelOnTop)...[
                (hasLabel ?? Static.txtInputHasLabel)
                    ?
                (Text.rich(
                    TextSpan(
                      text: labelText ?? hintText,
                      children: <InlineSpan>[
                        if(showLabelStat ?? Static.txtInputHasLabelWithStar)
                          TextSpan(text: isOptional ? '' : ' *',
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                      style: labelStyle??TextStyle(color: hintTextColor, fontSize: hintTextSize ?? textSize),))) : Container(),
                const MyDivider(height: 1,),
              ],

              SizedBox(
                height: height,
                child: TextFormField(
                  controller: controller,
                  maxLines: isPassword ? 1 : maxLines,
                  minLines: minLines,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  textAlign: textAlign,
                  textCapitalization: textCapitalization,
                  style: style??TextStyle(fontSize: textSize, color: textColor),
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  onChanged: onChanged ?? (formKey != null ? (value) {
                    if (value.isNotEmpty) {
                      formKey!.currentWidget;
                    }
                  } : null),
                  textInputAction: textInputAction,
                  onEditingComplete: onEditingComplete,
                  focusNode: focusNode,
                  autofocus: autofocus,

                  decoration: decoration ?? InputDecoration(
                    // label: hasLabel?Text(hasLabel?(hintText! + (isOptional?'':' *')): ''):null,
                    label: ((hasLabel ?? Static.txtInputHasLabel) &&
                        !(hasLabelOnTop ?? Static.txtInputHasLabelOnTop))
                        ?
                    (Text.rich(
                        TextSpan(
                          text: labelText ?? hintText, children: <InlineSpan>[
                          if(showLabelStat ?? Static.txtInputHasLabelWithStar)
                            TextSpan(text: isOptional ? '' : ' *',
                              style: const TextStyle(color: Colors.red),
                            ),
                        ], style: labelStyle??TextStyle(color: hintTextColor),))) : null,

                    border: removeAllBorders
                        ?
                    InputBorder.none
                        :
                    hasBorder??Static.txtInputHasBorder
                        ?
                    OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius ?? Siz.defaultRadius)),
                        borderSide: BorderSide(width: borderWidth, color: borderColor ?? Clr.colorGreyLight))
                        :
                    null,
                    hintText: (hintText!),
                    hintStyle: hintStyle??TextStyle(
                        fontSize: hintTextSize ?? textSize,
                        color: hintTextColor),
                    labelStyle: labelStyle,
                    suffixIcon: postFix,
                    prefixIcon: preFix,
                    counterText: hasCounter?null:'',
                    enabled: enabled,
                    contentPadding: (contentPadding ?? Static.txtInoutDefaultContentPadding),
                    fillColor: fillColor,
                    prefixText: prefixText,
                    prefixStyle: prefixStyle??TextStyle(
                      color: prefixTextColor ?? textColor,
                      fontSize: prefixTextSize ?? textSize,
                    ),

                  ),

                  validator: isOptional ? null : (validator ?? (value) {
                    if (value == null || value.isEmpty) {
                      return errorMessage ?? 'Please Enter $hintText';
                    }
                    if (validationLength != null) {
                      if (value.length < validationLength!) {
                        return errorLengthMessage ??
                            'At least $validationLength character required';
                      }
                    }
                    return null;
                  }),
                ),
              ),
            ],
          ),
        ),
        if(onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Container(
              color: Clr.colorTransparent,
              height: 40,
              width: double.infinity,
            ),
          )
      ],
    );
  }
}
