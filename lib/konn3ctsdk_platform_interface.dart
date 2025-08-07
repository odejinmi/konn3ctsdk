import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'konn3ctsdk_method_channel.dart';

abstract class Konn3ctsdkPlatform extends PlatformInterface {
  /// Constructs a Konn3ctsdkPlatform.
  Konn3ctsdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static Konn3ctsdkPlatform _instance = MethodChannelKonn3ctsdk();

  /// The default instance of [Konn3ctsdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelKonn3ctsdk].
  static Konn3ctsdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Konn3ctsdkPlatform] when
  /// they register themselves.
  static set instance(Konn3ctsdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> startmeeting({
    required String baseurl,
    required String fullname,
    required String token,
    required bool accesscode,
    required bool startroom,
    required String email,
    required Map<dynamic, dynamic> roomdetails,
    required BuildContext context,
  }) async {
    throw UnimplementedError('startmeeting() has not been implemented.');
  }
}
