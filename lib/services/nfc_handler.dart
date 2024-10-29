import 'dart:async';

import 'package:flutter/services.dart';

class NfcHandler {
  static const MethodChannel _channel =
      MethodChannel('com.example.pinnitagpay/nfc');

  Future<int> piccOpen() async {
    final int result = await _channel.invokeMethod('piccOpen');
    return result;
  }

  Future<int> piccCheck(
      String mode, List<int> cardType, List<int> serialNo) async {
    final Map<String, dynamic> args = <String, dynamic>{
      'mode': mode,
      'cardType': cardType,
      'serialNo': serialNo,
    };
    final int result = await _channel.invokeMethod('piccCheck', args);
    return result;
  }

  Future<int> piccCommand(List<int> apduSend) async {
    final Map<String, dynamic> args = <String, dynamic>{
      'apduSend': apduSend,
    };
    final int result = await _channel.invokeMethod('piccCommand', args);
    return result;
  }

  Future<int> piccClose() async {
    final int result = await _channel.invokeMethod('piccClose');
    return result;
  }

  Future<int> piccRemove() async {
    final int result = await _channel.invokeMethod('piccRemove');
    return result;
  }

  // Add other methods...
}
