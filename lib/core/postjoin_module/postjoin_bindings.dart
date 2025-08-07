import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class postjoinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => postjoinController());
  }
}
