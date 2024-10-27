import 'package:intl/intl.dart';

extension DateParsingExtension on String {
  String removeTimeZoneOffset() {
    // Hapus zona waktu offset dari string tanggal
    String dateStringWithoutTimeZone = '${split(' ')[0]} ${split(' ')[1]}';

    // Parse tanggal tanpa zona waktu offset
    DateTime parsedDateTime = DateTime.parse(dateStringWithoutTimeZone);

    // Format ulang dengan DateFormat
    String formattedDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(parsedDateTime);

    return formattedDate;
  }
}
