import 'dart:async';
import 'package:flutter/services.dart';

class MyForegroundService {
  static const MethodChannel _channel = MethodChannel('com.ipsitasoft.salesman/location_service');

  static Future<bool> startForegroundService({required String userID}) async {
    return await _channel.invokeMethod('startForegroundService', {'userID': userID});
  }

  static Future<bool> stopForegroundService() async {
    return await _channel.invokeMethod('stopForegroundService');
  }

  static Future<String?> getDeviceID() async {
    return await _channel.invokeMethod('getDeviceID');
  }
}
