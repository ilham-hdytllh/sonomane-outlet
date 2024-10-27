import 'package:cloud_firestore/cloud_firestore.dart';

class TableModel {
  bool ketersediaan;
  String maximumCapacity; //harusnya num tapi jgn diubah dulu takut error
  String status;
  String tableLocation;
  String tableNumber;
  TableModel({
    required this.ketersediaan,
    required this.maximumCapacity,
    required this.status,
    required this.tableLocation,
    required this.tableNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      "ketersediaan": ketersediaan,
      "maximumcapacity": maximumCapacity,
      "status": status,
      "tablelocation": tableLocation,
      "tablenumber": tableNumber,
    };
  }
}

class TableModelFunction {
  Stream<QuerySnapshot> getTable() {
    return FirebaseFirestore.instance.collection('tables').snapshots();
  }

  Future addTable(TableModel tableModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('tables').doc(idDoc).set(
          tableModel.toMap(),
        );
  }

  Future updateTable(TableModel tableModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('tables').doc(idDoc).update(
          tableModel.toMap(),
        );
  }

  Future deleteTable(String idDoc) async {
    await FirebaseFirestore.instance.collection('tables').doc(idDoc).delete();
  }
}
