import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/utils/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/meetingscreen/app_nav.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:konn3ctsdk/core/utils/dialogs/participant_dialog.dart';
import 'package:konn3ctsdk/core/utils/drawer.dart';

import '../../postjoin_module/modal/share_screen_card.dart';
import 'bottom_nav.dart';

class Fullmeetingscreen extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final manyscreensize = (screenWidth / 2) - 26;
    final orientation = MediaQuery.of(context).orientation;
    final logic = Get.find<Websocket>();
    return Obx(() {
      return Scaffold(
        key: controller.scaffoldKey,
        // backgroundColor: Color(0xffE5E5E5),
        appBar:
            logic.remoteRTCVideoRenderer.srcObject != null &&
                orientation == Orientation.landscape
            ? null
            : AppNav(),

        // ====================================Drawer===========================
        drawerEnableOpenDragGesture: true,
        endDrawer: const DrawerComp(),
        drawer: ParticipantsDialog(),

        // ====================================BottomAppBar===========================
        bottomNavigationBar:
            logic.remoteRTCVideoRenderer.srcObject != null &&
                orientation == Orientation.landscape
            ? null
            : BottomNav(),

        // ===========================================================================================
        backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
        body:
            logic.remoteRTCVideoRenderer.srcObject != null &&
                orientation == Orientation.landscape
            ? remotescreenshare(logic, orientation)
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // SizedBox(width: screenWidth * 2,),
                    Expanded(
                      child: Stack(
                        children: [
                          GetBuilder<Websocket>(
                            builder: (logic) {
                              if (logic.remoteRTCVideoRenderer.srcObject !=
                                  null) {
                                if (logic.isMeSharing) {
                                  return ShareScreenCard();
                                } else {
                                  return remotescreenshare(logic, orientation);
                                }
                              } else if (controller.iswhiteboard) {
                                controller
                                        .presentationcontroller
                                        .slideposition =
                                    logic.currentSlide["fields"]["num"];
                                if (logic.presentationModel.isNotEmpty &&
                                    controller
                                        .presentationcontroller
                                        .selecttoupload
                                        .name
                                        .isEmpty) {
                                  var selectedFile = logic.presentationModel
                                      .where((v) {
                                        return v.fields!.current == true;
                                      })
                                      .toList();

                                  if (selectedFile.isNotEmpty) {
                                    controller
                                        .presentationcontroller
                                        .selecttoupload = PlatformFile(
                                      name: selectedFile.last.fields!.name!,
                                      size: 0,
                                    );
                                  } else {
                                    // Handle case where no item is found, if necessary
                                    print(
                                      "No presentation model with current == true found.",
                                    );
                                  }
                                }
                                // controller
                                //     .selecttoupload = PlatformFile(name: logic.presentationmodel.where((v){return v.fields!.current == true;}).toList()[0].fields.name, size: 0);
                                return controller.bigbluebuttonsdkPlugin
                                    .whiteboard();
                              } else {
                                var participants = logic.participant;
                                if (participants.length <= 2) {
                                  return ListView.builder(
                                    itemCount: participants.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            _buildParticipantWidget(
                                              participants[index],
                                              342,
                                              285,
                                            ),
                                  );
                                } else {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: (participants.length + 1) ~/ 2,
                                    // Adjust the item count to account for pairing
                                    itemBuilder: (BuildContext context, int index) {
                                      // Odd number of participants, the first participant uses a larger size
                                      if (participants.length % 2 == 1 &&
                                          index == 0) {
                                        Participant participant =
                                            participants[0];
                                        return _buildParticipantWidget(
                                          participant,
                                          342,
                                          285,
                                        );
                                      } else {
                                        // Handle pairs of participants
                                        int firstIndex =
                                            participants.length % 2 == 1
                                            ? 1 + (index - 1) * 2
                                            : index * 2;
                                        int secondIndex = firstIndex + 1;

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _buildParticipantWidget(
                                              participants[firstIndex],
                                              manyscreensize,
                                              manyscreensize,
                                            ),
                                            if (secondIndex <
                                                participants.length)
                                              _buildParticipantWidget(
                                                participants[secondIndex],
                                                manyscreensize,
                                                manyscreensize,
                                              ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                }
                              }
                            },
                          ),
                          if (!controller.iswhiteboard)
                            Positioned(
                              right: screenWidth * 0.045,
                              top: screenHeight * 0.02,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (controller
                                          .meetingdetails
                                          .customdata
                                          .isNotEmpty) {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: controller
                                                .meetingdetails
                                                .customdata[0]["meetingLink"],
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Meeting Link copied",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: screenHeight * 0.04,
                                      width: screenWidth * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.link,
                                            color: Colors.green,
                                          ),
                                          const Divider(color: Colors.white),
                                          Expanded(
                                            child: Text(
                                              controller
                                                  .meetingdetails
                                                  .customdata[0]["meetingLink"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.037,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller
                                      .bigbluebuttonsdkPlugin
                                      .isrecording)
                                    SizedBox(width: screenWidth * 0.03),
                                  if (controller
                                      .bigbluebuttonsdkPlugin
                                      .isrecording)
                                    Container(
                                      height: screenHeight * 0.04,
                                      width: screenWidth * 0.24,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.camera,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            controller
                                                .bigbluebuttonsdkPlugin
                                                .recordingtime,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.037,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                          // Positioned(
                          //     right: screenWidth * 0.04,
                          //     bottom: screenHeight * 0.135,
                          //     child: CircleAvatar(
                          //       backgroundColor: Colors.grey[600],
                          //       child: const Icon(
                          //         Icons.more_horiz, color: Colors.white,),
                          //     )
                          // ),

                          // Positioned(
                          //   right: screenHeight * 0.02,
                          //   bottom: screenHeight * 0.03,
                          //   child: Container(
                          //     width: screenWidth * 0.84,
                          //     height: screenHeight * 0.09,
                          //     padding: const EdgeInsets.only(left: 12, right: 12,),
                          //     decoration: BoxDecoration(
                          //       color: Colors.grey[600],
                          //       borderRadius: const BorderRadius.all(
                          //           Radius.circular(12)),
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         const Icon(Icons.waves, color: Colors.white),
                          //         SizedBox(width: 10,),
                          //         Expanded(
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: [
                          //               Text('Now', style: TextStyle(color: Colors.white,
                          //                   fontSize: screenHeight * 0.017),),
                          //               Text(
                          //                 'Thank you everyone for joining the design criteque meeting',
                          //                 style: TextStyle(color: Colors.white,
                          //                     fontSize: screenHeight * 0.017),),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.02,),
                    GetBuilder<Websocket>(
                      builder: (logic) {
                        var participants = logic.participant;
                        return logic.remoteRTCVideoRenderer.srcObject != null ||
                                controller.iswhiteboard
                            ? SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: participants.length,
                                  itemBuilder: (context, index) {
                                    return _buildParticipantWidget(
                                      participants[index],
                                      123,
                                      123,
                                    );
                                  },
                                ),
                              )
                            : SizedBox();
                      },
                    ),
                  ],
                ),
              ),
      );
    });
  }

  // Helper function to build the participant widget
  Widget _buildParticipantWidget(
    Participant participant,
    double width,
    double height,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.green[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: participant.rtcVideoRenderer != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: RTCVideoView(
                      participant.rtcVideoRenderer!,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: participant.fields!.talking == true
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            participant.fields!.avatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                generateInitials(participant.fields!.name!),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.98),
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        participant.fields!.name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.98),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              // width: 70,
              height: 32,
              child: Row(
                children: [
                  if (participant.fields!.muted == true)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: Color(0xFFCC525F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                      child: Icon(Icons.mic_off_outlined, color: Colors.white),
                      alignment: Alignment.center,
                    ),
                  if (participant.fields!.raiseHand != null &&
                      participant.fields!.raiseHand!)
                    SizedBox(width: 5),
                  if (participant.fields!.raiseHand != null &&
                      participant.fields!.raiseHand!)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: Color(0x7A5D957E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.back_hand,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget remotescreenshare(logic, orientation) {
    return Obx(() {
      return Stack(
        children: [
          GestureDetector(
            onScaleStart: (details) {
              controller.previousScale = controller.scale;
              controller.previousOffset = controller.offset;
              controller.lastFocalPoint =
                  details.focalPoint; // Add this to your controller
            },
            onScaleUpdate: (details) {
              controller.scale = (controller.previousScale * details.scale)
                  .clamp(0.5, 4.0);

              // Better dragging using actual focal point movement
              if (controller.lastFocalPoint != null) {
                final delta = details.focalPoint - controller.lastFocalPoint!;
                controller.offset += delta;
                controller.lastFocalPoint = details.focalPoint;
              }
            },
            onScaleEnd: (details) {
              controller.lastFocalPoint = Offset.zero;
            },
            onDoubleTap: () {
              if (controller.scale > 1.0) {
                controller.scale = 1.0;
                controller.offset = Offset.zero;
              } else {
                controller.scale = 2.0;
              }
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(controller.offset.dx, controller.offset.dy)
                  ..scale(controller.scale),
                alignment: Alignment.center,
                child: RTCVideoView(logic.remoteRTCVideoRenderer),
              ),
            ),
          ),
          Positioned(
            top: orientation == Orientation.landscape ? 10 : 150,
            right: orientation == Orientation.landscape ? 110 : 10,
            child: InkWell(
              child: Image.asset(
                package: "konn3ctsdk",
                'asset/image/fullscreen_icon.png',
              ),
              onTap: () {
                // logic.fullscreen();
                if (orientation == Orientation.landscape) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                }
                print("Fullscreen");
              },
            ),
          ),
        ],
      );
    });
  }
}
