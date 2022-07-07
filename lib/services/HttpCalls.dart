import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:my_widgets/models/response_model.dart';
import '../my_widgets.dart';



// bool trustSelfSigned = true;
// HttpClient httpClient = new HttpClient()
//   ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
// IOClient ioClient = IOClient(httpClient);


class HttpCalls{
  static bool isLive = true;
  static String live = "";
  static String testing = "";
  static String sServerURL = isLive?live:testing;
  static bool httpCallsWithStream = false;
  static bool httpResponseUtf8Convert = false;
  static bool httpCallsDefaultResponse = true;




  static Uri getRequestURL(String postFix) {
    return Uri.parse(sServerURL+postFix);
  }

  static dynamic getDataObject(Response result, {bool? defaultResponse}) async{

    Map<String, dynamic> userMap = jsonDecode(result.body);
    userMap['statusCode'] = result.statusCode;
    if((defaultResponse??HttpCalls.httpCallsDefaultResponse)){
      return ViewResponse.fromJson(userMap);
    }
    return userMap;
  }

  static Future<dynamic> callGetApi(String endPoint,{bool hasAuth = true,required String token, bool? defaultResponse, bool? withStream,bool? utf8Convert}) async {
    dynamic response;

    Uri url = HttpCalls.getRequestURL(endPoint);
    print(url);
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }


    try {

      if(withStream??httpCallsWithStream){
        var request = http.Request('GET', url);
        request.headers.addAll(header);
        var streamedResponse = await request.send().timeout(Duration(seconds: pTimeout));
        var result = await Response.fromStream(streamedResponse);
        if(result.statusCode == 200){
          if(utf8Convert??httpResponseUtf8Convert){
            response = HttpCalls.getDataObject(Response(utf8.decoder.convert(result.bodyBytes), streamedResponse.statusCode), defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(utf8.decoder.convert(result.bodyBytes));
            }
          }else{
            response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(result.body);
            }
          }
        }

      }
      else{
        var result = await http.get(url,headers: header,).timeout(Duration(seconds: pTimeout));
        if(result.statusCode == 200){
          response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          if (kDebugMode) {
            print(result.body);
          }
        }else{
          throw Exception(result.statusCode);
        }
      }

    } on TimeoutException catch (e) {
      debugPrint("$e 001");
      pShowToast(message: e.toString());

    } on HandshakeException catch (e) {
      debugPrint("$e 002");
      pShowToast(message: e.toString());

    } catch (e) {
      debugPrint("Exception $e 003");
      pShowToast(message: e.toString());



    }

    return response;
  }

  static Future<dynamic> callPostApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true,required String token, bool? defaultResponse, bool? withStream,bool? utf8Convert}) async {
    dynamic response;

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

      if(withStream??httpCallsWithStream){
        var request = http.Request('POST', url);
        request.body = json.encode(params);
        request.headers.addAll(header);
        var streamedResponse = await request.send().timeout(Duration(seconds: pTimeout));
        var result = await Response.fromStream(streamedResponse);
        if(result.statusCode == 200){
          if(utf8Convert??httpResponseUtf8Convert){
            response = HttpCalls.getDataObject(Response(utf8.decoder.convert(result.bodyBytes), streamedResponse.statusCode), defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(utf8.decoder.convert(result.bodyBytes));
            }
          }else{
            response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(result.body);
            }
          }
        }

      }
      else{
        var result = await http.post(url,headers: header, body: utf8.encode(json.encode(params))).timeout(Duration(seconds: pTimeout));
        if(result.statusCode == 200){
          response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          if (kDebugMode) {
            print(result.body);
          }
        }else{
          throw Exception(result.statusCode);
        }
      }

    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print("$e 001");
        pShowToast(message: e.toString());
      }
    } on HandshakeException catch (e) {
      if (kDebugMode) {
        print("$e 002");
        pShowToast(message: e.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception $e 003");
        pShowToast(message: e.toString());
      }
      String error = e.toString();
      if(e.toString().contains('SocketException')){
        error = 'seems like internet issue';
        pShowToast(message: error);
      }
    }
    return response;
  }

  static Future<dynamic> callPatchApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true,required String token, bool? defaultResponse, bool? withStream,bool? utf8Convert}) async {
    dynamic response;

    if (kDebugMode) {
      print(params);
    }
    Uri url = HttpCalls.getRequestURL(endPoint);
    if (kDebugMode) {
      print(url);
    }
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    try {

      if(withStream??httpCallsWithStream){
        var request = http.Request('PATCH', url);
        request.body = json.encode(params);
        request.headers.addAll(header);
        var streamedResponse = await request.send().timeout(Duration(seconds: pTimeout));
        var result = await Response.fromStream(streamedResponse);
        if(result.statusCode == 200){
          if(utf8Convert??httpResponseUtf8Convert){
            response = HttpCalls.getDataObject(Response(utf8.decoder.convert(result.bodyBytes), streamedResponse.statusCode), defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(utf8.decoder.convert(result.bodyBytes));
            }
          }else{
            response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(result.body);
            }
          }
        }else{
          throw Exception(result.statusCode);
        }

      }
      else{
        var result = await http.patch(url,headers: header, body: utf8.encode(json.encode(params))).timeout(Duration(seconds: pTimeout));
        if(result.statusCode == 200){
          response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          if (kDebugMode) {
            print(result.body);
          }
        }else{
          throw Exception(result.statusCode);
        }
      }

    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print("$e 001");
        pShowToast(message: e.toString());
      }
    } on HandshakeException catch (e) {
      if (kDebugMode) {
        print("$e 002");
        pShowToast(message: e.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception $e 003");
        pShowToast(message: e.toString());
      }
      String error = e.toString();
      if(e.toString().contains('SocketException')){
        error = 'seems like internet issue';
        pShowToast(message: error);
      }
    }
    return response;
  }

  static Future<dynamic> callPutApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true,required String token, bool? defaultResponse, bool? withStream,bool? utf8Convert}) async {
    dynamic response;


    if (kDebugMode) {
      print(params);
    }
    Uri url = HttpCalls.getRequestURL(endPoint);
    if (kDebugMode) {
      print(url);
    }
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    var result;
    try {

      if(withStream??httpCallsWithStream){
        var request = http.Request('PUT', url);
        request.body = json.encode(params);
        request.headers.addAll(header);
        var streamedResponse = await request.send().timeout(Duration(seconds: pTimeout));
        var result = await Response.fromStream(streamedResponse);
        if(result.statusCode == 200){
          if(utf8Convert??httpResponseUtf8Convert){
            response = HttpCalls.getDataObject(Response(utf8.decoder.convert(result.bodyBytes), streamedResponse.statusCode), defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(utf8.decoder.convert(result.bodyBytes));
            }
          }else{
            response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
            if (kDebugMode) {
              print(result.body);
            }
          }
        }

      }
      else{
        var result = await http.put(url,headers: header, body: utf8.encode(json.encode(params))).timeout(Duration(seconds: pTimeout));
        if(result.statusCode == 200){
          response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          if (kDebugMode) {
            print(result.body);
          }
        }else{
          throw Exception(result.statusCode);
        }
      }
      
    } on TimeoutException catch (e) {
      debugPrint("$e 001");
      pShowToast(message: e.toString());
    } on HandshakeException catch (e) {
      debugPrint("$e 002");
      pShowToast(message: e.toString());
    } catch (e) {
      debugPrint("Exception $e 003");
      pShowToast(message: e.toString());
    }
    return response;
  }

  static Future<dynamic> callDeleteApi(String endPoint,  Map params,{bool hasAuth = true,bool hasEncoded = true, required String token, bool? defaultResponse, bool? withStream,bool? utf8Convert}) async {
    dynamic response;

    if (kDebugMode) {
      print(params);
    }
    Uri url = HttpCalls.getRequestURL(endPoint);
    if (kDebugMode) {
      print(url);
    }
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    try {

      var request = http.Request('DELETE', url);
      request.body = json.encode(params);
      request.headers.addAll(header);
      var streamedResponse = await request.send().timeout(Duration(seconds: pTimeout));
      var result = await Response.fromStream(streamedResponse);
      if(result.statusCode == 200){
        if(utf8Convert??httpResponseUtf8Convert){
          response = HttpCalls.getDataObject(Response(utf8.decoder.convert(result.bodyBytes), streamedResponse.statusCode), defaultResponse: defaultResponse);
          if (kDebugMode) {
            print(utf8.decoder.convert(result.bodyBytes));
          }
        }else{
          response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          if (kDebugMode) {
            print(result.body);
          }
        }
      }

    } on TimeoutException catch (e) {
      pShowToast(message: e.toString());
    } on HandshakeException catch (e) {
      pShowToast(message: e.toString());
    } catch (e) {
      pShowToast(message: e.toString());
    }
    return response;
  }

  static Future<dynamic> uploadFile(String endPoint, String filename, {String fileKey = 'image',bool isUserAvatar = false,bool hasAuth = true,Map<String, String>? params,required String token, bool? defaultResponse}) async {
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
      if(params != null) {
        request.fields.addAll(params);
      }


      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      print(result.body);
      dynamic response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
      return response;

    }catch (e){
      print(e.toString());
      pShowToast(message: e.toString());
      return null;
    }
  }

  static Future<dynamic> uploadImage(String filename,String fileType, {bool isUserAvatar = false,bool hasAuth = true, String thumbnail = '',required String token,required String userName, bool? defaultResponse}) async {
    dynamic response;
    Uri url = HttpCalls.getRequestURL('file-upload');
    print(url.toString());
    var header = {
      'Accept' : 'application/json'
    };

    if(hasAuth) {
      header[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    try{
      var request = http.MultipartRequest('POST', url,);
      request.files.add(await http.MultipartFile.fromPath('file', filename));
      if(fileType == 'video') {
        request.files.add(await http.MultipartFile.fromPath('thumbnail', thumbnail));
      }
      request.fields['fileType'] = fileType;
      request.fields['userName'] = userName;
      if (kDebugMode) {
        print('upload detail');
        print(request.fields['fileType'].toString());
        print(request.fields['userName'].toString());
        print(request.files.first.toString());
        print(request.files.first.toString());
      }

      if(hasAuth)request.headers.addAll(header);
      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      if (kDebugMode) {
        print("result.body");
        print(result.body);
      }
      response = HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
    }catch (e){
      pShowToast(message: e.toString());
    }
    return response;
  }



}