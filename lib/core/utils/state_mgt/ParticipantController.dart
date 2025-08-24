import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParticipantController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var _menuItems = <Map<String, dynamic>>[
    {'name': 'Everyone', 'icon': Icons.people_alt_outlined},
    {'name': 'Raised Hand', 'icon': Icons.back_hand_outlined},
  ].obs;
  set menuItems(value) => _menuItems.value = value;
  List<Map<String, dynamic>> get menuItems => _menuItems.value;

  var _selectedItem = Rx<Map<String, dynamic>>({
    'name': 'Everyone',
    'icon': Icons.people_alt_outlined,
  });
  set selectedItem(value) => _selectedItem.value = value;
  get selectedItem => _selectedItem.value;

  var _sortedParticipants = <Participant>[].obs;
  set sortedParticipants(value) => _sortedParticipants.value = value;
  List<Participant> get sortedParticipants => _sortedParticipants.value;

  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void sortParticipants() {
    var paricipants = bigbluebuttonsdkPlugin.participant;
    if (selectedItem["name"] == 'Everyone') {
      sortedParticipants = paricipants;
    } else {
      sortedParticipants = paricipants
          .where((element) => element.fields!.raiseHand == true)
          .toList();
      print('sortedParticipants: $sortedParticipants');
    }
  }
}
