import 'package:cloud_firestore/cloud_firestore.dart';

class DailyPointModel {
  String idDoc;
  String day;
  int point;
  DailyPointModel({
    required this.idDoc,
    required this.day,
    required this.point,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": idDoc,
      "day": day,
      "points": point,
    };
  }
}

class DailyPointFunction {
  Stream<QuerySnapshot> getDailyPoint() {
    return FirebaseFirestore.instance
        .collection("dailyPoints")
        .orderBy("day", descending: false)
        .snapshots();
  }

  Future updateDailyPoint(DailyPointModel dailyPointModel, String idDoc) {
    return FirebaseFirestore.instance
        .collection("dailyPoints")
        .doc(idDoc)
        .update(dailyPointModel.toMap());
  }
}
