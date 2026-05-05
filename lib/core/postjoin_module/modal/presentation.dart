import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/utils/presentationmodel.dart' as presentation;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/utils/state_mgt/PresentationController.dart';

class Presentation extends GetView<PresentationController> {
  const Presentation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var postjoincontroller = Get.put(postjoinController());
    return GetBuilder<Websocket>(
      builder: (logic) {
        return Container(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Presentation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFF5D957E),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9800000190734863),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (controller.selecttoupload.name.isNotEmpty &&
                            controller.selecttoupload.size != 0) {
                          controller.bigbluebuttonsdkPlugin.uploadpresenter(
                            filename: controller.selecttoupload,
                          );
                          controller.toupload.remove(controller.selecttoupload);
                        } else if (controller.selecttoupload.size == 0) {
                          // Find and remove the item
                          var result = logic.presentationModel.where((v) {
                            return v.fields!.name! ==
                                controller.selecttoupload.name!;
                          }).toList();
                          if (result.isNotEmpty) {
                            controller.bigbluebuttonsdkPlugin
                                .makepresentationdefault(
                                  presentation: result.first.toJson(),
                                );
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: ShapeDecoration(
                          color: Color(0xFF5D957E),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFF5D957E),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9800000190734863),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFF5D957E),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'As a presenter you have the ability to upload any office document or PDF file. We recommend PDF file for best results. Please ensure that a presentation is selected using the circle checkbox on the left hand side.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Current presentation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Actions',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Use Expanded instead of Flexible here for the ListView.builder
                // ListView.builder(
                //   shrinkWrap: true,
                //   // Ensures ListView takes only necessary space
                //   physics: const NeverScrollableScrollPhysics(),
                //   // Disables scrolling
                //   itemCount: logic.presentationmodel.length,
                //   itemBuilder: (context, index) {
                //     return Padding(
                //       padding: const EdgeInsets.only(bottom: 20.0),
                //       child: item(logic.presentationmodel[index]),
                //     );
                //   },
                // ),
                Obx(() {
                  return Column(
                    children: [
                      for (int i = 0; i < logic.presentationModel.length; i++)
                        item(logic.presentationModel[i], 0, ""),
                      for (int i = 0; i < controller.toupload.length; i++)
                        item(
                          presentation.Presentationmodel(
                            fields: presentation.Fields(
                              name: controller.toupload[i].name,
                              current: false,
                            ),
                          ),
                          controller.toupload[i].size,
                          controller.toupload[i].path,
                        ),
                    ],
                  );
                }),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFF5D957E),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'In the “Export options” menu you have the option to enable download of the original presentation and to provide users with a downloadable link with annotations in public chat.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: [
                            "doc",
                            "pdf",
                            "ppt",
                            "text",
                            "docx",
                          ],
                        );
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      controller.toupload.add(file);
                      // print(file.name);
                      // print(file.bytes);
                      // print(file.size);
                      // print(file.extension);
                      // print(file.path);
                    }
                  },
                  child: Container(
                    width: 546,
                    height: 259,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/image/uploadcloud.png',
                          package: "konn3ctsdk",
                          height: 70,
                        ),
                        Text(
                          'Drag files here to upload',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9800000190734863),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'or browse for files',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            // textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget item(
    presentation.Presentationmodel presentationmodel,
    int size,
    String path,
  ) {
    return InkWell(
      onTap: () {
        controller.selecttoupload = PlatformFile(
          name: presentationmodel.fields!.name!,
          size: size,
          path: path,
        );
        // print(controller.selecttoupload.name);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03999999910593033),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(1.25),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.white),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.done,
                color:
                    controller.selecttoupload.name ==
                        presentationmodel.fields!.name!
                    ? Colors.white
                    : Colors.transparent,
                size: 15,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                presentationmodel.fields!.name!,
                style: TextStyle(
                  color: Color(0xF2F5F9FF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            if (presentationmodel.fields!.current != null &&
                presentationmodel.fields!.current!)
              Container(
                width: 91,
                height: 26,
                decoration: BoxDecoration(color: Colors.white),
                alignment: Alignment.center,
                child: Text(
                  'CURRENT',
                  style: TextStyle(
                    color: Color(0xF20E0E0E),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Icon(Icons.more_vert_outlined, color: Colors.white),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                if (presentationmodel.id != null) {
                  controller.bigbluebuttonsdkPlugin.removepresentation(
                    presentationid: presentationmodel.id!,
                  );
                } else {
                  // Find and remove the item
                  var result = controller.toupload.where((v) {
                    return v.name == presentationmodel.fields!.name!;
                  }).toList();
                  print("remove docresult");
                  print(result);
                  print(controller.toupload);
                  if (result.isNotEmpty) {
                    controller.toupload.remove(result.first);
                  }
                  print(result.first);
                  print(controller.toupload);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
