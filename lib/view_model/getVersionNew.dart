import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GetNewVersionApp extends ChangeNotifier {
  String _newVersion = "1.0.0";

  String get newVersion => _newVersion;

  getNewVersion() async {
    await FirebaseFirestore.instance
        .collection("softwareVersion")
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get()
        .then((value) {
      value.docs.map((data) {
        _newVersion = data['version'];
        notifyListeners();
      }).toList();
    });
  }
}
