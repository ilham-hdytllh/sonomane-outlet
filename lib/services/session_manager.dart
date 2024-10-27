import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyLoginTime = 'login_time';
  static const int _sessionTimeoutMinutes =
      1440; // Durasi session dalam menit (1 hari

  static Future<void> saveLoginTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String formattedLoginTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    prefs.setString(_keyLoginTime, formattedLoginTime);
  }

  static Future<String?> getLoginTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLoginTime);
  }

  static Future<bool> isSessionExpired() async {
    final String? loginTime = await getLoginTime();

    if (loginTime != null) {
      final DateTime loginDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(loginTime);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(loginDateTime);
      final int differenceInMinutes = difference.inMinutes;

      return differenceInMinutes > _sessionTimeoutMinutes;
    } else {
      // Jika tidak ada waktu login yang tersimpan, anggap sesi sudah kadaluwarsa
      return true;
    }
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
