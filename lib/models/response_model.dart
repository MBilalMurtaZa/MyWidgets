// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains response model.

import 'package:http/http.dart';
import 'package:my_widgets/utils/utils.dart';

class ViewResponse {
  bool status;
  String message;
  String errorMessage;
  dynamic data;
  dynamic statusCode;
  dynamic errorCode;
  dynamic apiStatusCode;
  dynamic pagination;
  Response? rawResponse;

  ViewResponse({
    this.status = false,
    this.message = '',
    this.errorMessage = '',
    this.data,
    this.statusCode = '',
    this.apiStatusCode,
    this.pagination = '',
    this.rawResponse,
  });

  ViewResponse.fromJson(Map<String, dynamic> json, {Response? response})
      : status = json[(Static.responseStatusKey ?? '')] ??
            json['status'] ??
            json['Status'] ??
            json['statusCode'] == '000'??
            false,
        message = (json[(Static.responseMessageKey ?? '')] ??
            json['message'] ??
            json['Message'] ??
            json['MESSAGE'] ??
            'No message received from Server ').toString(),
        errorMessage = (json[(Static.responseErrorMessageKey ?? '')] ??
            json['errorMessage'] ??
            json['ErrorMessage'] ??
            'No error message received from Server ').toString(),
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
        errorCode = json[(Static.responseErrorCodeKey ?? '')] ??
            json['error_code'] ??
            json['errorCode'] ??
            json['ErrorCode'] ??
            json['ERRORCODE'] ??
            json['ERROR_CODE'] ??
            json['error_code'] ??
            'No code received from Server ',
        apiStatusCode = json['apiStatusCode']??'',
        pagination = json[(Static.responsePaginationKey ?? '')] ??
            json['pagination'] ??
            'No code received from Server ',
        rawResponse = response;
}
