import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';

import 'core/konn3ct.dart';
import 'konn3ctsdk_platform_interface.dart';

/// An implementation of [Konn3ctsdkPlatform] that uses method channels.
class MethodChannelKonn3ctsdk extends Konn3ctsdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('konn3ctsdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<dynamic> startmeeting({
    required String baseurl,
    required bool startroom,
    required String token,
    required String fullname,
    required bool accesscode,
    required String email,
    required Map<dynamic, dynamic> roomdetails,
    required BuildContext context,
  }) async {
    postjoinController pollscontroller = Get.put(postjoinController());
    pollscontroller.roomdetails = roomdetails;
    pollscontroller.baseurl = baseurl;
    pollscontroller.token = token;
    pollscontroller.usernameController.text = fullname;
    pollscontroller.emailController.text = email;
    pollscontroller.accesscode = accesscode;
    pollscontroller.isstartroom = startroom;
    pollscontroller.meetingnameController.text = roomdetails["name"];
    // Get.offAll(MeetingScreen());
    var response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Konn3ct(),
    );

    // Add a small delay or delete in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<postjoinController>()) {
        Get.delete<postjoinController>();
      }
    });
    return response;
  }
}
