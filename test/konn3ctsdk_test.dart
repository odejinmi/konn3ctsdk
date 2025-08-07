import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konn3ctsdk/konn3ctsdk.dart';
import 'package:konn3ctsdk/konn3ctsdk_method_channel.dart';
import 'package:konn3ctsdk/konn3ctsdk_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKonn3ctsdkPlatform
    with MockPlatformInterfaceMixin
    implements Konn3ctsdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future startmeeting({
    required String baseurl,
    required String fullname,
    required String token,
    required bool accesscode,
    required bool startroom,
    required String email,
    required Map roomdetails,
    required BuildContext context,
  }) {
    // TODO: implement startmeeting
    throw UnimplementedError();
  }
}

void main() {
  final Konn3ctsdkPlatform initialPlatform = Konn3ctsdkPlatform.instance;

  test('$MethodChannelKonn3ctsdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKonn3ctsdk>());
  });

  test('getPlatformVersion', () async {
    Konn3ctsdk konn3ctsdkPlugin = Konn3ctsdk();
    MockKonn3ctsdkPlatform fakePlatform = MockKonn3ctsdkPlatform();
    Konn3ctsdkPlatform.instance = fakePlatform;

    expect(await konn3ctsdkPlugin.getPlatformVersion(), '42');
  });
}
