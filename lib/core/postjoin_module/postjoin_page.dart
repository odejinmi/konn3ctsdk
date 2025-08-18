import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/meetingscreen/floatingscreen.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/endroom.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/leavesession.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';

import 'meetingscreen/fullmeetingscreen.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class postjoinPage extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    controller.context = context;
    if (GetPlatform.isAndroid) {
      controller.enablePip(autoEnable: true, context: context);
    }
    return Obx(() {
      controller.zoomLevel;
      return PopScope(
        canPop: !controller
            .hasUnsavedChanges, // Prevents popping if unsaved changes exist
        onPopInvoked: (didPop) async {
          if (!didPop && controller.hasUnsavedChanges) {
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
          }
        },
        child: Center(
          child: GetPlatform.isAndroid
              ? PiPSwitcher(
                  childWhenDisabled: Scaffold(
                    body: Fullmeetingscreen(),
                    // floatingActionButtonLocation:
                    // FloatingActionButtonLocation.centerFloat,
                    // floatingActionButton: FutureBuilder<bool>(
                    //   future: controller.floating.isPipAvailable,
                    //   initialData: false,
                    //   builder: (context, snapshot) => snapshot.data ?? false
                    //       ? Column(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       FloatingActionButton.extended(
                    //         onPressed: () => controller.enablePip(context),
                    //         label: const Text('Enable PiP'),
                    //         icon: const Icon(Icons.picture_in_picture),
                    //       ),
                    //       const SizedBox(height: 12),
                    //       FloatingActionButton.extended(
                    //         onPressed: () => controller.enablePip(context, autoEnable: true),
                    //         label: const Text('Enable PiP on app minimize'),
                    //         icon: const Icon(Icons.auto_awesome),
                    //       ),
                    //     ],
                    //   )
                    //       : const Card(
                    //     child: Text('PiP unavailable'),
                    //   ),
                    // ),
                  ),
                  childWhenEnabled: Floatingscreen(),
                )
              : Fullmeetingscreen(),
        ),
      );
    });
  }
}
