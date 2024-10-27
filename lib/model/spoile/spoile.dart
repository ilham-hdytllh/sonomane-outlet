import 'package:cloud_firestore/cloud_firestore.dart';

class SpoileModel {
  final String idDoc;
  final String itemName;
  final String itemCode;
  final num quantity;
  final String unit;
  final String date;
  final String place;
  final String description;

  SpoileModel({
    required this.idDoc,
    required this.itemName,
    required this.itemCode,
    required this.quantity,
    required this.unit,
    required this.date,
    required this.place,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": idDoc,
      "itemCode": itemCode,
      "itemName": itemName,
      "quantity": description,
      "unit": unit,
      "place": place,
      "date": date,
      "description": description,
    };
  }
}

class SpoileFunction {
  Stream getAllSpoile() {
    return FirebaseFirestore.instance
        .collection("spoile")
        .orderBy("date", descending: true)
        .snapshots();
  }

  Future addSpoile(SpoileModel spoile, String idDoc) {
    return FirebaseFirestore.instance
        .collection("spoile")
        .doc(idDoc)
        .set(spoile.toMap());
  }

  Future deleteSpoile(String idDoc) {
    return FirebaseFirestore.instance.collection("spoile").doc(idDoc).delete();
  }

  Future updateSpoile(SpoileModel spoile, String idDoc) {
    return FirebaseFirestore.instance
        .collection("spoile")
        .doc(idDoc)
        .update(spoile.toMap());
  }
}
