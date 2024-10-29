import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  String _verificationId = '';

  String get verificationId => _verificationId;

  void setVerificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }
}
