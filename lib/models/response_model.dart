class ViewResponse{
  bool status;
  String message;
  dynamic data;

  ViewResponse({this.status = false,this.message = '',this.data});


  ViewResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'];
}