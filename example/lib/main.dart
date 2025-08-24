import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const PreJoin(),
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
          trackVisibility: MaterialStateProperty.all(true),
          thickness: MaterialStateProperty.all(15.0),
          radius: const Radius.circular(30),
          thumbColor: MaterialStateProperty.all(
            const Color.fromRGBO(255, 255, 255, 0.71),
          ),
          trackColor: MaterialStateProperty.all(
            const Color.fromRGBO(51, 125, 93, 1),
          ),
          // trackBorderColor: MaterialStateProperty.all(Colors.white),
          // minThumbLength: 60,
          mainAxisMargin: 130,
          crossAxisMargin: 10,
          interactive: true,
        ),
      ),
      // initialRoute: Routes.PREJOIN,
      // getPages: AppPages.pages,
      home: Homepage(),
    );
  }
}
