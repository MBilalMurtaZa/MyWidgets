import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'my_widgets_method_channel.dart';

abstract class MyWidgetsPlatform extends PlatformInterface {
  /// Constructs a FlutterWidgetZoomPlatform.
  MyWidgetsPlatform() : super(token: _token);

  static final Object _token = Object();

  static MyWidgetsPlatform _instance = MethodChannelFlutterWidgetZoom();

  /// The default instance of [MyWidgetsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWidgetZoom].
  static MyWidgetsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyWidgetsPlatform] when
  /// they register themselves.
  static set instance(MyWidgetsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
