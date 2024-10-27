import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class OpenMarket extends ChangeNotifier {
  bool _marketIsOpen = false;
  String? _timeOpen;

  bool get marketIsOpen => _marketIsOpen;
  String? get timeOpen => _timeOpen;

  void setOpenMarket(bool open) async {
    String? time = await getServerTime();
    _timeOpen = time;
    _marketIsOpen = open;
    notifyListeners();
  }

  Future<String?> getServerTime() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-dbfoodmenu.cloudfunctions.net/functions/getServerTime'));
    if (response.statusCode == 200) {
      final serverTime = jsonDecode(response.body)['time'];
      final dateTime = DateTime.parse(serverTime);
      return dateTime.toString();
    } else {
      throw Exception('Failed to get server time');
    }
  }
}
