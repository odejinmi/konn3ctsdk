import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_page.dart';
import 'package:konn3ctsdk/core/prejoin_page.dart';

class Konn3ct extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    // return buildDefault(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      body: Obx(() {
        return controller.stage == 0
            ? prejoinPage()
            : controller.stage == 1
            ? postjoinPage()
            : Container();
      }),
    );
  }
}
