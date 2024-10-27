import 'package:cloud_firestore/cloud_firestore.dart';

class AddonModel {
  final String idDoc;
  final String id;
  final String name;
  final num price;

  AddonModel({
    required this.idDoc,
    required this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
    };
  }
}

class AddonFunction {
  Stream getAllAddon() {
    return FirebaseFirestore.instance.collection("addons").snapshots();
  }

  Future addAddon(AddonModel addon, String idDoc) {
    return FirebaseFirestore.instance
        .collection("addons")
        .doc(idDoc)
        .set(addon.toMap());
  }

  Future deleteAddon(String idDoc) {
    return FirebaseFirestore.instance.collection("addons").doc(idDoc).delete();
  }

  Future updateAddon(AddonModel addon, String idDoc) {
    return FirebaseFirestore.instance
        .collection("addons")
        .doc(idDoc)
        .update(addon.toMap());
  }
}
