import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konn3ctsdk/konn3ctsdk.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _platformVersion = 'Unknown';
  final _konn3ctsdkPlugin = Konn3ctsdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _konn3ctsdkPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            TextButton(
              onPressed: () {
                makeCall(true);
              },
              child: const Text("Start Call"),
            ),
            TextButton(
              onPressed: () {
                makeCall(false);
              },
              child: const Text("Join Call"),
            ),
          ],
        ),
      ),
    );
  }

  makeCall(bool startroom) async {
    var result = await _konn3ctsdkPlugin.startmeeting(
      roomdetails: {
        "id": 3044,
        "name": "tolu",
        "url": "ODE4232",
        "logout_url": "https://konn3ct.com/leftsession",
        "welcome_message":
            "Welcome to Host: <br>Meeting Link: <a href=\"https://konn3ct.com/join/ODE4232\" <span style=\"color: #008b8b;\">https://konn3ct.com/join/ODE4232</span></a><br>Dial-in: <span style=\"color: #008b8b;\">%%DIALNUM%%</span> PIN: <span style=\"color: #008b8b;\">%%CONFNUM%%</span>",
        "max_participants": 100,
        "duration": 60,
        "banner": null,
        "created_at": "2022-06-04T18:31:46.000Z",
      },
      context: context,
      startroom: startroom,
      token: "1207|rWJRGVtJaR6xelgsI6ckIrFV0oN6cER89n3AACKE",
      fullname: "odejinmi tolulope",
      email: "odejinmiabraham@gmail.com",
      accesscode: false,
      baseurl: "meet.konn3ct.ng/",
    );
  }
}
