import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String idCart;
  String idMenu;
  String name;
  num price;
  num discount;
  String category;
  String subcategory;
  List addons;
  num quantity;
  String noted;
  String image;
  String kitchenOrBar;
  String codeBOM;
  CartModel({
    required this.idCart,
    required this.idMenu,
    required this.name,
    required this.price,
    required this.discount,
    required this.category,
    required this.subcategory,
    required this.addons,
    required this.quantity,
    required this.noted,
    required this.image,
    required this.kitchenOrBar,
    required this.codeBOM,
  });

  Map<String, dynamic> toMap() {
    return {
      "idcart": idCart,
      "idmenu": idMenu,
      "image": image,
      "name": name,
      "price": price,
      "discount": discount,
      "category": category,
      "subcategory": subcategory,
      "addons": addons,
      "quantity": quantity,
      "noted": noted,
      "kitchen_or_bar": kitchenOrBar,
      "codeBOM": codeBOM,
    };
  }
}

class CartModelFunction {
  Stream<QuerySnapshot> getCart() {
    return FirebaseFirestore.instance
        .collection('cartspos')
        .orderBy("name", descending: true)
        .snapshots();
  }

  Future addCart(CartModel cartModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('cartspos').doc(idDoc).set(
          cartModel.toMap(),
        );
  }

  Future updateCart(CartModel cartModel, String idDoc) async {
    await FirebaseFirestore.instance.collection('cartspos').doc(idDoc).update(
          cartModel.toMap(),
        );
  }

  Future deleteCart(String idDoc) async {
    await FirebaseFirestore.instance.collection('cartspos').doc(idDoc).delete();
  }

  Future deleteAllCart() async {
    await FirebaseFirestore.instance
        .collection('cartspos')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
