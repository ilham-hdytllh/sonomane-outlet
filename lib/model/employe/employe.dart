import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeModel {
  String createdAt;
  String email;
  String name;
  String role;
  String uid;
  EmployeModel({
    required this.createdAt,
    required this.email,
    required this.name,
    required this.role,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "email": email,
      "name": name,
      "role": role,
      "uid": uid,
    };
  }
}

class EmployeModelFunction {
  Stream<QuerySnapshot> getEmploye() {
    return FirebaseFirestore.instance
        .collection('users')
        .where("role", isNotEqualTo: "superadmin")
        .snapshots();
  }

  Future addEmploye(EmployeModel employeModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('users').doc(idDoc).set(
          employeModel.toMap(),
        );
  }

  Future updateEmploye(EmployeModel employeModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('users').doc(idDoc).update(
          employeModel.toMap(),
        );
  }

  Future deleteEmploye(String idDoc) async {
    await FirebaseFirestore.instance.collection('users').doc(idDoc).delete();
  }
}
