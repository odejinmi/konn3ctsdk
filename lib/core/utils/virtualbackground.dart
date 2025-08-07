import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:konn3ctsdk/core/postjoin_module/postjoin_controller.dart';

import 'strings.dart';

class Virtualbackgroundviews extends StatelessWidget {
  Virtualbackgroundviews({Key? key}) : super(key: key);

  // List<String> get backgroundAssets =>
  //     SizerUtil.isDesktop ? desktopBackgrounds : backgrounds;
  List<String> get backgroundAssets => backgrounds;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<postjoinController>(
      builder: (postjoincontroller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Future.microtask(() async {
                    final ByteData bytes = await rootBundle.load(
                      postjoincontroller.currentBackground!,
                    );
                    final Uint8List backgroundBuffer = bytes.buffer
                        .asUint8List();
                    postjoincontroller.bigbluebuttonsdkPlugin.starvirtual(
                      backgroundimage: backgroundBuffer,
                    );
                  });
                },
                icon: Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          body: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.66,
            ),
            itemCount: backgroundAssets.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () {
                    postjoincontroller.currentBackground = null;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: postjoincontroller.currentBackground == null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.block,
                      size: 20,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  postjoincontroller.currentBackground =
                      backgroundAssets[index - 1];
                  print(postjoincontroller.currentBackground);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color:
                          postjoincontroller.currentBackground ==
                              backgroundAssets[index - 1]
                          ? Colors.green
                          : Colors.transparent,
                    ),
                  ),
                  child: Image.asset(package: "konn3ctsdk",
                    backgroundAssets[index - 1],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
