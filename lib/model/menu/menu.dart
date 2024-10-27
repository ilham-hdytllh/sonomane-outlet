import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  final String idDoc;
  final List addon;
  final String category;
  final String description;
  final num discount;
  final String id;
  final List images;
  final String name;
  final num price;
  final String subcategory;
  final bool recommended;
  final String kitchenORBar;
  final String codeBOM;

  MenuModel({
    required this.idDoc,
    required this.addon,
    required this.category,
    required this.description,
    required this.discount,
    required this.id,
    required this.images,
    required this.name,
    required this.price,
    required this.subcategory,
    required this.recommended,
    required this.kitchenORBar,
    required this.codeBOM,
  });

  Map<String, dynamic> toMap() {
    return {
      "addons": addon,
      "category": category,
      "description": description,
      "discount": discount,
      "id": id,
      "images": images,
      "name": name,
      "price": price,
      "subcategory": subcategory,
      "recommended": recommended,
      "kitchen_or_bar": kitchenORBar,
      'codeBOM': codeBOM,
    };
  }
}

class MenuFunction {
  Stream getAllMenu() {
    return FirebaseFirestore.instance.collection("menu").snapshots();
  }

  Future addMenu(MenuModel menu, String idDoc) {
    return FirebaseFirestore.instance
        .collection("menu")
        .doc(idDoc)
        .set(menu.toMap());
  }

  Future deleteMenu(String idDoc) {
    return FirebaseFirestore.instance.collection("menu").doc(idDoc).delete();
  }

  Future updateMenu(MenuModel menu, String idDoc) {
    return FirebaseFirestore.instance
        .collection("menu")
        .doc(idDoc)
        .update(menu.toMap());
  }
}
