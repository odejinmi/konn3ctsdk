import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/changeroledialog.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/removeuserdialog.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/ParticipantController.dart';

import 'chat.dart';

class ParticipantsDialog extends GetView<ParticipantController> {
  const ParticipantsDialog({super.key});

  // String _selectedItem = 'Change Role';

  @override
  Widget build(BuildContext context) {
    controller.sortParticipants();
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(top: 90),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: const BoxDecoration(color: Color.fromRGBO(62, 139, 102, 1)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Participants',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),

                const SizedBox(width: 20),

                Container(
                  width: 150,
                  height: 38,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.selectedItem != null ? controller.selectedItem["name"] : "Everyone"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      PopupMenuButton<dynamic>(
                        color: const Color.fromRGBO(93, 149, 126, 1),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        itemBuilder: (BuildContext context) {
                          // final user = usersList[index];
                          return controller.menuItems.map((item) {
                            return PopupMenuItem<dynamic>(
                              value: item,
                              child: Row(
                                children: [
                                  Icon(item['icon'], color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    item['name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        onSelected: (dynamic value) {
                          controller.selectedItem = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: "Find who you're looking for",
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color.fromRGBO(93, 149, 126, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                // shrinkWrap: true,
                itemCount: controller.sortedParticipants.length,
                itemBuilder: (BuildContext context, int index) {
                  final participan = controller.sortedParticipants[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(participan.fields!.avatar!),
                    ),
                    title: Text(
                      participan.fields!.name!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      participan.fields!.role == "MODERATOR" ? 'Host' : 'Guest',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.bigbluebuttonsdkPlugin.muteauser(
                              userid: participan.fields!.userId!,
                            );
                          },
                          child: Icon(
                            participan.fields!.muted == true
                                ? Icons.mic_off_outlined
                                : Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),

                        if (controller
                                .bigbluebuttonsdkPlugin
                                .mydetails!
                                .fields!
                                .role ==
                            "MODERATOR")
                          GetBuilder<Websocket>(
                            builder: (logic) {
                              return PopupMenuButton(
                                color: const Color.fromRGBO(93, 149, 126, 1),
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onSelected: (value) {
                                  if (value == 1) {
                                    _showChangeRoleDialog(participan, context);
                                  } else if (value == 2) {
                                    controller.bigbluebuttonsdkPlugin.muteauser(
                                      userid: participan.fields!.userId!,
                                    );
                                    // put function here
                                  } else if (value == 3) {
                                    if (logic
                                            .meetingResponse
                                            ?.fields
                                            ?.lockSettingsProps
                                            ?.disablePrivateChat ??
                                        false) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Your Private Chat has been disabled by the Moderator",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    if (participan.fields!.chatId == null) {
                                      controller.bigbluebuttonsdkPlugin
                                          .createGroupChat(
                                            participant: participan,
                                          );
                                    }
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      barrierColor: Colors.transparent,
                                      transitionDuration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) {
                                            return ChatDialog(
                                              participant: participan,
                                            );
                                          },
                                    );
                                    // put function here
                                  } else if (value == 4) {
                                    _showRemoveUserDialog(participan, context);
                                  }
                                },
                                itemBuilder: (BuildContext bc) {
                                  return [
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.repeat,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Change Role",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    PopupMenuItem(
                                      value: 2,
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.volume_mute,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            participan.fields!.muted == true
                                                ? "Unmute User"
                                                : "Mute User",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (participan.id !=
                                        controller
                                            .bigbluebuttonsdkPlugin
                                            .mydetails
                                            .id)
                                      PopupMenuItem(
                                        value: 3,
                                        onTap: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Private Chat",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (participan.id !=
                                        controller
                                            .bigbluebuttonsdkPlugin
                                            .mydetails
                                            .id)
                                      const PopupMenuItem(
                                        value: 4,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person_remove,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Remove User",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ];
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      );
    });
  }

  // =============Dialog to Roles of participants=======================
  _showChangeRoleDialog(Participant participan, BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Changeroledialog(participan: participan);
      },
    );
  }

  _showRemoveUserDialog(Participant participan, BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Removeuserdialog(participan: participan);
      },
    );
  }
}
