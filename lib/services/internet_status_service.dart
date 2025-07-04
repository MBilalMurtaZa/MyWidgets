import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'http_calls.dart';


// class InternetStatusService {
//   static int retries = 50000;
//   static Duration retryDelay = .1.seconds;
//
//   static final InternetStatusService _instance = InternetStatusService._internal();
//   factory InternetStatusService({required Duration retryDelayInSeconds,required int maxRetries}) {
//     retryDelayInSeconds = retryDelayInSeconds;
//     retries = maxRetries;
//     return _instance;
//   }
//   InternetStatusService._internal() {
//     _init();
//   }
//
//   final _controller = StreamController<InternetStatus>.broadcast();
//   Stream<InternetStatus> get statusStream => _controller.stream;
//
//   void _init() {
//     Connectivity().onConnectivityChanged.listen((connectivityResult) async {
//       bool hasInternet = await checkInternetWithRetry();
//       InternetStatus internetStatus = InternetStatus(hasInternet, connectivityResult);
//       HttpCalls.isInternetAvailable = hasInternet;
//       _controller.sink.add(internetStatus);
//     });
//   }
//
//   void dispose() {
//     _controller.close();
//   }
//
//   // Retry logic to check internet availability with small delays between retries
//   Future<bool> checkInternetWithRetry() async {
//     for (int i = 0; i < retries; i++) {
//       bool hasInternet = await checkInternetAccess();
//       if (hasInternet) {
//         return true;
//       }
//       await Future.delayed(retryDelay);  // Wait for retry
//     }
//     return false;  // No internet after max retries
//   }
// }
//
// Future<bool> checkInternetAccess() async {
//   try {
//     final result = await InternetAddress.lookup('google.com');
//     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//   } on SocketException {
//     return false;
//   }
// }
//
// class InternetStatus {
//   final bool isConnected;
//   final List<ConnectivityResult> connectivityResult;
//
//   InternetStatus(this.isConnected, this.connectivityResult);
// }



class InternetStatusService {
  static Duration retryDelay = Duration(seconds: 1);  // Retry every second

  static final InternetStatusService _instance = InternetStatusService._internal();

  factory InternetStatusService({required Duration retryDelayInSeconds}) {
    retryDelay = retryDelayInSeconds;  // Set retry delay
    return _instance;
  }

  InternetStatusService._internal() {
    _init();
  }

  final _controller = StreamController<InternetStatus>.broadcast();
  Stream<InternetStatus> get statusStream => _controller.stream;

  void _init() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      // Emit initial status (whether or not the internet is accessible)
      _controller.sink.add(InternetStatus(false, connectivityResult));  // Initial "no internet"

      bool hasInternet = await checkInternetUntilRestored(connectivityResult);
      InternetStatus internetStatus = InternetStatus(hasInternet, connectivityResult);
      HttpCalls.isInternetAvailable = hasInternet;
      _controller.sink.add(internetStatus); // Emit final status once connected
    });
  }

  void dispose() {
    _controller.close();
  }

  // Retry every second until internet is restored, while emitting "no internet" status
  Future<bool> checkInternetUntilRestored(List<ConnectivityResult> connectivityResult) async {
    while (true) {
      bool hasInternet = await checkInternetAccess();
      if (hasInternet) {
        return true; // Internet restored
      }
      // Emit "no internet" status while retrying
      _controller.sink.add(InternetStatus(false, connectivityResult));

      await Future.delayed(retryDelay);  // Retry every second
    }
  }
}

Future<bool> checkInternetAccess() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  }
}

class InternetStatus {
  final bool isConnected;
  final List<ConnectivityResult> connectivityResult;

  InternetStatus(this.isConnected, this.connectivityResult);
}
