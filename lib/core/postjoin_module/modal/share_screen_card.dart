import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../postjoin_controller.dart';

class ShareScreenCard extends GetView<postjoinController> {
  const ShareScreenCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(62, 132, 102, 1),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.ios_share_rounded,
                    color: Colors.white,
                    size: 80.0,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'You are sharing your screen',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.bigbluebuttonsdkPlugin.stopscreenshare();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const PostJoin()
                      //     )
                      // );
                    },
                    child: Container(
                        height: 48,
                        width: 218,
                        padding: const EdgeInsets.only(
                            top: 8, right: 16, bottom: 8, left: 16),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(204, 82, 95, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.close, color: Colors.white, size: 23),
                            Text('Stop Screenshare',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
