import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/utils/dialogs/cinema.dart';
import 'package:konn3ctsdk/core/utils/diorequest.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/DeviceSettingsController.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/ParticipantController.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/PresentationController.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/PullController.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/SwitchController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../utils/strings.dart';
import 'modal/pollsresult.dart';
import 'modal/pullquestionandanswer.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class postjoinController extends GetxController with WidgetsBindingObserver {
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final _context = Rx<BuildContext?>(null);
  set context(value) => _context.value = value;
  get context => _context.value;

  final _baseurl = 'meet.konn3ct.ng/'.obs;
  set baseurl(value) {
    entermeetingurl = 'https://${value}bigbluebutton/api/enter?sessionToken=';
    return _baseurl.value = value;
  }

  get baseurl => _baseurl.value;

  final _entermeetingurl = ''.obs;
  set entermeetingurl(value) => _entermeetingurl.value = value;
  get entermeetingurl => _entermeetingurl.value;

  final _token = ''.obs;
  set token(value) => _token.value = value;
  get token => _token.value;

  var pullcontroller = Get.put(PullController());

  var presentationcontroller = Get.put(PresentationController());
  var participantcontroller = Get.put(ParticipantController());
  var deviceSettingscontroller = Get.put(DeviceSettingsController());
  var switchcontroller = Get.put(SwitchController());

  final _stage = 0.obs;
  set stage(value) {
    if (value == 1) {
      closeCamera();
    } else {
      stopfloating();
    }
    return _stage.value = value;
  }

  get stage => _stage.value;

  final _isleaving = false.obs;
  set isleaving(value) => _isleaving.value = value;
  get isleaving => _isleaving.value;

  final _amounttodonate = ''.obs;
  set amounttodonate(value) => _amounttodonate.value = value;
  get amounttodonate => _amounttodonate.value;

  final _iswhiteboard = false.obs;
  set iswhiteboard(value) => _iswhiteboard.value = value;
  get iswhiteboard => _iswhiteboard.value;

  final _currentBackground = ''.obs;
  set currentBackground(value) => _currentBackground.value = value;
  get currentBackground => _currentBackground.value;

  final _guestpermission = ''.obs;
  set guestpermission(value) => _guestpermission.value = value;
  get guestpermission => _guestpermission.value;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final HomeController controller = Get.put(HomeController(usersList: usersList));
  // final SwitchController switchcontroller = Get.put(SwitchController());

  final _captionButtonPressed =
      false.obs; // variable to track caption button visibility
  set captionButtonPressed(value) => _captionButtonPressed.value = value;
  get captionButtonPressed => _captionButtonPressed.value;

  final _arguments = {}.obs;
  set arguments(value) => _arguments.value = value;
  get arguments => _arguments.value;

  final _ismuted = false.obs;
  set ismuted(value) => _ismuted.value = value;
  get ismuted => _ismuted.value;

  final _isstartroom = false.obs;
  set isstartroom(value) => _isstartroom.value = value;
  get isstartroom => _isstartroom.value;

  final _donate = false.obs;
  set donate(value) => _donate.value = value;
  get donate => _donate.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _check = false.obs;
  set check(value) => _check.value = value;
  get check => _check.value;

  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();

  final _meetingdetails = Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;

  final _roomdetails = {}.obs;
  set roomdetails(value) => _roomdetails.value = value;
  get roomdetails => _roomdetails.value;

  final _donationdetails = [].obs;
  set donationdetails(value) => _donationdetails.value = value;
  get donationdetails => _donationdetails.value;

  final _webrtctoken = "".obs;
  set webrtctoken(value) => _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _selectedOption = {}.obs;

  set selectedOption(value) => _selectedOption.value = value;

  get selectedOption => _selectedOption.value;

  var formKey = GlobalKey<FormState>();
  Timer? _timer;

  final _zoomLevel = 1.0.obs; // Initial zoom level (100%)
  set zoomLevel(value) => _zoomLevel.value = value;
  get zoomLevel => _zoomLevel.value;

  final _toupload = <PlatformFile>[].obs; // Initial zoom level (100%)
  set toupload(value) => _toupload.value = value;
  get toupload => _toupload.value;

  final _selecttoupload = PlatformFile(
    name: '',
    size: 0,
  ).obs; // Initial zoom level (100%)
  set selecttoupload(value) => _selecttoupload.value = value;
  get selecttoupload => _selecttoupload.value;

  final _slideposition = 1.obs; // Initial zoom level (100%)
  set slideposition(value) => _slideposition.value = value;
  get slideposition => _slideposition.value;

  void zoomIn() {
    zoomLevel += 0.1; // Increase zoom level
    if (zoomLevel > 2.0) zoomLevel = 2.0; // Maximum 200% zoom
  }

  get zoomPercentage => (zoomLevel * 100).toInt();

  void zoomOut() {
    zoomLevel -= 0.1; // Decrease zoom level
    if (zoomLevel < 0.5) zoomLevel = 0.5; // Minimum 50% zoom
  }

  StreamSubscription? _subscription;

  final donationdescriptionController = TextEditingController();
  final donationuniquenumberController = TextEditingController();

  bool hasUnsavedChanges = true;

  @override
  void onInit() {
    // controller.slideposition =
    isleaving = false;

    // Cancel any existing subscription
    _subscription?.cancel();

    // Create a new subscription
    // sdklistener();

    // TODO: implement onInit
    super.onInit();
  }

  startroom() {
    bigbluebuttonsdkPlugin.initialize(
      baseurl: baseurl,
      webrtctoken: webrtctoken,
      meetingdetails: meetingdetails,
    );
    bigbluebuttonsdkPlugin.startroom();
    checkdonation();
    // Set up a timer to call checkdonation() every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // obj = "";
      checkdonation();
    });

    // Cancel any existing subscription
    _subscription ??= bigbluebuttonsdkPlugin.stream.listen((event) async {
      var response = jsonDecode(event);
      switch (response["collection"]) {
        case "current-user":
          if (response["msg"] == "removed" ||
              (response["msg"] == "changed" &&
                  response["fields"] != null &&
                  response["fields"]["loggedOut"] != null &&
                  response["fields"]["loggedOut"])) {
            isleaving = true;
            stage = 0;
            Navigator.pop(context, isleaving);
          }
          break;
        case "external-video-meetings":
          if (response["fields"] != null &&
              response["fields"]["externalVideoUrl"] != null) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => ShowVideoScreen(
                videoLink: response,
                ishowecinema: bigbluebuttonsdkPlugin.ishowecinema,
              ),
            );
          }
          break;
        case "polls":
          if (response["msg"] == "added") {
            final currentId = response["id"];
            if (!pullcontroller.ispulling &&
                currentId != pullcontroller.lastPollId) {
              pullcontroller.ispulling = true;
              pullcontroller.lastPollId = currentId;
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                    Pullquestionandanswer(json: response),
              );
            }
          } else if (response["msg"] == "removed") {
            pullcontroller.ispulling = false;
            pullcontroller.lastPollId = "";
          }
          break;
        case "current-poll":
          if (response["msg"] == "added") {
            pullcontroller.pullresult = response;
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => Pollsresult(json: response),
            ).then((value) {
              Future.delayed(const Duration(seconds: 3), () {
                pullcontroller.pullresult = {};
              });
            });
          } else {}
          break;
        case "breakouts":
          Get.dialog(
            Scaffold(
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
                        Text(
                          'DURATIONS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.08,
                            letterSpacing: 0.10,
                          ),
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFF5D957E),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '14:39',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    0.9800000190734863,
                                  ),
                                  fontSize: 30,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0.02,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Room 1 (0)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'View',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Join room |  Join audio',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            // barrierLabel: ' Full Screen Dialog',
            transitionDuration: const Duration(milliseconds: 400),
          );
          break;

        default:
          // print("default response");
          // print(json);
          break;
      }
    });
  }

  final floating = Floating();

  Future<void> enablePip({
    bool autoEnable = false,
    required BuildContext context,
  }) async {
    final rational = Rational.landscape();
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final arguments = autoEnable
        ? OnLeavePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          )
        : ImmediatePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          );

    final status = await floating.enable(arguments);
    debugPrint('PiP enabled? $status');
  }

  var _scale = 1.0.obs;
  set scale(double value) => _scale.value = value;
  double get scale => _scale.value;

  var _previousScale = 1.0.obs;
  set previousScale(double value) => _previousScale.value = value;
  double get previousScale => _previousScale.value;

  var _offset = Offset.zero.obs;
  set offset(Offset value) => _offset.value = value;
  Offset get offset => _offset.value;

  var _lastFocalPoint = Offset.zero.obs;
  set lastFocalPoint(Offset value) => _lastFocalPoint.value = value;
  Offset get lastFocalPoint => _lastFocalPoint.value;

  var _previousOffset = Offset.zero.obs;
  set previousOffset(Offset value) => _previousOffset.value = value;
  Offset get previousOffset => _previousOffset.value;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    _timer?.cancel();
    stopfloating();
    closeCamera();
    // TODO: implement onClose
    super.onClose();
  }

  var isfloating = false.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    closeCamera();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
  }

  void uploadpresentation(String token) async {
    var cmddetails = await Diorequest().post(
      "https://meet.konn3ct.ng/bigbluebutton/presentation/$token/upload",
      {
        "conference": "9753e686f0a75399ca60ae03442353b4b7862ee2-1729497404190",
        "room": "9753e686f0a75399ca60ae03442353b4b7862ee2-1729497404190",
        "temporaryPresentationId": "kDuVFqPxrfS2IVgi7YnsswjM",
        "pod_id": "DEFAULT_PRESENTATION_POD",
        "is_downloadable": false,
      },
      token,
    );
    if (cmddetails["success"]) {
      // if (cmddetails["data"].isNotEmpty) {
      //   donate = true;
      //   donationdetails = cmddetails["data"];
      // } else {
      //   donate = false;
      // }
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {}
  }

  void checkdonation() async {
    var cmddetails = await Diorequest().get(
      "k4/donation/${roomdetails['id']}",
      token,
    );
    // print("donation cmddetails");
    // print(cmddetails);
    if (cmddetails["success"]) {
      if (cmddetails["data"].isNotEmpty) {
        donate = true;
        donationdetails = cmddetails["data"];
      } else {
        donate = false;
      }
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {}
  }

  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Back', 'icon': Icons.arrow_back_ios},
    {'name': 'Appreciation'},
    {'name': 'Minutes'},
    {'name': 'General notes'},
    {'name': 'Technical notes'},
    {'name': 'Sales notes'},
    {'name': 'Transcript'},
  ];

  final messageController = TextEditingController();
  dynamic selectedItem;

  final _thirdDropdownValue = MediaDeviceInfo(
    label: 'Default - Phone mic',
    deviceId: '',
  ).obs;
  set thirdDropdownValue(value) => _thirdDropdownValue.value = value;
  get thirdDropdownValue => _thirdDropdownValue.value;

  final _thirdItemsDropdown = <MediaDeviceInfo>[].obs;
  set thirdItemsDropdown(value) => _thirdItemsDropdown.value = value;
  List<MediaDeviceInfo> get thirdItemsDropdown => _thirdItemsDropdown.value;

  final _messages = <ChatMessage>[].obs;
  set messages(value) => _messages.value = value;
  get messages => _messages;

  final _firstItemsDropdown = <MediaDeviceInfo>[].obs;
  set firstItemsDropdown(value) => _firstItemsDropdown.value = value;
  List<MediaDeviceInfo> get firstItemsDropdown => _firstItemsDropdown.value;

  final _secondItemsDropdown = <String>[
    'High Definition',
    'Medium Definition',
    'Low Definition',
  ].obs;
  set secondItemsDropdown(value) => _secondItemsDropdown.value = value;
  List<String> get secondItemsDropdown => _secondItemsDropdown.value;

  final _firstDropdownValue = MediaDeviceInfo(
    label: 'HD Camera',
    deviceId: '',
  ).obs;
  set firstDropdownValue(value) => _firstDropdownValue.value = value;
  get firstDropdownValue => _firstDropdownValue.value;

  final _secondDropdownValue = 'High Definition'.obs;
  set secondDropdownValue(value) => _secondDropdownValue.value = value;
  get secondDropdownValue => _secondDropdownValue.value;

  void getAvailableCameras() async {
    firstItemsDropdown = await bigbluebuttonsdkPlugin.getAvailableCameras();

    // for (var device in videoDevices) {
    //   firstItemsDropdown.add(device.label);
    //   print('Camera: ${device.label} (${device.deviceId})');
    // }

    // if(bigbluebuttonsdkPlugin.getAvailableMicrophones.isEmpty) return;
    firstDropdownValue = firstItemsDropdown.first;
  }

  void getAvailableMicrophones() async {
    thirdItemsDropdown = await bigbluebuttonsdkPlugin.getAvailableMicrophones();

    // for (var device in audioDevices) {
    //   thirdItemsDropdown.add(device.label);
    //   print('Microphone: ${device.label} (${device.deviceId})');
    // }
    // if(bigbluebuttonsdkPlugin.getAvailableMicrophones.isEmpty) return;
    thirdDropdownValue = thirdItemsDropdown.first;
  }

  stopfloating() {
    floating.cancelOnLeavePiP();
  }

  final _accesscode = false.obs;
  set accesscode(value) => _accesscode.value = value;
  get accesscode => _accesscode.value;

  final _isvideo = false.obs;
  set isvideo(value) => _isvideo.value = value;
  get isvideo => _isvideo.value;

  final _isaudio = true.obs;
  set isaudio(value) => _isaudio.value = value;
  get isaudio => _isaudio.value;

  final _iswaiting = false.obs;
  set iswaiting(value) => _iswaiting.value = value;
  get iswaiting => _iswaiting.value;

  var meetingnameController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();

  var accesscodeController = TextEditingController();

  final _cameracontroller = Rx<CameraController?>(null);
  set cameracontroller(value) => _cameracontroller.value = value;
  get cameracontroller => _cameracontroller.value;

  final _cameras = <CameraDescription>[].obs;
  set cameras(value) => _cameras.value = value;
  get cameras => _cameras.value;

  // late List<CameraDescription> _cameras;
  Future<void>? initializeControllerFuture;

  bool isAudio = true;
  bool IsVideo = true;

  Future<bool> startCamera() async {
    try {
      // First check if we have camera permission
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          return false;
        }
      }

      // Get available cameras
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('No cameras found');
        return false;
      }

      // Initialize the camera
      cameracontroller = CameraController(
        cameras.length > 1 ? cameras[1] : cameras[0],
        ResolutionPreset.max,
        enableAudio: isaudio,
      );

      await cameracontroller?.initialize();
      obj = "kjhg";
      update(); // Notify listeners that the state has changed
      return true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('Camera access was denied');
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            debugPrint('Camera access was denied without prompt');
            break;
          case 'CameraAccessRestricted':
            debugPrint('Camera access is restricted');
            break;
          default:
            debugPrint('Camera error: ${e.description}');
            break;
        }
      }
      return false;
    }
  }

  Future<void> toggleCamera() async {
    if (cameracontroller != null && cameracontroller!.value.isInitialized) {
      await closeCamera();
      isvideo = false;
    } else {
      final success = await startCamera();
      isvideo = success;
    }
    update();
  }

  // Method to close the camera and release resources
  Future<bool> closeCamera() async {
    if (cameracontroller != null) {
      await cameracontroller!.dispose();
      cameracontroller = null;
      update();
      return false;
    } else {
      return true;
    }
  }

  Future<void> waiting(String data) async {
    iswaiting = true;
    var response = await Diorequest().get(
      "https://${baseurl}bigbluebutton/api/guestWait?sessionToken=$data",
      token,
    );
    if (response is! Map) {
      meetingdetail(data);
      return;
    }
    if (response["response"]["messageKey"] == "guestWait") {
      Future.delayed(const Duration(seconds: 3), () {
        if (isleaving) {
          return;
        }
        waiting(data);
      });
    } else if (response["response"]["messageKey"] == "guestDeny") {
      isleaving = false;
      Get.back(result: isleaving);
    }
  }

  void validateMeeting() async {
    print("validateMeeting initiated");

    isLoading = true;
    //var json_body = {
    //   "id": roomdetails['id'],
    //   "name": usernameController.text,
    //   "email": emailController.text,
    //   "access_code": accesscodeController.text
    // };
    var json_body = {
      "room": roomdetails["name"],
      "name": usernameController.text,
      "email": emailController.text,
      "access_code": accesscodeController.text,
    };

    // var cmddetails = await Diorequest().post("app/join-room",json_body);
    var cmddetails = await Diorequest().post(
      "${url}api/app/kv4/join-room",
      json_body,
      token,
    );
    // var cmddetails = await Diorequest().get("start-a-room/$id");

    // isLoading = false;
    print(cmddetails);
    if (cmddetails['success']) {
      if (cmddetails['wait']) {
        waiting(cmddetails['data']);
        return;
      }
      meetingdetail(cmddetails['data']);
    } else {
      isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void Meetingstart() async {
    print("validateMeeting initiated");

    isLoading = true;

    // var cmddetails = await Diorequest().post("app/join-room",json_body);
    var cmddetails = await Diorequest().get(
      "${url}api/app/start-a-room/${roomdetails['id']}",
      token,
    );
    // var cmddetails = await Diorequest().get("start-a-room/$id");

    // isLoading = false;
    print(cmddetails);
    if (cmddetails['success']) {
      meetingdetail(cmddetails['sessionToken']);
    } else {
      isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        // Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void meetingdetail(String webtoken) async {
    try {
      print("$entermeetingurl$webtoken");
      var cmddetails = await Diorequest().get(
        "$entermeetingurl$webtoken",
        token,
      );
      print(cmddetails);

      if (cmddetails["response"]["returncode"] == "SUCCESS") {
        stage = 1;
        webrtctoken = webtoken;
        meetingdetails = meetingdetailsFromJson(
          jsonEncode(cmddetails["response"]),
        );

        isLoading = false;
        await startroom();

        if (isvideo) {
          bigbluebuttonsdkPlugin.startcamera();
        }
        if (!isaudio) {
          bigbluebuttonsdkPlugin.mutemyself();
        }
        // Get.offNamed(
        //   Routes.POSTJOIN,
        //   arguments: {
        //     "token": webtoken,
        //     "meetingdetails": cmddetails["response"],
        //     "roomdetails": roomdetails,
        //   },
        // );
        update();
      } else if (cmddetails["response"]["returncode"] == "FAILED" &&
          cmddetails["response"]["messageKey"] == "guestDeny") {
        // Get.offNamed(Routes.HOME);
        print("waiting room");
      } else {
        print("start the meeting again");
      }
    } on Exception {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.detached) {
      isfloating.value = false;
    } else {
      isfloating.value = true;
      try {
        enablePip(context: context, autoEnable: false);
      } catch ($e) {
        print("Error while enabling pip");
      }
    }
    // _isInForeground = state == AppLifecycleState.resumed;
  }

  static const Color red = Color(0xFFFF0000);

  FocusNode textFocusNode = FocusNode();

  final _backgroundImage = Rx<ui.Image?>(null);
  set backgroundImage(value) => _backgroundImage.value = value;
  get backgroundImage => _backgroundImage.value;

  final _points = <Offset>[].obs;
  set points(value) => _points.value = value;
  List<Offset> get points => _points.value;

  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
}
