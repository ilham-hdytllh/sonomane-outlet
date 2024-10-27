import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String createdAt;
  String email;
  String name;
  String role;
  String uid;
  String phoneNumber;
  String profilePhoto;
  num point;
  CustomerModel({
    required this.createdAt,
    required this.email,
    required this.name,
    required this.role,
    required this.uid,
    required this.phoneNumber,
    required this.profilePhoto,
    required this.point,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "email": email,
      "nama": name,
      "role": role,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "profilePhoto": profilePhoto,
      "point": point,
    };
  }
}

class CustomerModelFunction {
  Stream<QuerySnapshot> getCustomer() {
    return FirebaseFirestore.instance
        .collection('user_customers')
        .orderBy("nama", descending: false)
        .snapshots();
  }

  Future addCustomer(CustomerModel customerModel, String idDoc) async {
    await FirebaseFirestore.instance
        .collection('user_customers')
        .doc(idDoc)
        .set(
          customerModel.toMap(),
        );
  }

  Future updateCustomer(CustomerModel customerModel, String idDoc) async {
    await FirebaseFirestore.instance
        .collection('user_customers')
        .doc(idDoc)
        .update(
          customerModel.toMap(),
        );
  }

  Future deleteCustomer(String idDoc) async {
    await FirebaseFirestore.instance
        .collection('user_customers')
        .doc(idDoc)
        .delete();
  }
}
