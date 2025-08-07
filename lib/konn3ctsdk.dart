import 'package:flutter/material.dart';

import 'konn3ctsdk_platform_interface.dart';

class Konn3ctsdk {
  Future<String?> getPlatformVersion() {
    return Konn3ctsdkPlatform.instance.getPlatformVersion();
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
    return Konn3ctsdkPlatform.instance.startmeeting(
      baseurl: baseurl,
      fullname: fullname,
      token: token,
      accesscode: accesscode,
      startroom: startroom,
      email: email,
      roomdetails: roomdetails,
      context: context,
    );
  }
}
