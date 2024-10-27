import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String idDoc;
  final String id;
  final String name;

  CategoryModel({
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

class CategoryFunction {
  Stream getAllCategory() {
    return FirebaseFirestore.instance.collection("category").snapshots();
  }

  Future addCategory(CategoryModel category, String idDoc) {
    return FirebaseFirestore.instance
        .collection("category")
        .doc(idDoc)
        .set(category.toMap());
  }

  Future deleteCategory(String idDoc) {
    return FirebaseFirestore.instance
        .collection("category")
        .doc(idDoc)
        .delete();
  }

  Future updateCategory(CategoryModel category, String idDoc) {
    return FirebaseFirestore.instance
        .collection("category")
        .doc(idDoc)
        .update(category.toMap());
  }
}
