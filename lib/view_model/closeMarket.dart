import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class CloseMarket extends ChangeNotifier {
  bool _marketIsClosing = false;
  String? _timeClose;
  String? _serverTime;

  bool get marketIsClosing => _marketIsClosing;
  String? get timeClose => _timeClose;
  String? get serverTime => _serverTime;

  void setCloseMarket(bool close) async {
    String? time = await getServerTime();
    _timeClose = time;
    _marketIsClosing = close;
    notifyListeners();
  }

  Future<String?> getServerTime() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-dbfoodmenu.cloudfunctions.net/functions/getServerTime'));
    if (response.statusCode == 200) {
      final serverTime = jsonDecode(response.body)['time'];
      final dateTime = DateTime.parse(serverTime);
      _serverTime = DateTime.parse(serverTime).toString();
      return dateTime.toString();
    } else {
      throw Exception('Failed to get server time');
    }
  }
}
