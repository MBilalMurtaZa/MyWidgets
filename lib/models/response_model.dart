// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains response model.

import 'package:my_widgets/utils/utils.dart';

class ViewResponse {
  bool status;
  String message;
  String errorMessage;
  dynamic data;
  dynamic statusCode;
  dynamic pagination;

  ViewResponse({
    this.status = false,
    this.message = '',
    this.errorMessage = '',
    this.data,
    this.statusCode = '',
    this.pagination = '',
  });

  ViewResponse.fromJson(Map<String, dynamic> json)
      : status = json[(Static.responseStatusKey ?? '')] ??
            json['status'] ??
            json['Status'] ??
            false,
        message = json[(Static.responseMessageKey ?? '')] ??
            json['message'] ??
            json['Message'] ??
            json['MESSAGE'] ??
            'No message received from Server ',
        errorMessage = json[(Static.responseErrorMessageKey ?? '')] ??
            json['errorMessage'] ??
            json['ErrorMessage'] ??
            'No error message received from Server ',
        data = json[(Static.responseDataKey ?? '')] ??
            json['data'] ??
            json['Data'] ??
            json['DATA'] ??
            json['response'] ??
            json['Response'] ??
            json['RESPONSE'],
        statusCode = json[(Static.responseStatusCodeKey ?? '')] ??
            json['status_code'] ??
            json['statusCode'] ??
            json['StatusCode'] ??
            json['STATUSCODE'] ??
            'No code received from Server ',
        pagination = json[(Static.responsePaginationKey ?? '')] ??
            json['pagination'] ??
            'No code received from Server ';
}
