import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryInventoryModel {
  String batch;
  String name;
  num quantity;
  String datetime;
  String type;
  String user;

  HistoryInventoryModel({
    required this.batch,
    required this.name,
    required this.quantity,
    required this.datetime,
    required this.type,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      "batch": batch,
      "name": name,
      "quantity": quantity,
      "datetime": datetime,
      "type": type,
      "user": user,
    };
  }
}

class HistoryInventoryFunction {
  Stream getAllHistoryInventory(String type) {
    return FirebaseFirestore.instance
        .collection("history_inventories")
        .where("type", isEqualTo: type)
        .orderBy("datetime", descending: true)
        .snapshots();
  }

  Future addHistoryInventory(HistoryInventoryModel historyInventory) async {
    await FirebaseFirestore.instance
        .collection("history")
        .add(historyInventory.toMap());
  }
}
