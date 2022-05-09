class ViewResponse{
  bool status;
  String message;
  dynamic data;

  ViewResponse(
      {
        this.status = false,
        this.message = '',
        this.data,

      });


  ViewResponse.fromJson(Map<String, dynamic> json)
      : status = json['status']??json['Status'],
        message = json['message']??json['Message']??'No message received from Server ',
        data = json['data']??json['Data'];
}