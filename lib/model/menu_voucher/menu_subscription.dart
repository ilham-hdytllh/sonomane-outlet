import 'package:cloud_firestore/cloud_firestore.dart';

class MenuSubscriptionModel {
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
  final String kitchenOrBar;

  MenuSubscriptionModel({
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
    required this.kitchenOrBar,
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
      "kitchen_or_bar": kitchenOrBar,
    };
  }
}

class MenuSubscriptionFunction {
  Stream getAllMenuSubscription() {
    return FirebaseFirestore.instance
        .collection("menuSubscribtion")
        .snapshots();
  }

  Future addMenuSubscription(MenuSubscriptionModel menuSub, String idDoc) {
    return FirebaseFirestore.instance
        .collection("menuSubscribtion")
        .doc(idDoc)
        .set(menuSub.toMap());
  }

  Future deleteMenuSubscription(String idDoc) {
    return FirebaseFirestore.instance
        .collection("menuSubscribtion")
        .doc(idDoc)
        .delete();
  }

  Future updateMenuSubscription(MenuSubscriptionModel menuSub, String idDoc) {
    return FirebaseFirestore.instance
        .collection("menuSubscribtion")
        .doc(idDoc)
        .update(menuSub.toMap());
  }
}
