class ViewResponse {
  bool status;
  String message;
  String errorMessage;
  dynamic data;
  dynamic statusCode;

  ViewResponse(
      {this.status = false,
      this.message = '',
      this.errorMessage = '',
      this.data,
      this.statusCode = ''});

  ViewResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] ?? json['Status'] ?? false,
        message = json['message'] ?? json['Message'] ?? json['MESSAGE'] ?? 'No message received from Server ',
        errorMessage = json['errorMessage'] ?? json['ErrorMessage'] ?? 'No error message received from Server ',
        data = json['data'] ?? json['Data'] ?? json['DATA']?? json['response']?? json['Response']??json['RESPONSE'],
        statusCode = json['status_code'] ?? json['statusCode'] ?? json['StatusCode'] ?? json['STATUSCODE'] ?? 'No code received from Server ';
}
