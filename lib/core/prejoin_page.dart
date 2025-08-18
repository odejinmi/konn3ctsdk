import 'package:bigbluebuttonsdk/utils/strings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:konn3ctsdk/core/utils/dialogs/prejoin_device_settings_dialog.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class prejoinPage extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    controller.context = context;
    // return buildDefault(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      body: Obx(() {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: const Color.fromRGBO(229, 229, 229, 1),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Setup your audio and video before joining',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),

                    // Image.asset(package: "konn3ctsdk",
                    //   "asset/image/Video Tile.jpg",
                    //   fit: BoxFit.cover,
                    //   frameBuilder: (context, child, frame, _) {
                    //     if (frame == null) {
                    //       return child;
                    //     }else {
                    //       return const Center(
                    //         child: CircularProgressIndicator(
                    //           valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ),
                    const SizedBox(height: 10),
                    Container(
                      width: 342,
                      height: 264,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(185, 201, 194, 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: controller.isvideo
                          ? SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Center(
                                    child: AspectRatio(
                                      aspectRatio: controller
                                          .cameracontroller!
                                          .value
                                          .aspectRatio,
                                      child: CameraPreview(
                                        controller.cameracontroller!,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 1,
                                    child: Icon(Icons.wifi_2_bar_rounded),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Center(
                                  child: SizedBox(
                                    width: 144,
                                    height: 144,
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Color.fromRGBO(
                                        147,
                                        179,
                                        165,
                                        1,
                                      ),
                                      child: Text(
                                        generateInitials(
                                          controller.usernameController.text,
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 48,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    controller.usernameController.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 15),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton.filled(
                              onPressed: () {
                                controller.isaudio = !controller.isaudio;
                              },
                              icon: const Icon(Icons.mic_none),
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  controller.isaudio
                                      ? Color.fromRGBO(71, 137, 109, 1)
                                      : Color.fromRGBO(185, 201, 194, 1),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            IconButton.filled(
                              onPressed: () async {
                                if (GetPlatform.isAndroid ||
                                    GetPlatform.isIOS) {
                                  if (controller.isvideo) {
                                    controller.isvideo = await controller
                                        .closeCamera();
                                  } else {
                                    controller.isvideo = await controller
                                        .startCamera();
                                  }
                                }
                              },
                              icon: const Icon(Icons.videocam_off_outlined),
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  controller.isvideo
                                      ? Color.fromRGBO(71, 137, 109, 1)
                                      : Color.fromRGBO(185, 201, 194, 1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),
                        IconButton.filled(
                          onPressed: () {
                            settingsDialog(context);
                          },
                          icon: const Icon(Icons.settings_outlined),
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(185, 201, 194, 1),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    controller.iswaiting == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(211, 213, 218, 1),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color.fromRGBO(
                                      93,
                                      149,
                                      126,
                                      1,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.only(left: 5.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Meeting ID or Meeting Link',
                                  ),
                                  controller: controller.meetingnameController,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          211,
                                          213,
                                          218,
                                          1,
                                        ),
                                        border: Border.all(
                                          width: 1,
                                          color: const Color.fromRGBO(
                                            93,
                                            149,
                                            126,
                                            1,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Akanji J',
                                          ),
                                          controller:
                                              controller.usernameController,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          211,
                                          213,
                                          218,
                                          1,
                                        ),
                                        border: Border.all(
                                          width: 1,
                                          color: const Color.fromRGBO(
                                            93,
                                            149,
                                            126,
                                            1,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'joseph@gmail.com',
                                        ),
                                        controller: controller.emailController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Visibility(
                                visible: controller.accesscode,
                                child: TextFormField(
                                  textAlign: TextAlign.start,
                                  controller: controller.accesscodeController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // focusColor: Colors.white,
                                    // hoverColor: Colors.white,
                                    // fillColor: Colors.white,
                                    hintText: "Enter Access code here",
                                    border: InputBorder.none,
                                    // prefix: !change ? const Text("+(234)") : const Text(""),
                                    hintStyle: TextStyle(
                                      // color: primarycolour,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    // suffixIcon: Icon(
                                    //   Icons.person_pin_circle_rounded,
                                    //   color: Colors.white,
                                    // ),
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderRadius:
                                    //       BorderRadius.all(Radius.circular(8.0)),
                                    //   borderSide: BorderSide(color: Colors.grey),
                                    // ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderRadius:
                                    //       BorderRadius.all(Radius.circular(8.0)),
                                    //   borderSide: BorderSide(color: Colors.grey),
                                    // ),
                                    // disabledBorder: OutlineInputBorder(
                                    //   borderRadius:
                                    //       BorderRadius.all(Radius.circular(8.0)),
                                    //   borderSide: BorderSide(color: Colors.grey),
                                    // ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    // color: primaryColour,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (controller.accesscode) {
                                      if (value == null) {
                                        return "This field can't be empty";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: Container(
                                      width: 176,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          62,
                                          132,
                                          102,
                                          1,
                                        ),
                                        // border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!controller.isLoading &&
                                              controller.formKey.currentState!
                                                  .validate()) {
                                            if (controller.isstartroom) {
                                              controller.Meetingstart();
                                            } else {
                                              controller.validateMeeting();
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor: const Color.fromRGBO(
                                            62,
                                            132,
                                            102,
                                            1,
                                          ),
                                        ),
                                        child: Center(
                                          child: controller.isLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  'Konn3ct',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 10,),
                                ],
                              ),
                              SizedBox(height: 30),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hey ${controller.usernameController.text}, someone in the meeting should let you in soon',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),

                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Container(
                                  width: 176,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      62,
                                      132,
                                      102,
                                      1,
                                    ),
                                    // border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.isleaving = true;
                                      Navigator.pop(
                                        context,
                                        controller.isleaving,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: const Color.fromRGBO(
                                        62,
                                        132,
                                        102,
                                        1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Leave',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  settingsDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Scaffold(
        // backgroundColor: const Color.fromRGBO(0, 0, 0, 0.76),
        body: Center(
          child: Container(
            width: 360,
            height: 664,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(62, 132, 102, 1),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),

                      const SizedBox(width: 180),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const PreJoin()
                          //     )
                          // );
                        },
                        icon: const Icon(Icons.clear_rounded),
                        iconSize: 24,
                        color: Colors.white,
                        // style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(185, 201, 194, 1)))
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(),

                  const SizedBox(height: 20),
                  Container(
                    width: 328,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(93, 149, 126, 1),
                      // border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FilledButton(
                      onPressed: () {
                        deviceSettingsDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color.fromRGBO(93, 149, 126, 1),
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined, color: Colors.white),
                            SizedBox(width: 30),
                            Text(
                              'Device Settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      // barrierLabel: ' Full Screen Dialog',
      // transitionDuration: const Duration(milliseconds: 400),
    );
  }

  deviceSettingsDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => DeviceSettings(),
      // barrierDismissible: false,
      barrierColor: Colors.transparent,
      // transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
