import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../utils/utils.dart';


class TxtFormInput extends StatelessWidget {

  final TextEditingController? controller;
  final String? errorMessage, hintText, labelText, prefixText;
  final String? errorLengthMessage;
  final int? maxLines, maxLength, validationLength;
  final double? textSize, hintTextSize, radius, prefixTextSize;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Color? textColor, hintTextColor,prefixTextColor;
  final List<MaskTextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool isPassword, enabled, hasLabel, hasBorder, isOptional, removeAllBorders, autofocus;
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





  const TxtFormInput(
      {
        Key? key,
        this.controller,
        this.errorMessage,
        this.errorLengthMessage,
        this.maxLines,
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
        this.hasLabel = true,
        this.hasBorder = false,
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

      }
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: onTap == null? false: true,
          child: TextFormField(
            controller: controller,
            maxLines: isPassword?1:maxLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            textAlign: textAlign,
            textCapitalization: textCapitalization,
            style: TextStyle(fontSize: textSize, color: textColor),
            obscureText: isPassword,
            keyboardType: keyboardType,
            onChanged: onChanged??(formKey != null?(value){
              if(value.isNotEmpty){
                formKey!.currentWidget;
              }
            }: null),
            textInputAction: textInputAction,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            autofocus: autofocus,

            decoration: decoration??InputDecoration(
              // label: hasLabel?Text(hasLabel?(hintText! + (isOptional?'':' *')): ''):null,
              label: hasLabel
                  ?
              (Text.rich(
                  TextSpan(text: labelText??hintText,children: <InlineSpan>[
                    TextSpan(text:isOptional?'':' *',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ], style: TextStyle(color: hintTextColor),))):null,

              border: removeAllBorders?InputBorder.none:hasBorder?OutlineInputBorder(borderRadius:borderRadius??BorderRadius.all(Radius.circular(radius??Siz.defaultRadius)),borderSide: BorderSide(width: borderWidth, color: borderColor??Clr.colorGreyLight)):null,
              hintText: (hintText!),
              hintStyle: TextStyle(fontSize: hintTextSize??textSize, color: hintTextColor),
              suffixIcon: postFix,
              prefixIcon: preFix,
              counterText: '',
              enabled: enabled,
              contentPadding: contentPadding,
              fillColor: fillColor,
              prefixText: prefixText,
              prefixStyle: TextStyle(
                color: prefixTextColor??textColor,
                fontSize: prefixTextSize??textSize,
              ),

            ),

            validator: isOptional?null: (validator??(value){
              if (value == null || value.isEmpty) {
                return errorMessage?? 'Please Enter $hintText';
              }
              if(validationLength != null){
                if(value.length < validationLength!) {
                  return errorLengthMessage??'At least $validationLength character required';
                }
              }
              return null;
            }),
          ),
        ),
        if(onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Container(
              color: Clr.colorTransparent,
              height: 60,
              width: double.infinity,
            ),
          )
      ],
    );
  }
}
