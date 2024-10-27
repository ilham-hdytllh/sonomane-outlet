import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  String idDoc;
  // String batch;
  String dateCome;
  String name;
  num quantity;
  String unit;

  StockModel({
    required this.idDoc,
    // required this.batch,
    required this.dateCome,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Future addStock() async {
    await FirebaseFirestore.instance.collection("stocks").doc(idDoc).set({
      "idDoc": idDoc,
      // "batch": batch,
      "dateCome": dateCome,
      "name": name,
      "quantity": quantity,
      "unit": unit,
    });
  }

  Future deleteItem() async {
    await FirebaseFirestore.instance.collection("stocks").doc(idDoc).delete();
  }
}
