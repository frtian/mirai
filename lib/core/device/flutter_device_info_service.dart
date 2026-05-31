import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'device_info_service.dart';

class FlutterDeviceInfoService implements DeviceInfoService {
  FlutterDeviceInfoService({DeviceInfoPlugin? deviceInfoPlugin})
      : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfoPlugin;

  @override
  Future<String> getDeviceModel() async {
    if (kIsWeb) {
      return 'web';
    }

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.utsname.machine;
    }

    return Platform.operatingSystem;
  }
}