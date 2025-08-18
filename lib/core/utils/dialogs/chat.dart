import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:lottie/lottie.dart';

class ChatDialog extends StatefulWidget {
  final Participant? participant;

  const ChatDialog({super.key, this.participant});

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Everyone', 'icon': Icons.people_alt_outlined},
    {'name': 'Raised Hand', 'icon': Icons.back_hand_outlined},
    {'name': 'Item 3'},
    {'name': 'Item 4'},
  ];

  bool notification = true;

  dynamic selectedItem;

  final messageController = TextEditingController();
  String chatid = "MAIN-PUBLIC-GROUP-CHAT";

  @override
  void initState() {
    super.initState();
    if (widget.participant != null) {
      if (widget.participant!.fields!.chatId != null) {
        chatid = widget.participant!.fields!.chatId!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<postjoinController>(
      builder: (postjoincontroller) {
        if (widget.participant != null) {
          var list =
              postjoincontroller.bigbluebuttonsdkPlugin.participant.where((v) {
            return v.fields!.userId == widget.participant!.fields!.userId;
          }).toList();
          if (list[0].fields!.chatId != null) {
            chatid = list[0].fields!.chatId!;
          }
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: const EdgeInsets.only(top: 94),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(62, 139, 102, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  if (widget.participant == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                                '${selectedItem != null ? selectedItem["name"] : "Everyone"}',
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
                                  return menuItems.map((item) {
                                    return PopupMenuItem<dynamic>(
                                      value: item,
                                      child: Row(
                                        children: [
                                          Icon(
                                            item['icon'],
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            item['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                                onSelected: (dynamic value) {
                                  setState(() {
                                    selectedItem = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Private Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (notification)
                    Container(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 5,
                        right: 5,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(93, 149, 126, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.participant == null
                                  ? 'Messages can only be seen by people in the call and are deleted when the call ends.'
                                  : 'Messages can only be seen by ${postjoincontroller.bigbluebuttonsdkPlugin.mydetails!.fields!.name} and ${widget.participant!.fields!.name} ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                notification = !notification;
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: GetBuilder<Websocket>(
                      builder: (logic) {
                        return ListView.builder(
                          itemCount: logic.getchatMessages(chatid).length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return chatMessageCard(
                              logic.getchatMessages(chatid)[index],
                              postjoincontroller.meetingdetails,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (v) {
                        postjoincontroller.bigbluebuttonsdkPlugin.typing(
                          chatid: chatid,
                        );
                      },
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.sentiment_satisfied_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (messageController.text.isNotEmpty) {
                                  postjoincontroller.bigbluebuttonsdkPlugin
                                      .sendmessage(
                                    chatid: chatid,
                                    message: messageController.text,
                                  );
                                  messageController.clear();
                                }
                              },
                              icon: const Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        hintText: "Send a message to everyone",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: const Color.fromRGBO(93, 149, 126, 1),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget chatMessageCard(ChatMessage message, Meetingdetails meetingdetails) {
    return Align(
      alignment: (message.senderName == meetingdetails.fullname
          ? Alignment.topRight
          : Alignment.topLeft),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color.fromRGBO(62, 139, 102, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        message.senderName == meetingdetails.fullname
                            ? 'You'
                            : message.senderName!,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text('2:12 PM', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                  ),
                ],
              ),
              message.istyping == true
                  ? Lottie.network(
                      'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
                      height: 30,
                    )
                  : Text(
                      message.message,
                      style: const TextStyle(color: Colors.white),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
