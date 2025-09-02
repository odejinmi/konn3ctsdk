import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';

class Floatingscreen extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Obx(() {
      controller.check;
      return Scaffold(
        key: controller.scaffoldKey,
        body: GetBuilder<Websocket>(
          builder: (logic) {
            if (controller.iswhiteboard) {
              controller.presentationcontroller.slideposition =
                  logic.currentSlide["fields"]["num"];
              if (logic.presentationModel.isNotEmpty &&
                  controller
                      .presentationcontroller
                      .selecttoupload
                      .name
                      .isEmpty) {
                var selectedFile = logic.presentationModel.where((v) {
                  return v.fields!.current == true;
                }).toList();

                if (selectedFile.isNotEmpty) {
                  controller.presentationcontroller.selecttoupload =
                      PlatformFile(
                        name: selectedFile.last.fields!.name!,
                        size: 0,
                      );
                } else {
                  // Handle case where no item is found, if necessary
                  print("No presentation model with current == true found.");
                }
              }
              return controller.bigbluebuttonsdkPlugin.whiteboard();
            } else {
              var participants = logic.participant;
              if (participants.length <= 2) {
                return Container(
                  color: Color(0xFF1C1C1E), // Dark background
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < participants.length; i++)
                          ProfileAvatar(participant: participants[i]),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  color: Color(0xFF1C1C1E), // Dark background
                  child: Center(
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProfileAvatar(participant: participants[0]),
                            ProfileAvatar(participant: participants[1]),
                          ],
                        ),
                        // SizedBox(height: 60),
                        // Add button at bottom
                        Positioned(
                          bottom: 0,
                          right: 3,
                          child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '+${participants.length - 2}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      );
    });
  }
}

class ProfileAvatar extends StatelessWidget {
  final Participant participant;

  const ProfileAvatar({Key? key, required this.participant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
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
                      return Container(
                        color: Colors.grey.shade600,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                participant.fields!.name!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: participant.fields!.muted == true
                    ? Color(0xffCC525F)
                    : Colors.grey.shade600,
                shape: BoxShape.circle,
              ),
              child: Icon(
                participant.fields!.muted == true
                    ? Icons.mic_off_sharp
                    : Icons.mic_sharp,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
