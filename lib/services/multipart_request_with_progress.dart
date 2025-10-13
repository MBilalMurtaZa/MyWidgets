import 'dart:async';
import 'package:http/http.dart' as http;

class MultipartRequestWithProgress extends http.MultipartRequest {
  final void Function(int sent, int total)? onProgress;

  MultipartRequestWithProgress(
      String method,
      Uri url, {
        this.onProgress,
      }) : super(method, url);

  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    final total = contentLength;
    int sent = 0;

    final stream = byteStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sent += data.length;
          onProgress?.call(sent, total);
          sink.add(data);
        },
      ),
    );

    return http.ByteStream(stream.cast());
  }
}
