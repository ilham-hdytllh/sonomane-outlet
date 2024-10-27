import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class GetServerTime extends ChangeNotifier {
  DateTime? _serverTime;

  DateTime? get serverTime => _serverTime;

  getServerTime() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-dbfoodmenu.cloudfunctions.net/functions/getServerTime'));
    if (response.statusCode == 200) {
      final serverTime = jsonDecode(response.body)['time'];
      final dateTime = DateTime.parse(serverTime);
      _serverTime = dateTime;
      notifyListeners();
    } else {
      throw Exception('Failed to get server time');
    }
  }
}
