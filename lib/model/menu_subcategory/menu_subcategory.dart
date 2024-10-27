import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  final String idDoc;
  final String id;
  final String name;

  SubCategoryModel({
    required this.idDoc,
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}

class SubCategoryFunction {
  Stream getAllSubCategory() {
    return FirebaseFirestore.instance
        .collection("subcategory")
        .where("name", isNotEqualTo: "semua")
        .snapshots();
  }

  Future addSubCategory(SubCategoryModel subCategory, String idDoc) {
    return FirebaseFirestore.instance
        .collection("subcategory")
        .doc(idDoc)
        .set(subCategory.toMap());
  }

  Future deleteSubCategory(String idDoc) {
    return FirebaseFirestore.instance
        .collection("subcategory")
        .doc(idDoc)
        .delete();
  }

  Future updateSubCategory(SubCategoryModel subCategory, String idDoc) {
    return FirebaseFirestore.instance
        .collection("subcategory")
        .doc(idDoc)
        .update(subCategory.toMap());
  }
}
