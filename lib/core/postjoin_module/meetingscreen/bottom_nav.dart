import 'dart:ui';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/endroom.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/leavesession.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/share_screen_dialog.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';

class BottomNav extends GetView<postjoinController> {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromRGBO(34, 116, 81, 1),
      child: GetBuilder<Websocket>(
        builder: (websocket) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Color(0xFF3E8466),
                      content:
                          controller.bigbluebuttonsdkPlugin.mydetails != null &&
                              controller
                                      .bigbluebuttonsdkPlugin
                                      .mydetails!
                                      .fields!
                                      .role ==
                                  "MODERATOR"
                          ? Endroom()
                          : Leavesession(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Color(0xffCC525F),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.call_end_outlined, color: Colors.white),
                      SizedBox(width: 7),
                      Divider(
                        color: Color(0XFF00000033).withOpacity(0.2),
                        thickness: 0.8,
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.more_vert_outlined, color: Colors.white),
                    ],
                  ),
                ),
              ),
              if (controller.bigbluebuttonsdkPlugin.mydetails != null &&
                  controller
                      .bigbluebuttonsdkPlugin
                      .mydetails!
                      .fields!
                      .presenter! &&
                  websocket.remoteRTCVideoRenderer.srcObject == null)
                IconButton.outlined(
                  onPressed: () {
                    if (websocket.remoteRTCVideoRenderer.srcObject != null) {
                      controller.bigbluebuttonsdkPlugin.stopscreenshare();
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: ShareScreenDialog(),
                        ),
                        barrierColor: Colors.transparent,
                        // transitionDuration: const Duration(
                        //   milliseconds: 400,
                        // ),
                      );
                    }
                  },
                  icon: Image.asset(
                    package: "konn3ctsdk",
                    'asset/image/share_screen_icon.png',
                  ),
                  color: Colors.white,
                  style: const ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(width: 1, color: Colors.white),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromRGBO(34, 116, 81, 1),
                    ),
                  ),
                ),
              InkWell(
                onTap: () {
                  if (websocket
                          .meetingResponse
                          ?.fields
                          .lockSettingsProps
                          .disableMic ??
                      false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Your Microphone has been disabled by the Moderator",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  controller.ismuted = !controller.ismuted;
                  controller.bigbluebuttonsdkPlugin.mutemyself();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color:
                        controller
                                .bigbluebuttonsdkPlugin
                                .mydetails
                                ?.fields
                                ?.muted ==
                            true
                        ? Color(0xffCC525F)
                        : Color(0xff3E8466),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    controller
                                .bigbluebuttonsdkPlugin
                                .mydetails
                                ?.fields
                                ?.muted ==
                            true
                        ? Icons.mic_off_outlined
                        : Icons.mic_none_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton.filled(
                onPressed: () {
                  if (websocket
                          .meetingResponse
                          ?.fields
                          .lockSettingsProps
                          .disableCam ??
                      false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Your Camera has been disabled by the Moderator",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (controller.bigbluebuttonsdkPlugin.isvideo) {
                    controller.bigbluebuttonsdkPlugin.stopcamera();
                  } else {
                    controller.bigbluebuttonsdkPlugin.startcamera();
                  }
                },
                icon: Icon(
                  controller.bigbluebuttonsdkPlugin.isvideo
                      ? Icons.videocam_outlined
                      : Icons.videocam_off_outlined,
                ),
                style: ButtonStyle(
                  side: WidgetStatePropertyAll(
                    BorderSide(width: 1, color: Colors.white),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    controller.bigbluebuttonsdkPlugin.isvideo
                        ? Color.fromRGBO(34, 116, 81, 1)
                        : Color(0xffCC525F),
                  ),
                ),
                color: Colors.white,
              ),
              IconButton.filled(
                onPressed: () {
                  if (controller.scaffoldKey.currentState!.isDrawerOpen) {
                    controller.scaffoldKey.currentState!.closeEndDrawer();
                  } else {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  }
                },
                icon: const Icon(Icons.more_vert_rounded),
                style: const ButtonStyle(
                  side: WidgetStatePropertyAll(
                    BorderSide(width: 1, color: Colors.white),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(34, 116, 81, 1),
                  ),
                ),
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}
