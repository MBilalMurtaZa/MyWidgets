import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../utils/utils.dart';


class TxtFormInput extends StatelessWidget {

  final TextEditingController? controller;
  final String? errorMessage, hintText, labelText;
  final String? errorLengthMessage;
  final int? maxLines, maxLength, validationLength;
  final double? textSize;
  final Color? textColor, hintTextColor;
  final List<MaskTextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool isPassword, enabled, hasLabel, hasBorder, isOptional;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final Widget? postFix, preFix;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormState>? formKey;




  const TxtFormInput(
      {
        Key? key,
        this.controller,
        this.errorMessage = 'Please enter some text',
        this.errorLengthMessage,
        this.maxLines,
        this.maxLength,
        this.inputFormatters,
        this.textAlign = TextAlign.start,
        this.textCapitalization = TextCapitalization.sentences,
        this.textSize,
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
        this.labelText

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

            decoration: decoration??InputDecoration(
              // label: hasLabel?Text(hasLabel?(hintText! + (isOptional?'':' *')): ''):null,
                label: hasLabel
                    ?
                (Text.rich(
                    TextSpan(text: labelText??hintText,children: <InlineSpan>[
                      TextSpan(text:isOptional?'':' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ], style: TextStyle(color: hintTextColor),))):null,
                border: hasBorder?OutlineInputBorder():null,
                hintText: (hintText!),
                hintStyle: TextStyle(fontSize: textSize, color: hintTextColor),
                suffixIcon: postFix,
                prefixIcon: preFix,
                counterText: '',
                enabled: enabled,
            ),

            validator: isOptional?null: (validator??(value){
              if (value == null || value.isEmpty) {
                return errorMessage;
              }
              if(validationLength != null){
                if(value.length < validationLength!)
                  return errorLengthMessage??'At least $validationLength character required';
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
