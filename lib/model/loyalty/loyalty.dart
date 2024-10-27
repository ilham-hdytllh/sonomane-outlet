import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyModel {
  String idDoc;
  String jenis;
  String image;
  int point;
  LoyaltyModel({
    required this.idDoc,
    required this.jenis,
    required this.image,
    required this.point,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": idDoc,
      "image": image,
      "jenis": jenis,
      "point": point,
    };
  }
}

class LoyaltyFunction {
  Stream<QuerySnapshot> getLoyaltyLevel() {
    return FirebaseFirestore.instance
        .collection("membership")
        .orderBy("point", descending: false)
        .snapshots();
  }

  Future deleteLoyaltyLevel(String idDoc) {
    return FirebaseFirestore.instance
        .collection("membership")
        .doc(idDoc)
        .delete();
  }

  Future addLoyaltyLevel(LoyaltyModel loyaltyModel, String idDoc) {
    return FirebaseFirestore.instance
        .collection("membership")
        .doc(idDoc)
        .set(loyaltyModel.toMap());
  }

  Future updateLoyaltyLevel(LoyaltyModel loyaltyModel, String idDoc) {
    return FirebaseFirestore.instance
        .collection("membership")
        .doc(idDoc)
        .update(loyaltyModel.toMap());
  }
}
