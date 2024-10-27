import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String idDoc;
  String itemCode;
  String itemName;
  String place;
  String unit;
  bool status;
  String createdAt;
  String updatedAt;

  ItemModel({
    required this.idDoc,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.place,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Future getAllItem() {
    return FirebaseFirestore.instance.collection("items").get();
  }

  Future updateItem() async {
    await FirebaseFirestore.instance.collection("items").doc(idDoc).update({
      "itemName": itemName,
      "unit": unit,
      "updateAt": updatedAt,
      "place": place,
    });
  }

  Future updateItemStatus() async {
    await FirebaseFirestore.instance.collection("items").doc(idDoc).update({
      "status": status,
    });
  }

  Future addItem() async {
    await FirebaseFirestore.instance.collection("items").doc(idDoc).set({
      "itemCode": itemCode,
      "itemName": itemName,
      "unit": unit,
      "place": place,
      "status": status,
      "createdAt": createdAt,
      "updateAt": updatedAt,
    });
  }

  Future deleteItem() async {
    await FirebaseFirestore.instance.collection("items").doc(idDoc).delete();
  }
}
