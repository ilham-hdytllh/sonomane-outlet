import 'package:flutter/foundation.dart';

class AccessTokenProvider extends ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
    // notifyListeners();
  }
}
