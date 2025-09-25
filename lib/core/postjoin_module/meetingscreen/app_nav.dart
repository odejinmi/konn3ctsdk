import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/activedonation.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/makedonation.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:konn3ctsdk/core/utils/dialogs/caption.dart';
import 'package:konn3ctsdk/core/utils/dialogs/end_recording_dialog.dart';
import 'package:share_plus/share_plus.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
    : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class AppNav extends GetView<postjoinController>
    implements PreferredSizeWidget {
  final double? elevation;

  final PreferredSizeWidget? bottom;

  final double? toolbarHeight;
  AppNav({super.key, this.elevation, this.toolbarHeight, this.bottom})
    : assert(elevation == null || elevation >= 0.0),
      preferredSize = _PreferredAppBarSize(
        toolbarHeight,
        bottom?.preferredSize.height,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(34, 116, 81, 1),
      leading: IconButton.outlined(
        onPressed: () {
          if (controller.meetingdetails.customdata.isNotEmpty) {
            Share.share(
              controller.meetingdetails.customdata[0]["meetingLink"],
              subject: 'Share Message',
            );
            // Clipboard.setData(
            //   ClipboardData(
            //     text:
            //         controller.meetingdetails.customdata[0]["meetingLink"],
            //   ),
            // );
          }
        },
        icon: Image.asset(package: "konn3ctsdk", 'asset/image/share_link.png'),
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
      title: Row(
        children: [
          controller.donationcontroller.donate &&
                  controller.bigbluebuttonsdkPlugin.isrecording
              ? IconButton.filled(
                  onPressed: () {
                    endRecordingDialog(context);
                  },
                  icon: const Icon(Icons.radio_button_checked),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromRGBO(204, 82, 95, 1),
                    ),
                  ),
                  color: Colors.white,
                )
              : controller.bigbluebuttonsdkPlugin.isrecording
              ? Container(
                  width: 136,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(204, 82, 95, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.white,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          endRecordingDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color.fromRGBO(204, 82, 95, 1),
                        ),
                        child: const Center(
                          child: Text(
                            'End Recording',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          controller.donationcontroller.donate &&
                  controller.bigbluebuttonsdkPlugin.isrecording
              ? InkWell(
                  onTap: () {
                    if (controller.bigbluebuttonsdkPlugin.mydetails != null &&
                        controller
                            .bigbluebuttonsdkPlugin
                            .mydetails!
                            .fields!
                            .presenter!) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Color(0xFF3E8466),
                          content: Activedonation(),
                        ),
                      );
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Color(0xFF3E8466),
                          content: Makedonation(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(34, 116, 81, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Icon(
                      Icons.attach_money_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              : controller.donationcontroller.donate
              ? InkWell(
                  onTap: () {
                    if (controller.bigbluebuttonsdkPlugin.mydetails != null &&
                        controller
                            .bigbluebuttonsdkPlugin
                            .mydetails!
                            .fields!
                            .presenter!) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Color(0xFF3E8466),
                          content: Activedonation(),
                        ),
                      );
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Color(0xFF3E8466),
                          content: Makedonation(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 90,
                    height: 40,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(34, 116, 81, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.attach_money_rounded, color: Colors.white),
                        Text(
                          'Donate',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      actions: [
        controller.captionButtonPressed
            ? InkWell(
                onTap: () {
                  controller.captionButtonPressed = false;
                },
                child: Container(
                  width: 75,
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 137, 109, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.closed_caption_off, color: Colors.white),
                      Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            : IconButton.filled(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => CaptionDialog(),
                    barrierColor: Colors.transparent,
                  );
                  controller.captionButtonPressed = true;
                },
                icon: const Icon(Icons.closed_caption_off),
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
        const SizedBox(width: 10),
        GetBuilder<Websocket>(
          builder: (logic) {
            return GestureDetector(
              onTap: () {
                if (logic
                        .meetingResponse
                        ?.fields
                        .lockSettingsProps
                        .hideUserList ??
                    false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Your Participants List has been disabled by the Moderator",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                controller.scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                width: 65,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(71, 137, 109, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.people_outline, color: Colors.white),
                    // Text('2', style: TextStyle(color: Colors.white,),)
                    Text(
                      (controller.bigbluebuttonsdkPlugin.participant.length)
                          .toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  // =============Dialog for Ending Recording Session=======================
  endRecordingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => EndRecordingDialog(),
      barrierColor: Colors.transparent,
    );
  }

  @override
  final Size preferredSize;
}
