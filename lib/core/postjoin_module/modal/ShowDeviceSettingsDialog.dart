import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../postjoin_controller.dart';

class ShowDeviceSettingsDialog extends StatelessWidget {
  const ShowDeviceSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<postjoinController>(
        builder: (logic) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() {
              print(logic.firstItemsDropdown.length);
              return Container(
                height: 670,
                padding: const EdgeInsets.only(
                  top: 24,
                  right: 16,
                  bottom: 24,
                  left: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(62, 132, 102, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          iconSize: 24,
                          color: Colors.white,
                        ),
                        const Text(
                          'Device Settings',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                          iconSize: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 16,
                            bottom: 12,
                            left: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(93, 149, 126, 1),
                            // border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<MediaDeviceInfo>(
                                    dropdownColor: const Color.fromRGBO(
                                      62,
                                      132,
                                      102,
                                      1,
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                    value: logic.firstDropdownValue,
                                    items: logic.firstItemsDropdown.map((
                                      MediaDeviceInfo items,
                                    ) {
                                      return DropdownMenuItem<MediaDeviceInfo>(
                                        value: items,
                                        child: Text(
                                          items.label,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      logic.firstDropdownValue = newValue!;
                                      logic.bigbluebuttonsdkPlugin
                                          .switchVideocamera(
                                            deviceid: newValue.deviceId,
                                          );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video Quality',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 16,
                            bottom: 12,
                            left: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(93, 149, 126, 1),
                            // border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: const Color.fromRGBO(
                                      62,
                                      132,
                                      102,
                                      1,
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                    value: logic.secondDropdownValue.toString(),
                                    items: logic.secondItemsDropdown.map((
                                      String items,
                                    ) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      logic.secondDropdownValue = newValue!;
                                      // logic.bigbluebuttonsdkPlugin.getVideoWithQuality(width: 10, height: 11, frameRate: 30);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Microphone',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 16,
                            bottom: 12,
                            left: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(93, 149, 126, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.mic_none_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<MediaDeviceInfo>(
                                    dropdownColor: const Color.fromRGBO(
                                      62,
                                      132,
                                      102,
                                      1,
                                    ),
                                    value: logic.thirdDropdownValue,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                    items: logic.thirdItemsDropdown.map((
                                      MediaDeviceInfo items,
                                    ) {
                                      return DropdownMenuItem<MediaDeviceInfo>(
                                        value: items,
                                        child: Text(
                                          items.label,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      print(newValue);
                                      logic.thirdDropdownValue = newValue!;
                                      logic.bigbluebuttonsdkPlugin
                                          .switchmicrophone(
                                            deviceid: newValue.deviceId,
                                          );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
