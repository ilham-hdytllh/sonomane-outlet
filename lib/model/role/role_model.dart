import 'package:cloud_firestore/cloud_firestore.dart';

class RoleModel {
  String role;
  RoleModel({
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      "role": role,
    };
  }
}

class RoleModelFunction {
  Future<QuerySnapshot> getRole() {
    return FirebaseFirestore.instance.collection('role').get();
  }

  Future addRole(RoleModel roleModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('role').doc(idDoc).set(
          roleModel.toMap(),
        );
  }

  Future updateRole(RoleModel roleModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('role').doc(idDoc).update(
          roleModel.toMap(),
        );
  }

  Future deleteRole(String idDoc) async {
    await FirebaseFirestore.instance.collection('role').doc(idDoc).delete();
  }
}
