import 'dart:async';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dialogs/web_view_modal.dart';
import '../diorequest.dart';

class DonationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _roomdetails = {}.obs;
  set roomdetails(value) => _roomdetails.value = value;
  get roomdetails => _roomdetails.value;
  final _token = ''.obs;
  set token(value) => _token.value = value;
  get token => _token.value;

  Timer? _timer;

  final _amounttodonate = ''.obs;
  set amounttodonate(value) => _amounttodonate.value = value;
  get amounttodonate => _amounttodonate.value;

  final _donatedamount = ''.obs;
  set donatedamount(value) => _donatedamount.value = value;
  get donatedamount => _donatedamount.value;

  final _check = false.obs;
  set check(value) => _check.value = value;
  get check => _check.value;

  final _meetingdetails = Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  Meetingdetails? get meetingdetails => _meetingdetails.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  final donationdescriptionController = TextEditingController();
  final donationuniquenumberController = TextEditingController();

  void init(var meetingdetails, var token, var roomdetails) {
    this.token = token;
    this.roomdetails = roomdetails;
    this.meetingdetails = meetingdetails;
    checkdonation();
    // Set up a timer to call checkdonation() every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // obj = "";
      checkdonation();
    });
  }

  var _selectedValue = Rx<int?>(null);
  int? get selectedValue => _selectedValue.value;
  set selectedValue(int? value) => _selectedValue.value = value;
  bool flashEnabled = false; // Tracks the checkbox state

  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk.instance;
  final donationNameController = TextEditingController();
  final donationamountController = TextEditingController();

  var isLoading = false;

  var formKey = GlobalKey<FormState>();

  final _donationdetails = [].obs;
  set donationdetails(value) => _donationdetails.value = value;
  get donationdetails => _donationdetails.value;

  final _donate = false.obs;
  set donate(value) => _donate.value = value;
  get donate => _donate.value;

  void createdonation() async {
    isLoading = true;
    var json_body;
    json_body = {
      "name": donationNameController.text,
      "type": _selectedValue,
      "amount": donationamountController.text,
      "id": roomdetails['id'],
      "enableFLashNotification": flashEnabled ? 1 : 0,
    };

    var cmddetails = await Diorequest().post("k4/donation", json_body, token);

    isLoading = false;

    print("create cmddetails");
    print(cmddetails);
    if (cmddetails['success']) {
      donate = true;
      bigbluebuttonsdkPlugin.sendmessage(
        chatid: "MAIN-PUBLIC-GROUP-CHAT",
        message: "Donation created|${donationNameController.text}|2|10000000|7",
      );
      bigbluebuttonsdkPlugin.stoptyping();
      // {"success":true,"message":"Donation created successfully","data":22}
      donationdetails = [
        {"id": cmddetails["data"]},
      ];
      // ["{\"msg\":\"method\",\"id\":\"428\",\"method\":\"sendGroupChatMsg\",\"params\":[\"MAIN-PUBLIC-GROUP-CHAT\",{\"correlationId\":\"w_nidxlpogyafr-1728639206402\",\"sender\":{\"id\":\"w_nidxlpogyafr\",\"name\":\"\",\"role\":\"\"},\"chatEmphasizedText\":true,\"message\":\"Donation created|help the needy|2|10000000|7\"}]}"]
      // ["{\"msg\":\"method\",\"id\":\"429\",\"method\":\"stopUserTyping\",\"params\":[]}"]
    } else {
      // isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void enddonation() async {
    var json_body;
    json_body = {"status": 0};

    var cmddetails = await Diorequest().patch(
      "k4/donation/${donationdetails[0]["id"]}",
      json_body,
      token,
    );
    // print("donation cmddetails patch");
    // print(cmddetails);
    // var cmddetails = await Diorequest().get("start-a-room/$id");

    if (cmddetails['success']) {
      donate = false;
    } else {}
  }

  void paydonation() async {
    // Get.back();
    Get.defaultDialog(title: "Loading", content: CircularProgressIndicator());
    isLoading = true;
    var json_body = {
      "name": check ? "Anonymous" : meetingdetails!.fullname,
      "email": meetingdetails!.externUserId,
      "amount": donationamountController.text,
      "id": meetingdetails!.internalUserId,
      "meetid": roomdetails['id'].toString(),
      "description": donationdescriptionController.text,
    };

    var cmddetails = await Diorequest().post(
      "k4/donation/pay/${donationdetails[0]['id']}",
      json_body,
      token,
    );

    isLoading = false;
    Get.back();
    if (cmddetails['success']) {
      var reference = cmddetails['reference'];
      final Uri _url = Uri.parse(cmddetails['data']);
      // if (!await launchUrl(_url)) {
      //   throw Exception('Could not launch $_url');
      // }
      _openWebViewModal(Get.context!, cmddetails['data'], reference);
    } else {
      // isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void checkdonation() async {
    var cmddetails = await Diorequest().get(
      "k4/donation/${roomdetails['id']}",
      token,
    );
    if (cmddetails["success"]) {
      if (cmddetails["data"].isNotEmpty) {
        donate = true;
        donationdetails = cmddetails["data"];
        donatedamount = cmddetails["donated_amount"].toString();
      } else {
        donate = false;
      }
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {}
  }

  void checkdonationpayment(String reference) async {
    var cmddetails = await Diorequest().get(
      "k4/donation/ref/$reference",
      token,
    );
    print("donation cmddetails");
    print(cmddetails);
    if (cmddetails["success"]) {
      if (cmddetails["data"] == 0) {
        // checkdonationpayment(reference);
      }
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {}
  }

  void _openWebViewModal(BuildContext context, String url, String reference) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: WebViewModal(url: url),
      ),
    ).then((value) {
      checkdonationpayment(reference);
    });

    // Alternative: Full screen modal
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const WebViewModal(
    //       url: 'https://flutter.dev',
    //     ),
    //     fullscreenDialog: true,
    //   ),
    // );
  }
}
