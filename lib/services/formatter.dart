import 'package:flutter/services.dart';
import 'package:my_widgets/my_widgets.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;
  final String? message;
  final bool? showToast;

  MaxValueInputFormatter(this.maxValue,  {this.message, this.showToast});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final intValue = int.tryParse(newValue.text) ?? 0;
    if (intValue > maxValue) {
      if(showToast??true){
        pShowToast(message: message??'Max allowed value is $maxValue');
      }

      return oldValue; // Revert to old value if the new value exceeds maxValue
    }
    return newValue;
  }
}

class MinValueInputFormatter extends TextInputFormatter {
  final int minValue;
  final String? message;
  final bool? showToast;

  MinValueInputFormatter(this.minValue,   {this.message, this.showToast});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final intValue = int.tryParse(newValue.text) ?? 0;
    if (intValue < minValue) {
      if(showToast??true){
        pShowToast(message: message??'Min allowed value is $minValue');
      }
      return oldValue; // Revert to old value if the new value exceeds maxValue
    }
    return newValue;
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  final bool mustStartWithPlus;
  final int maxLength;
  final int minLength;
  final String? messagePlus;
  final String? messageValidity;
  final String? messageLength;
  final bool? showToast;

  PhoneNumberInputFormatter({
    this.mustStartWithPlus = false,
    this.maxLength = 15,
    this.minLength = 1,
    this.messagePlus,
    this.messageValidity,
    this.messageLength,
    this.showToast,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Validate input starts with `+` if required
    if (mustStartWithPlus && !text.startsWith('+')) {
      if(showToast??true){
        pShowToast(message: messagePlus??'Phone number should be start with +');
      }
      return oldValue; // Revert to old value if it doesn't start with `+`
    }

    // Validate only numbers (and optional `+` if allowed)
    final validPattern = mustStartWithPlus ? r'^\+[0-9]*$' : r'^\+?[0-9]*$';
    final regex = RegExp(validPattern);
    if (!regex.hasMatch(text)) {
      if(showToast??true){
        pShowToast(message: messageValidity??'Phone number should be a valid number');
      }
      return oldValue; // Revert if input doesn't match the pattern
    }

    // Enforce max length
    if (text.length > maxLength) {
      if(showToast??true){
        pShowToast(message: messageLength??'Phone number length should be between $minLength to $maxLength');
      }
      return oldValue;
    }
    if (text.length < minLength) {
      if(showToast??true){
        pShowToast(message: messageLength??'Phone number length should be between $minLength to $maxLength');
      }
      return oldValue;
    }

    return newValue;
  }
}

class PasswordInputFormatter extends TextInputFormatter {
  final bool isComplex;
  final int? minLength;
  final int? maxLength;
  final String? message;
  final bool? showToast;
  final RegExp? regExp;


  PasswordInputFormatter({
    required this.isComplex,
    this.minLength,
    this.maxLength,
    this.message,
    this.showToast,
    this.regExp,
  }
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Enforce max length

    if (maxLength !=  null && text.length > maxLength!) {
      pShowToast(message: message??'Password length should be between $minLength to $maxLength');
      return oldValue; // Revert if length exceeds max
    }

    // Check if input meets complexity requirements
    if (isComplex) {
      final complexPattern = regExp??RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]*$'); // At least 1 uppercase, 1 lowercase, 1 digit
      if (!complexPattern.hasMatch(text) && text.isNotEmpty) {
        if(showToast??true){
          pShowToast(message:  message??"Password must include at least 1 uppercase, 1 lowercase, and 1 number");
        }
        return oldValue; // Revert if input doesn't match complex rules
      }
    }

    // Enforce min length only when submitting (use external validation in form)
    if (maxLength !=  null && text.length < minLength! && text.isNotEmpty) {
      pShowToast(message: message??'Password length should be between $minLength to $maxLength');
      return newValue; // Allow user to input until it matches min length
    }

    return newValue;
  }
}

class DecimalFormatter extends TextInputFormatter {
  final bool convertToFloat;
  final int decimalPlaces; // Number of allowed decimal places

  DecimalFormatter({this.convertToFloat = false, this.decimalPlaces = 2});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Check if the text is a valid number
    if (!_isValidDecimal(text)) {
      return oldValue;
    }

    // Parse the input value as a double
    double value = double.tryParse(text) ?? 0.0;

    // Remove unnecessary decimals if value is a whole number
    String formatted = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : decimalPlaces);

    if (convertToFloat) {
      return TextEditingValue(
        text: value.toString(), // Convert to float representation
        selection: TextSelection.collapsed(offset: value.toString().length),
      );
    } else {
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  bool _isValidDecimal(String input) {
    final regex = RegExp(r'^\d+(\.\d{0,' + decimalPlaces.toString() + r'})?$'); // Matches numbers with user-defined decimal places
    return regex.hasMatch(input);
  }
}