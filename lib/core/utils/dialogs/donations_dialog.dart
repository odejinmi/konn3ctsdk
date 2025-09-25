import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../state_mgt/DonationController.dart';

class DonationsDialog extends GetView<DonationController> {
  const DonationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 580,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(62, 132, 102, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 75),
                          const Text(
                            'Donation Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextFormField(
                            cursorColor: Colors.white,
                            controller: controller.donationNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "this field cannot be empty";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(93, 149, 126, 1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          const Text(
                            'Donation Amount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Fixed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Radio(
                                value: 0,
                                groupValue: controller.selectedValue,
                                onChanged: (value) =>
                                    controller.selectedValue = value,
                                activeColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>((
                                      Set<MaterialState> states,
                                    ) {
                                      if (states.contains(
                                        MaterialState.disabled,
                                      )) {
                                        return Colors.white;
                                      }
                                      return Colors.white;
                                    }),
                              ),

                              const SizedBox(width: 10),

                              const Text(
                                'Any amount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Radio(
                                value: 1,
                                groupValue: controller.selectedValue,
                                onChanged: (value) =>
                                    controller.selectedValue = value,
                                activeColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>((
                                      Set<MaterialState> states,
                                    ) {
                                      if (states.contains(
                                        MaterialState.disabled,
                                      )) {
                                        return Colors.white;
                                      }
                                      return Colors.white;
                                    }),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          SizedBox(
                            width: 190,
                            height: 58,
                            child: TextFormField(
                              controller: controller.donationamountController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "this field cannot be empty";
                                }
                                return null;
                              },
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: '1000.00',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                filled: true,
                                fillColor: Color.fromRGBO(93, 149, 126, 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                side: const BorderSide(color: Colors.white),
                                value: controller.flashEnabled,
                                onChanged: (value) =>
                                    controller.flashEnabled = value!,
                                activeColor: Colors.white,
                              ),
                              const Text(
                                'Enable flash notifications',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!controller.isLoading &&
                                      controller.formKey.currentState!
                                          .validate() &&
                                      controller.selectedValue != null) {
                                    controller.createdonation();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  width: 151,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(93, 149, 126, 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Create',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
