import 'package:cloud_firestore/cloud_firestore.dart';

class WaiterOrderModel {
  List orderList;
  String orderTime;
  String customerName;
  String tableOrderID;
  String orderID;
  String orderType;
  String tableNumber;
  WaiterOrderModel(
      {required this.orderList,
      required this.orderTime,
      required this.customerName,
      required this.tableOrderID,
      required this.orderID,
      required this.orderType,
      required this.tableNumber});
}

class WaiterOrderFunction {
  Stream<QuerySnapshot> getWaiterOrder() {
    return FirebaseFirestore.instance
        .collectionGroup('orders')
        .where(
          'order_status',
          whereIn: ['Dimasak', 'Siap Dihidangkan'],
        )
        .orderBy('order_time', descending: true)
        .snapshots();
  }
}
