import 'package:cloud_firestore/cloud_firestore.dart';

class UnitModel {
  String idDoc;
  String unitCode;
  String unitName;
  bool status;
  String createdAt;
  String updatedAt;

  UnitModel({
    required this.idDoc,
    required this.unitCode,
    required this.unitName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Future getAllUnit() {
    return FirebaseFirestore.instance.collection("units").get();
  }

  Future updateUnit() async {
    await FirebaseFirestore.instance.collection("units").doc(idDoc).update({
      "unitName": unitName,
      "updateAt": updatedAt,
    });
  }

  Future updateUnitStatus() async {
    await FirebaseFirestore.instance.collection("units").doc(idDoc).update({
      "status": status,
      "updateAt": updatedAt,
    });
  }

  Future addUnit() async {
    await FirebaseFirestore.instance.collection("units").doc(idDoc).set({
      "unitCode": unitCode,
      "unitName": unitName,
      "status": status,
      "createdAt": createdAt,
      "updateAt": updatedAt,
    });
  }

  Future deleteUnit() async {
    await FirebaseFirestore.instance.collection("units").doc(idDoc).delete();
  }
}
