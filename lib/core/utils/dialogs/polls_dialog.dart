import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PollsController extends GetxController {
  var question = ''.obs;
  var options = ['Option 1'].obs;

  void addOption() {
    options.add('Option ${options.length + 1}');
  }

  // =====================================================================================================================================================================================
  void showPollsResultsDialog({
    required String question,
    required List<String> options,
  }) {
    Get.generalDialog(
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        final List<int> votes = [50, 30, 15]; // Example votes for each option
        late final totalVotes = votes.reduce(
          (a, b) => a + b,
        ); // add all the votes to give the total number of votes
        late final List<double> percentages = votes
            .map((vote) => (vote / totalVotes) * 100)
            .toList();
        late final sortedOptions = List<String>.from(options)
          ..sort(
            (a, b) =>
                votes[options.indexOf(b)].compareTo(votes[options.indexOf(a)]),
          );
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 400,
                height: 510,
                padding: const EdgeInsets.only(
                  top: 24,
                  right: 16,
                  bottom: 24,
                  left: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(62, 132, 102, 1),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Polls',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Created by Femi Williams',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    Flexible(
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: LinearPercentIndicator(
                              width: 210,
                              //width for progress bar
                              animation: true,
                              //animation to show progress at first
                              animationDuration: 1000,
                              lineHeight: 50.0,
                              //height of progress bar
                              percent: percentages[index] / 100,
                              // 30/100 = 0.3
                              center: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Text(
                                    '${percentages[index].toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    sortedOptions[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              barRadius: const Radius.circular(8),
                              progressColor: const Color.fromRGBO(
                                93,
                                148,
                                126,
                                1,
                              ),
                              //percentage progress bar color
                              backgroundColor: Colors
                                  .transparent, //background progressbar color
                            ),
                          );
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '$totalVotes votes of ${totalVotes + 50}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ====================================================================================================================
class PollsDialog extends GetView<PollsController> {
  PollsDialog({Key? key}) : super(key: key);

  final PollsController pollscontroller = Get.put(PollsController());

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        width: 400,
        height: 510,
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
        child: GetBuilder<postjoinController>(
          builder: (postjoincontroller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Polls',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(62, 132, 102, 1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.5, color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(7.0),
                            border: InputBorder.none,
                            hintText: 'Ask a question',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          onChanged: (value) =>
                              controller.question.value = value,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (var i = 0; i < controller.options.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(93, 149, 126, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(7.0),
                                border: InputBorder.none,
                                hintText: 'Answer ${i + 1}',
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                              onChanged: (value) =>
                                  controller.options[i] = value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: controller.addOption,
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 16,
                            left: 16,
                            bottom: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(93, 149, 126, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Add answers',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          if (controller.question.isNotEmpty &&
                              controller.options.isNotEmpty) {
                            postjoincontroller.bigbluebuttonsdkPlugin.startpoll(
                              question: controller.question.value,
                              options: controller.options,
                            );

                            Navigator.pop(context);
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                backgroundColor: const Color.fromRGBO(
                                  62,
                                  132,
                                  102,
                                  1,
                                ),
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                content: const Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Text(
                                    "Ensure to input a question and answer(s).",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Got It',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              barrierColor: Colors.transparent,
                            );
                          }
                        },
                        child: Container(
                          width: 151,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(93, 149, 126, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Publish Polls',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
