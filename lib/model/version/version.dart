import 'package:cloud_firestore/cloud_firestore.dart';

class VersionModel {
  String noVersion;
  String datetime;
  List description;
  VersionModel({
    required this.noVersion,
    required this.datetime,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      "version": noVersion,
      "createdAt": datetime,
      "descriptionVersion": description,
    };
  }
}

class VersionFunction {
  Stream<QuerySnapshot> getVersionOutlet() {
    return FirebaseFirestore.instance
        .collection("softwareVersion")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getVersionCustomer() {
    return FirebaseFirestore.instance
        .collection("softwareVersionCustomer")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future deleteVersionOutlet(String idDoc) {
    return FirebaseFirestore.instance
        .collection("softwareVersion")
        .doc(idDoc)
        .delete();
  }

  Future deleteVersionCustomer(String idDoc) {
    return FirebaseFirestore.instance
        .collection("softwareVersionCustomer")
        .doc(idDoc)
        .delete();
  }

  Future addVersionOutlet(VersionModel versionModel, String idDoc) {
    return FirebaseFirestore.instance
        .collection("softwareVersion")
        .doc(idDoc)
        .set(versionModel.toMap());
  }

  Future addVersionCustomer(VersionModel versionModel, String idDoc) {
    return FirebaseFirestore.instance
        .collection("softwareVersionCustomer")
        .doc(idDoc)
        .set(versionModel.toMap());
  }
}
