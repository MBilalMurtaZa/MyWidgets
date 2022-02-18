import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../models/response_model.dart';
import '../my_widgets.dart';



// bool trustSelfSigned = true;
// HttpClient httpClient = new HttpClient()
//   ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
// IOClient ioClient = IOClient(httpClient);

class HttpCalls{
  static bool isLive = true;
  static String live = "https://mobbe.esolutionsprovider.com/";
  static String testing = "https://mobbe.esolutionsprovider.com/";
  static String sServerURL = isLive?live:testing;


  static Uri getRequestURL(String postFix) {
    return Uri.parse(sServerURL+'api/'+postFix);
  }

  static ViewResponse getDataObject(Response result) {
    Map<String, dynamic> userMap = jsonDecode(result.body);
    ViewResponse response = ViewResponse.fromJson(userMap);
    return response;
  }




  static Future<ViewResponse> callGetApi(String endPoint,{bool hasAuth = true,required String token}) async {
    ViewResponse response;

    Uri url = HttpCalls.getRequestURL(endPoint);
    print(url);
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    var result;
    try {
      result = await http.get(url,headers: header,).timeout(Duration(seconds: pTimeout));
      print(result.body);
      response = HttpCalls.getDataObject(result);
    } on TimeoutException catch (e) {
      print("$e 001");
      response = ViewResponse(message: e.toString(), status: false);
    } on HandshakeException catch (e) {
      print("$e 002");
      response = ViewResponse(message: e.toString(), status: false);
    } catch (e) {
      print("Exception $e 003");
      response = ViewResponse(message: e.toString(), status: false);


    }

    return response;
  }

  static Future<ViewResponse> callPostApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true,required String token}) async {
    ViewResponse response;

    print(params);
    Uri url = HttpCalls.getRequestURL(endPoint);
    print(url);
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    Response result;
    try {

      result = await http.post(url,headers: header, body: utf8.encode(json.encode(params))).timeout(Duration(seconds: pTimeout));
      if (kDebugMode) {
        print(result.body);
      }
      response = HttpCalls.getDataObject(result);
      if (kDebugMode) {
        print('response: $response');
        print(response.data);
        print(response.message);
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print("$e 001");
      }
      response = ViewResponse( message: e.toString(), status: false);
    } on HandshakeException catch (e) {
      if (kDebugMode) {
        print("$e 002");
      }
      response = ViewResponse(message: e.toString(), status: false);
    } catch (e) {
      if (kDebugMode) {
        print("Exception $e 003");
      }
      String error = e.toString();
      if(e.toString().contains('SocketException')){
        error = 'seems like internet issue';
      }
      response = ViewResponse(message: error, status: false);
    }
    return response;
  }

  static Future<ViewResponse> callPutApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true,required String token}) async {
    ViewResponse response;


    print(params);
    Uri url = HttpCalls.getRequestURL(endPoint);
    print(url);
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    var result;
    try {

      result = await http.put(url,headers: header, body: utf8.encode(json.encode(params))).timeout(Duration(seconds: pTimeout));
      print(result.body);
      response = HttpCalls.getDataObject(result);
      print('response: $response');
      print(response.data);
      print(response.message);
    } on TimeoutException catch (e) {
      print("$e 001");
      response = ViewResponse( message: e.toString(), status: false);
    } on HandshakeException catch (e) {
      print("$e 002");
      response = ViewResponse(message: e.toString(), status: false);
    } catch (e) {
      print("Exception $e 003");
      response = ViewResponse(message: e.toString(), status: false);
    }
    return response;
  }

  static Future<ViewResponse> callDeleteApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true, required String token}) async {
    ViewResponse response;

    print(params);
    Uri url = HttpCalls.getRequestURL(endPoint);
    print(url);
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    try {
      final request = Request("DELETE", url);
      request.headers.addAll(header);
      request.body = jsonEncode(params);
      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      print(result.body);
      response = HttpCalls.getDataObject(result);
      print('response: $response');
      print(response.data);
      print(response.message);

    } on TimeoutException catch (e) {
      print("$e 001");
      response = ViewResponse( message: e.toString(), status: false);
    } on HandshakeException catch (e) {
      print("$e 002");
      response = ViewResponse(message: e.toString(), status: false);
    } catch (e) {
      print("Exception $e 003");
      response = ViewResponse(message: e.toString(), status: false);
    }
    return response;
  }

  static Future<ViewResponse> uploadFile(String endPoint, String filename, {String fileKey = 'image',bool isUserAvatar = false,bool hasAuth = true,Map<String, String>? params,required String token}) async {
    Uri url = HttpCalls.getRequestURL(endPoint);
    print(url);
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    try{
      var request = MultipartRequest('POST', url,);
      request.files.add(await MultipartFile.fromPath(fileKey, filename));
      request.headers.addAll(header);
      if(params != null)
        request.fields.addAll(params);


      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      print(result.body);
      ViewResponse response = HttpCalls.getDataObject(result);
      return response;

    }catch (e){
      print(e.toString());
      pShowToast(message: e.toString());
      return ViewResponse(status: false, message: 'Something went wrong, please try again in few minuets');
    }
  }



}