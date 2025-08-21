import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_widgets/my_widgets.dart';
import '../models/response_model.dart';
import '../utils/utils.dart';

// bool trustSelfSigned = true;
// HttpClient httpClient = new HttpClient()
//   ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
// IOClient ioClient = IOClient(httpClient);

class HttpCalls {
  static bool isLive = true;
  static bool? showAPILogs;
  static String live = "";
  static String testing = "";
  static String sServerURL = isLive ? live : testing;
  static bool httpCallsWithStream = false;
  static bool httpResponseUtf8Convert = false;
  static bool httpCallsDefaultResponse = true;
  static Future Function()? httpCallPreFunction;
  static Future Function()? httpCallPostFunction;
  static late int httpCallTimeoutInSec;
  static Function(dynamic error, dynamic response, bool? defaultResponse)? onHttpCallError;
  static String internetIssue = 'Seems like internet issue please check your device internet';
  static String? localization;

  static Map<String, String>? httpHeader;
  static Map<String, String>? headerAddOns;
  static Map<String, dynamic>? httpParamsAddOns;
  static Future<bool> Function()? preCheckFunction;
  static bool isInternetAvailable = true;

  HttpCalls._();

  static Uri getRequestURL(String postFix, {bool? useDefaultURl, required String requestType}) {
    if (useDefaultURl ?? Static.useDefaultURl ?? true) {
      String fullURL = sServerURL + postFix;
      if (fullURL.contains('://')) {
        List<String> list = fullURL.split('://');
        list.last = list.last.replaceAll('//', '/');
        fullURL = list.join('://');
      }
      debugPrint("$requestType Request with URL: $fullURL");
      return Uri.parse(fullURL);
    } else {
      if (postFix.contains('://')) {
        List<String> list = postFix.split('://');
        list.last = list.last.replaceAll('//', '/');
        postFix = list.join('://');
      }
      debugPrint("$requestType Request with URL: ${Uri.parse(postFix).toString()}");
      return Uri.parse(postFix);
    }
  }

  static dynamic getDataObject(Response result, {bool? defaultResponse}) async {
    Map<String, dynamic> userMap = jsonDecode(result.body);
    userMap['apiStatusCode'] = result.statusCode;
    if ((defaultResponse ?? HttpCalls.httpCallsDefaultResponse)) {
      return ViewResponse.fromJson(userMap, response: result);
    }
    return userMap;
  }
  
  static String getPlatform() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      
    }
  }

  static Future<dynamic> callGetApi(
    String endPoint, {
    bool hasAuth = true,
    required String token,
    bool? defaultResponse,
    bool? withStream,
    bool? utf8Convert,
    bool isTypeJson = true,
    Map<String, String>? customHeader,
    String? changeLocalization,
    String tokenKey = 'Bearer ',
    bool? useDefaultURl,
    bool? showLogs,
    int? callTimeoutInSec,
    bool? usePreCheckFn,
    Future<T> Function<T>()? httpCallPreFunction,
    bool callHttpCallPreFunction = true,
    Future<T> Function<T>()? httpCallPostFunction,
    bool callHttpCallPostFunction = true,
  }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }

    try {
      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }

      await callPreCheckFn(usePreCheckFn);

      Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: 'GET');
      showLog(url, showLog: showLogs, logName: endPoint);

      final Map<String, String> header = {
        'platform': getPlatform(),
      };

      if ((localization ?? changeLocalization) != null) {
        header['X-localization'] = localization ?? changeLocalization ?? '';
        header['Accept-Language'] = localization ?? changeLocalization ?? '';
      }

      if (isTypeJson) {
        header[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }

      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }
      

      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);

      if (withStream ?? httpCallsWithStream) {
        var request = http.Request('GET', url);
        request.headers.addAll(customHeader ?? httpHeader ?? header);
        var streamedResponse = await request.send().timeout(
            Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        var result = await Response.fromStream(streamedResponse);
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          if (utf8Convert ?? httpResponseUtf8Convert) {
            response = HttpCalls.getDataObject(Response(utf8.decoder.convert(result.bodyBytes), streamedResponse.statusCode), defaultResponse: defaultResponse);

            showLog(utf8.decoder.convert(result.bodyBytes).toString(),
                enableJsonEncode: false, showLog: showLogs, logName: endPoint);
          } else {
            response = HttpCalls.getDataObject(result,
                defaultResponse: defaultResponse);
            showLog(result.body.toString(),
                enableJsonEncode: false, showLog: showLogs, logName: endPoint);
          }
        } else {
          throw Exception(result);
        }
      } else {
        var result = await http
            .get(
              url,
              headers: customHeader ?? httpHeader ?? header,
            )
            .timeout(
                Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          response =
              HttpCalls.getDataObject(result, defaultResponse: defaultResponse);

          showLog(result.body.toString(),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        } else {
          throw Exception(result);
        }
      }


      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } on Exception catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }
    return response;
  }

  static Future<dynamic> callPostApi(
    String endPoint,
    Map params, {
    bool hasAuth = true,
    bool hasEncoded = true,
    required String token,
    bool? defaultResponse,
    bool defaultResponseWithoutJsonDecode = false,
    bool? withStream,
    bool? utf8Convert,
    isTypeJson = true,
    Map<String, String>? customHeader,
    String? paramAsBody,
    String? changeLocalization,
    String tokenKey = 'Bearer ',
    bool? useDefaultURl,
    bool? showLogs,
    int? callTimeoutInSec,
    bool? usePreCheckFn,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
  }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    try {
      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
      await callPreCheckFn(usePreCheckFn);
      showLog(params, showLog: showLogs, logName: endPoint);

      Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: 'POST');

      final Map<String, String> header = {
        'platform': getPlatform(),
      };
      if ((localization ?? changeLocalization) != null) {
        header['X-localization'] = localization ?? changeLocalization ?? '';
        header['Accept-Language'] = localization ?? changeLocalization ?? '';
      }
      if (isTypeJson) {
        header[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }
      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }

      if (httpParamsAddOns != null) {
        params.addAll(httpParamsAddOns!);
      }


      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);

      if (withStream ?? httpCallsWithStream) {
        var request = http.Request('POST', url);
        request.body = paramAsBody ?? json.encode(params);
        request.headers.addAll(customHeader ?? httpHeader ?? header);
        var streamedResponse = await request.send().timeout(
            Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        var result = await Response.fromStream(streamedResponse);
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          if (utf8Convert ?? httpResponseUtf8Convert) {
            if (defaultResponseWithoutJsonDecode) {
              response = result;
            } else {
              response = HttpCalls.getDataObject(
                  Response(utf8.decoder.convert(result.bodyBytes),
                      streamedResponse.statusCode),
                  defaultResponse: defaultResponse);
            }

            showLog(utf8.decoder.convert(result.bodyBytes),
                enableJsonEncode: false, showLog: showLogs, logName: endPoint);
          } else {
            response = HttpCalls.getDataObject(result,
                defaultResponse: defaultResponse);
            showLog(result.body.toString(),
                enableJsonEncode: false, showLog: showLogs, logName: endPoint);
          }
        } else {
          throw Exception(result);
        }
      } else {
        var result = await http
            .post(url,
                headers: customHeader ?? httpHeader ?? header,
                body: paramAsBody ?? utf8.encode(json.encode(params)))
            .timeout(
                Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          response =
              HttpCalls.getDataObject(result, defaultResponse: defaultResponse);

          showLog(result.body.toString(),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        } else {
          throw Exception(result);
        }
      }

      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      response = errorHandler(e, response, defaultResponse);
    }

    return response;
  }

  static Future<dynamic> callPatchApi(
    String endPoint,
    Map params, {
    bool hasAuth = true,
    bool hasEncoded = true,
    required String token,
    bool? defaultResponse,
    bool? withStream,
    bool? utf8Convert,
    String? paramAsBody,
    bool isTypeJson = true,
    Map<String, String>? customHeader,
    String? changeLocalization,
    String tokenKey = 'Bearer ',
    bool? useDefaultURl,
    bool? showLogs,
    int? callTimeoutInSec,
    bool? usePreCheckFn,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
  }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    try {
      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
      await callPreCheckFn(usePreCheckFn);
      showLog((params), showLog: showLogs, logName: endPoint);
      Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: 'PATCH');

      final Map<String, String> header = {
        'X-localization': '',
        'content-type': 'application/json'
      };
      if ((localization ?? changeLocalization) != null) {
        header['X-localization'] = localization ?? changeLocalization ?? '';
        header['Accept-Language'] = localization ?? changeLocalization ?? '';
      }
      if (isTypeJson) {
        header[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }
      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }

      if (httpParamsAddOns != null) {
        params.addAll(httpParamsAddOns!);
      }
      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);
      if (withStream ?? httpCallsWithStream) {
        var request = http.Request('PATCH', url);
        request.body = paramAsBody ?? json.encode(params);
        request.headers.addAll(customHeader ?? httpHeader ?? header);
        var streamedResponse = await request.send().timeout(
            Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        var result = await Response.fromStream(streamedResponse);
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          if (utf8Convert ?? httpResponseUtf8Convert) {
            response = HttpCalls.getDataObject(
                Response(utf8.decoder.convert(result.bodyBytes),
                    streamedResponse.statusCode),
                defaultResponse: defaultResponse);
            showLog(utf8.decoder.convert(result.bodyBytes),
                enableJsonEncode: false, showLog: showLogs, logName: endPoint);
          } else {
            response = HttpCalls.getDataObject(result,
                defaultResponse: defaultResponse);
            showLog(result.body.toString(),
                enableJsonEncode: false, showLog: showLogs, logName: endPoint);
          }
        } else {
          throw Exception(result);
        }
      } else {
        var result = await http
            .patch(url,
                headers: customHeader ?? httpHeader ?? header,
                body: paramAsBody ?? utf8.encode(json.encode(params)))
            .timeout(
                Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          response =
              HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          showLog(result.body.toString(),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        } else {
          throw Exception(result);
        }
      }
      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }
    return response;
  }

  static Future<dynamic> callPutApi(String endPoint, Map params,
      {bool hasAuth = true,
      bool hasEncoded = true,
      required String token,
      bool? defaultResponse,
      bool? withStream,
      bool? utf8Convert,
      bool isTypeJson = true,
      String? paramAsBody,
      Uint8List? paramAsBodyBinary,
      Map<String, String>? customHeader,
      String? changeLocalization,
      String tokenKey = 'Bearer ',
      bool? useDefaultURl,
      bool? showLogs,
      bool? usePreCheckFn,
      int? callTimeoutInSec,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
      }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    try {
    if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
    await callPreCheckFn(usePreCheckFn);
    showLog((params), showLog: showLogs, logName: endPoint);

    Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: 'PUT');

    final Map<String, String> header = {
        'platform': getPlatform(),
      };

    if ((localization ?? changeLocalization) != null) {
      header['X-localization'] = localization ?? changeLocalization ?? '';
      header['Accept-Language'] = localization ?? changeLocalization ?? '';
    }

    if (isTypeJson) {
      header[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    if (hasAuth) {
      header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
          '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
    }
    if (headerAddOns != null) {
      header.addAll(headerAddOns!);
    }
    showLog((customHeader ?? httpHeader ?? header),
        showLog: showLogs, logName: endPoint);
    
      if (paramAsBodyBinary != null) {
        var response =
            await http.put(Uri.parse(endPoint), body: paramAsBodyBinary);
        return response;
      }
      if (withStream ?? httpCallsWithStream) {
        var request = http.Request('PUT', url);
        if (paramAsBodyBinary != null) {
          request.bodyBytes = paramAsBodyBinary;
        }
        request.body = json.encode(params);
        request.headers.addAll(customHeader ?? httpHeader ?? header);
        var streamedResponse = await request.send().timeout(
            Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        var result = await Response.fromStream(streamedResponse);
        if (utf8Convert ?? httpResponseUtf8Convert) {
          response = HttpCalls.getDataObject(
              Response(utf8.decoder.convert(result.bodyBytes),
                  streamedResponse.statusCode),
              defaultResponse: defaultResponse);
          showLog(utf8.decoder.convert(result.bodyBytes),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        } else {
          response =
              HttpCalls.getDataObject(result, defaultResponse: defaultResponse);

          showLog(result.body.toString(),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        }
      } else {
        var result = await http
            .put(url,
                headers: customHeader ?? httpHeader ?? header,
                body: paramAsBody ?? utf8.encode(json.encode(params)))
            .timeout(
                Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
        if (result.statusCode < Static.stopDecodingFromErrorCode) {
          response =
              HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          showLog((params), showLog: showLogs, logName: endPoint);
          showLog(result.body.toString(),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        } else {
          throw Exception(result);
        }
      }
      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }
    return response;
  }

  static Future<dynamic> callDeleteApi(String endPoint, Map params,
      {bool hasAuth = true,
      bool hasEncoded = true,
      required String token,
      bool? defaultResponse,
      bool? withStream,
      bool? utf8Convert,
      bool isTypeJson = true,
      Map<String, String>? customHeader,
      String? paramAsBody,
      String? changeLocalization,
      String tokenKey = 'Bearer ',
      bool? useDefaultURl,
      bool? showLogs,
      bool? usePreCheckFn,
      int? callTimeoutInSec,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
      }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    try {
      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
      await callPreCheckFn(usePreCheckFn);
      showLog((params), showLog: showLogs, logName: endPoint);

      Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: 'DELETE');

      final Map<String, String> header = {
        'platform': getPlatform(),
      };

      if ((localization ?? changeLocalization) != null) {
        header['X-localization'] = localization ?? changeLocalization ?? '';
        header['Accept-Language'] = localization ?? changeLocalization ?? '';
      }

      if (isTypeJson) {
        header[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }
      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }

      if (httpParamsAddOns != null) {
        params.addAll(httpParamsAddOns!);
      }

      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);

      var request = http.Request('DELETE', url);
      request.body = paramAsBody ?? json.encode(params);
      request.headers.addAll(customHeader ?? httpHeader ?? header);
      var streamedResponse = await request
          .send()
          .timeout(Duration(seconds: callTimeoutInSec ?? httpCallTimeoutInSec));
      var result = await Response.fromStream(streamedResponse);
      if (result.statusCode < Static.stopDecodingFromErrorCode) {
        if (utf8Convert ?? httpResponseUtf8Convert) {
          response = HttpCalls.getDataObject(
              Response(utf8.decoder.convert(result.bodyBytes),
                  streamedResponse.statusCode),
              defaultResponse: defaultResponse);
          showLog(utf8.decoder.convert(result.bodyBytes),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        } else {
          response =
              HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
          showLog(result.body.toString(),
              enableJsonEncode: false, showLog: showLogs, logName: endPoint);
        }
      }
      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }
    return response;
  }

  static Future<void> callPreCheckFn(bool? usePreCheckFn) async {
    if (preCheckFunction != null && (usePreCheckFn ?? Static.usePreCheckFunctionInHttpCalls ?? false)) {
      bool result = await preCheckFunction!();
      if (!result) {
        throw Exception('pre-check fn error');
      }
    }
  }

  @Deprecated('Please use uploadFiles instead of uploadFile')
  static Future<dynamic> uploadFile(
    String endPoint,
    String filename, {
    String fileKey = 'image',
    bool isUserAvatar = false,
    bool hasAuth = true,
    Map<String, String>? params,
    required String token,
    bool? defaultResponse,
    Map<String, String>? customHeader,
    bool isTypeJson = true,
    String? changeLocalization,
    String requestType = 'POST',
    String tokenKey = 'Bearer ',
    bool? useDefaultURl,
    bool? showLogs,
    bool? usePreCheckFn,
    int? callTimeoutInSec,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
  }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: requestType);
    try {
      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
      await callPreCheckFn(usePreCheckFn);
      final Map<String, String> header = {
        'platform': getPlatform(),
      };

      if ((localization ?? changeLocalization) != null) {
        header['X-localization'] = localization ?? changeLocalization ?? '';
        header['Accept-Language'] = localization ?? changeLocalization ?? '';
      }

      if (isTypeJson) {
        header[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }
      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }


      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);
      var request = MultipartRequest(
        requestType,
        url,
      );
      request.files.add(await MultipartFile.fromPath(fileKey, filename));
      request.headers.addAll(customHeader ?? httpHeader ?? header);
      if (params != null) {
        request.fields.addAll(params);
      }

      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      showLog(result.body.toString(),
          enableJsonEncode: false, showLog: showLogs, logName: endPoint);
      response =
          HttpCalls.getDataObject(result, defaultResponse: defaultResponse);

      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }

    return response;
  }

  static Future<dynamic> uploadFiles(
    String endPoint,
    Map<String, String> fileParams, {
    List<File>? files,
    bool isUserAvatar = false,
    bool hasAuth = true,
    Map<String, String>? dataParams,
    required String token,
    bool? defaultResponse,
    Map<String, String>? customHeader,
    bool isTypeJson = true,
    String? changeLocalization,
    String requestType = 'POST',
    String tokenKey = 'Bearer ',
    bool? useDefaultURl,
    bool? showLogs,
    bool? usePreCheckFn,
    int? callTimeoutInSec,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
  }) async {
     dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: requestType);

    try {

      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
      await callPreCheckFn(usePreCheckFn);
      final Map<String, String> header = {
        'platform': getPlatform(),
      };

      if ((localization ?? changeLocalization) != null) {
        header['X-localization'] = localization ?? changeLocalization ?? '';
        header['Accept-Language'] = localization ?? changeLocalization ?? '';
      }

      if (isTypeJson) {
        header[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }
      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }

     


      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);

      showLog((dataParams), showLog: showLogs, logName: endPoint);

      showLog((fileParams), showLog: showLogs, logName: endPoint);

      var request = MultipartRequest(
        requestType,
        url,
      );

      if (files != null) {
        for (int i = 0; i < files.length; i++) {
          request.files.add(
            http.MultipartFile(
                'file',
                http.ByteStream(ByteStream(files[i].openRead())),
                await files[i].length(),
                filename: files[i].path),
          );
        }
      } else {
        await Future.forEach(
          fileParams.entries,
          (file) async {
            showLog(file.key, showLog: showLogs, logName: endPoint);
            showLog(file.value, showLog: showLogs, logName: endPoint);
            request.files.add(
              await MultipartFile.fromPath(file.key, file.value),
            );
          },
        );
      }

      request.headers.addAll(customHeader ?? httpHeader ?? header);
      if (dataParams != null) {
        request.fields.addAll(dataParams);
      }

      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      showLog(result.body.toString(),
          enableJsonEncode: false, showLog: showLogs, logName: endPoint);

      response =
          HttpCalls.getDataObject(result, defaultResponse: defaultResponse);
      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }

    return response;
  }

  @Deprecated('Please use uploadFile function to upload multipart')
  static Future<dynamic> uploadImage(
    String filename,
    String fileType, {
    String endPoint = 'file-upload',
    bool isUserAvatar = false,
    bool hasAuth = true,
    String thumbnail = '',
    required String token,
    required String userName,
    Map<String, String>? customHeader,
    bool? defaultResponse,
    String tokenKey = 'Bearer ',
    bool? useDefaultURl,
    bool? showLogs,
    bool? usePreCheckFn,
    int? callTimeoutInSec,
        Future<T> Function<T>()? httpCallPreFunction,
        bool callHttpCallPreFunction = true,
        Future<T> Function<T>()? httpCallPostFunction,
        bool callHttpCallPostFunction = true,
  }) async {
    dynamic response;
    if(!isInternetAvailable){
      pShowToast(message: internetIssue);
      response = errorHandler('SocketException', response, defaultResponse);
      return response;
    }
    
    try {

      
      if(callHttpCallPreFunction){
        if(httpCallPreFunction != null){
          await httpCallPreFunction();
        }else{
          if(HttpCalls.httpCallPreFunction != null)await HttpCalls.httpCallPreFunction!();
        }
      }
      await callPreCheckFn(usePreCheckFn);
      Uri url = HttpCalls.getRequestURL(endPoint, useDefaultURl: useDefaultURl, requestType: 'POST');
      var header = {'Accept': 'application/json'};

      if (hasAuth) {
        header[Static.httpCallTokenKey ?? HttpHeaders.authorizationHeader] =
            '${Static.canHttpCallAddBearerAsPreToken ? tokenKey : ''}$token';
      }
      if (headerAddOns != null) {
        header.addAll(headerAddOns!);
      }


      showLog((customHeader ?? httpHeader ?? header),
          showLog: showLogs, logName: endPoint);

      var request = http.MultipartRequest(
        'POST',
        url,
      );
      request.files.add(await http.MultipartFile.fromPath('file', filename));
      if (fileType == 'video') {
        request.files
            .add(await http.MultipartFile.fromPath('thumbnail', thumbnail));
      }
      request.fields['fileType'] = fileType;
      request.fields['userName'] = userName;

      if (hasAuth) request.headers.addAll(customHeader ?? httpHeader ?? header);
      var streamedResponse = await request.send();
      var result = await Response.fromStream(streamedResponse);
      showLog(result.body.toString(),
          enableJsonEncode: false, showLog: showLogs, logName: endPoint);
      response =
          HttpCalls.getDataObject(result, defaultResponse: defaultResponse);

      if(callHttpCallPostFunction){
        if(httpCallPostFunction != null){
          await httpCallPostFunction();
        }else{
          if(HttpCalls.httpCallPostFunction != null)await HttpCalls.httpCallPostFunction!();
        }
      }
    } catch (e) {
      response = errorHandler(e, response, defaultResponse);
    }
    return response;
  }

  static dynamic errorHandler(error, response, bool? defaultResponse) {
    dynamic returnData;
    if (error.message is http.Response) {
      Response r = error.message;
      if (defaultResponse ?? HttpCalls.httpCallsDefaultResponse) {
        returnData = ViewResponse(
          status: false,
          statusCode: r.statusCode,
          message: 'Something went wrong please try again error handler from package',
          errorMessage: r.reasonPhrase ?? 'Something went wrong please try again error handler from package',
          rawResponse: null
        );
      } else {
        Map<String, dynamic> userMap = {
          'status': false,
          'Status': false,
          'statusCode': r.statusCode,
          'apiStatusCode': r.statusCode,
          'message': error.contains('SocketException') ? internetIssue : error,
          'Message': error.contains('SocketException') ? internetIssue : error,
        };
        returnData = userMap;
      }
    } else if (error.message is String) {
      String r = error.message;
      if (defaultResponse ?? HttpCalls.httpCallsDefaultResponse) {
        returnData = ViewResponse(
          status: false,
          statusCode: 101,
          apiStatusCode: '101',
          message: 'Something went wrong please try again',
          errorMessage: 'Something went wrong please try again',
            rawResponse: null
        );
      } else {
        Map<String, dynamic> userMap = {
          'status': false,
          'Status': false,
          'statusCode': 101,
          'apiStatusCode': '101',
          'message': r.contains('SocketException') ? internetIssue : r,
          'Message': r.contains('SocketException') ? internetIssue : r,
        };
        returnData = userMap;
      }
    } else {
      if (defaultResponse ?? HttpCalls.httpCallsDefaultResponse) {
        returnData = ViewResponse(
          status: false,
          statusCode: 102,
          apiStatusCode: '102',
          message: 'Something went wrong please try again',
          errorMessage: 'Something went wrong please try again',
            rawResponse: null
        );
      } else {
        Map<String, dynamic> userMap = {
          'status': false,
          'Status': false,
          'statusCode': 102,
          'apiStatusCode': 102,
          'message': "Unknown Error",
          'Message': 'Unknown Error',
        };
        returnData = userMap;
      }
    }

    if (HttpCalls.onHttpCallError != null) {
      HttpCalls.onHttpCallError!(error, returnData,
          defaultResponse ?? HttpCalls.httpCallsDefaultResponse);
    }

    return returnData;
  }

  static void showLog(dynamic data,
      {bool? showLog,
      bool enableJsonEncode = true,
      bool showPrint = false,
      required String logName}) {
    try {
      if (HttpCalls.showAPILogs ?? showLog ?? kDebugMode) {
        showPrint
            ? debugPrint(data)
            : log(enableJsonEncode ? jsonEncode(data) : data,
                time: DateTime.timestamp(), name: 'HttpCalls=> $logName');
      }
    } catch (e) {
      log('getting exception showing log', time: DateTime.timestamp());
    }
  }



}
