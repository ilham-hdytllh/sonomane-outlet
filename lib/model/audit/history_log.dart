import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryLogModel {
  String idDoc;
  num date;
  String dateTime;
  num month;
  String keterangan;
  String type;
  String user;
  num year;

  HistoryLogModel({
    required this.idDoc,
    required this.date,
    required this.dateTime,
    required this.month,
    required this.keterangan,
    required this.type,
    required this.user,
    required this.year,
  });
  Map<String, dynamic> toMap() {
    return {
      "idDoc": idDoc,
      "date": date,
      "datetime": dateTime,
      "month": month,
      "keterangan": keterangan,
      "type": type,
      "user": user,
      "year": year,
    };
  }
}

class HistoryLogModelFunction {
  final String idDoc;
  HistoryLogModelFunction(this.idDoc);

  Future addHistory(HistoryLogModel history, String idDoc) async {
    await FirebaseFirestore.instance.collection("history").doc(idDoc).set(
          history.toMap(),
        );
  }

  Future getHistory() async {
    return FirebaseFirestore.instance
        .collection("history")
        .orderBy("datetime", descending: true)
        .get();
  }
}
