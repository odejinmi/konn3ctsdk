// import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/modal/presentation.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:konn3ctsdk/core/utils/dialogs/ai_chat.dart';
import 'package:konn3ctsdk/core/utils/dialogs/cinema.dart';
import 'package:konn3ctsdk/core/utils/dialogs/donations_dialog.dart';
import 'package:konn3ctsdk/core/utils/dialogs/polls_dialog.dart';
import 'package:konn3ctsdk/core/utils/dialogs/settings.dart';

import '../postjoin_module/modal/howLayoutSettingsDialog.dart';
import 'dialogs/chat.dart';

class DrawerComp extends StatefulWidget {
  const DrawerComp({super.key});

  @override
  State<DrawerComp> createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 94),
      child: Drawer(
        backgroundColor: const Color.fromRGBO(62, 132, 102, 1),
        width: 230,
        child: GetBuilder<postjoinController>(
          builder: (postjoincontroller) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 15),
                // if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                //         null &&
                //     postjoincontroller
                //             .bigbluebuttonsdkPlugin
                //             .mydetails!
                //             .fields!
                //             .role ==
                //         "MODERATOR")
                //   Column(
                //     children: [
                //       ListTile(
                //         leading: const Icon(
                //           Icons.radio_button_checked,
                //           size: 20,
                //         ),
                //         title: const Text(
                //           'Breakout Room',
                //           style: TextStyle(
                //             fontWeight: FontWeight.w500,
                //             fontSize: 14,
                //             color: Colors.white,
                //           ),
                //         ),
                //         iconColor: Colors.white,
                //         onTap: () {
                //           Navigator.pop(context);
                //         },
                //       ),
                //       const Divider(),
                //     ],
                //   ),
                if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                        null &&
                    postjoincontroller
                            .bigbluebuttonsdkPlugin
                            .mydetails!
                            .fields!
                            .role ==
                        "MODERATOR")
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.radio_button_checked,
                          size: 20,
                        ),
                        title: Text(
                          '${postjoincontroller.bigbluebuttonsdkPlugin.isrecording ? 'Stop' : 'Start'} Recording',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        iconColor: Colors.white,
                        onTap: () {
                          postjoincontroller.bigbluebuttonsdkPlugin
                              .toggleRecording();
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                GetBuilder<Websocket>(
                  builder: (logic) {
                    return ListTile(
                      leading: const Icon(Icons.chat_bubble_outline, size: 20),
                      title: const Text(
                        'Chat',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      iconColor: Colors.white,
                      onTap: () {
                        Navigator.pop(context);
                        if (logic
                                .meetingResponse
                                ?.fields
                                .lockSettingsProps
                                .disablePublicChat ??
                            false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Your Public Chat has been disabled by the Moderator",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.transparent,
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return ChatDialog();
                              },
                        );
                        // Get.bottomSheet(Container(), isScrollControlled: true);
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    package: "konn3ctsdk",
                    'asset/image/change_layout_icon.png',
                  ),
                  title: const Text(
                    'Change Layout',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  ),
                  iconColor: Colors.white,
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const ShowLayoutSettingsDialog();
                      },
                    );
                  },
                ),
                // ListTile(
                //   leading: Image.asset(
                //     package: "konn3ctsdk",
                //     'asset/image/fullscreen_icon.png',
                //   ),
                //   title: const Text(
                //     'Go Fullscreen',
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 14,
                //       color: Colors.white,
                //     ),
                //   ),
                //   iconColor: Colors.white,
                //   onTap: () {},
                // ),
                ListTile(
                  leading: const Icon(Icons.monitor_rounded, size: 20),
                  title: const Text(
                    'White Board',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  iconColor: Colors.white,
                  onTap: () {
                    postjoincontroller.iswhiteboard =
                        !postjoincontroller.iswhiteboard;
                  },
                ),
                // if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                //         null &&
                //     postjoincontroller
                //         .bigbluebuttonsdkPlugin
                //         .mydetails!
                //         .fields!
                //         .presenter!)
                ListTile(
                  leading: const Icon(Icons.folder_open_rounded, size: 20),
                  title: const Text(
                    'Upload Files',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  iconColor: Colors.white,
                  onTap: () async {
                    Navigator.pop(context);
                    Get.bottomSheet(
                      Presentation(),
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF3E8466),
                    );

                    // showGeneralDialog(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     barrierColor: Colors.transparent,
                    //     transitionDuration: const Duration(milliseconds: 400),
                    //     pageBuilder: (context, animation, secondaryAnimation) {
                    //       return const Presentation();
                    //     }
                    // );
                  },
                ),
                SwitchListTile(
                  title: Text(
                    'Raise Hand',
                    style: TextStyle(
                      color:
                          postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                                  null &&
                              postjoincontroller
                                  .bigbluebuttonsdkPlugin
                                  .mydetails!
                                  .fields!
                                  .raiseHand!
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                  secondary: Icon(
                    Icons.back_hand_outlined,
                    color:
                        postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                                null &&
                            postjoincontroller
                                .bigbluebuttonsdkPlugin
                                .mydetails!
                                .fields!
                                .raiseHand!
                        ? Colors.white
                        : Colors.grey,
                  ),
                  activeColor: Colors.white,
                  thumbColor: const MaterialStatePropertyAll(Colors.white),
                  inactiveThumbColor: Colors.white,
                  trackColor: const MaterialStatePropertyAll(
                    Color.fromRGBO(93, 149, 126, 1),
                  ),
                  inactiveTrackColor: const Color.fromRGBO(62, 132, 102, 1),
                  value:
                      postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                          null &&
                      postjoincontroller
                          .bigbluebuttonsdkPlugin
                          .mydetails!
                          .fields!
                          .raiseHand!,
                  onChanged: (newValue) {
                    Navigator.pop(context);
                    if (postjoincontroller
                        .bigbluebuttonsdkPlugin
                        .mydetails!
                        .fields!
                        .raiseHand!) {
                      postjoincontroller.bigbluebuttonsdkPlugin.lowerHand();
                    } else {
                      postjoincontroller.bigbluebuttonsdkPlugin.raiseHand();
                    }
                  },
                ),

                if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                        null &&
                    postjoincontroller
                            .bigbluebuttonsdkPlugin
                            .mydetails!
                            .fields!
                            .role ==
                        "MODERATOR")
                  ListTile(
                    leading: const Icon(Icons.mic_off_outlined, size: 20),
                    title: const Text(
                      'Mute All',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    iconColor: Colors.white,
                    onTap: () async {
                      var response = await postjoincontroller.bigbluebuttonsdkPlugin.muteallusers();
                      print("mute all response");
                      print(response);
                      Navigator.pop(context);
                    },
                  ),

                if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                        null &&
                    postjoincontroller
                        .bigbluebuttonsdkPlugin
                        .mydetails!
                        .fields!
                        .presenter!)
                  ListTile(
                    leading: Image.asset(
                      package: "konn3ctsdk",
                      'asset/image/polls_icon.png',
                    ),
                    title: const Text(
                      'Polls',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    iconColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Colors.transparent,
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return PollsDialog();
                        },
                      ).then((_) {
                        // This runs after bottom sheet is dismissed
                        var controller = postjoincontroller.pullcontroller;
                        controller.question.value = "";
                        controller.options.value = ['Option 1'];
                      });
                    },
                  ),
                // ListTile(
                //   leading: Image.asset(
                //     package: "konn3ctsdk",
                //     'asset/image/polls_icon.png',
                //   ),
                //   title: const Text(
                //     'Virtual background',
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 14,
                //       color: Colors.white,
                //     ),
                //   ),
                //   iconColor: Colors.white,
                //   onTap: () {
                //     Navigator.pop(context);
                //     Get.bottomSheet(
                //       Virtualbackgroundviews(),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(
                //             30,
                //           ), // Curving the top-left corner
                //           topRight: Radius.circular(
                //             30,
                //           ), // Curving the top-right corner
                //         ),
                //         side: BorderSide(width: 1, color: Color(0xFF3E8466)),
                //       ),
                //     );
                //   },
                // ),
                if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                        null &&
                    postjoincontroller
                            .bigbluebuttonsdkPlugin
                            .mydetails!
                            .fields!
                            .role ==
                        "MODERATOR")
                  ListTile(
                    leading: const Icon(Icons.attach_money_rounded, size: 20),
                    title: const Text(
                      'Donation',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    iconColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      if (postjoincontroller.donationcontroller.donate) {
                        SnackBar(
                          content: Text(
                            "You still have an active donation",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                        return;
                      }
                      _showDonationsDialog();
                    },
                  ),

                if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
                        null &&
                    postjoincontroller
                        .bigbluebuttonsdkPlugin
                        .mydetails!
                        .fields!
                        .presenter!)
                  ListTile(
                    leading: const Icon(Icons.movie_outlined, size: 20),
                    title: const Text(
                      'E-Cinema',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    iconColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      _showCinemaDialog();
                    },
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.smart_toy_sharp),
                  title: const Text(
                    'Konn3ct AI',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  iconColor: Colors.white,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showAIChatDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, size: 20),
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  iconColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsDialog();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =============Dialog for showing Donations=======================
  _showDonationsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const DonationsDialog();
      },
    );
  }

  // =============Dialog for Settings section=======================
  _showSettingsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ShowDeviceSettingsDialog();
      },
    );
  }

  _showAIChatDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AiChat();
      },
    );
  }

  _showCinemaDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Cinema();
      },
    );
  }
}
