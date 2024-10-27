import 'package:cloud_firestore/cloud_firestore.dart';

class GetDataOrder {
  static getDataOrder(tablenumber) async {
    List order = [];
    await FirebaseFirestore.instance
        .collection('tables')
        .doc(tablenumber)
        .collection('orders')
        .get()
        .then((value) {
      value.docs.map((data) {
        Map a = data.data();
        order.add(a);
      }).toList();
    });
    return order;
  }
}
