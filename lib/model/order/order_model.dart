import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String waiter;
  String cashier;
  String customerName;
  int guest;
  num grossAmount;
  num subTotal;
  num totalAddon;
  num totalDiskonMenu;
  num serviceCharge;
  String salesType;
  num tax;
  num round;
  List pesanan;
  int totalVoucher;
  String tableOrderId;
  String tableNumber;
  String orderTime;
  String orderId;
  String orderStatus;
  String orderType;
  String paymentStatus;
  List tokenFCM;
  List uid;

  OrderModel({
    required this.waiter,
    required this.cashier,
    required this.customerName,
    required this.guest,
    required this.grossAmount,
    required this.subTotal,
    required this.totalAddon,
    required this.totalDiskonMenu,
    required this.serviceCharge,
    required this.salesType,
    required this.tax,
    required this.round,
    required this.pesanan,
    required this.totalVoucher,
    required this.tableOrderId,
    required this.tableNumber,
    required this.orderTime,
    required this.orderId,
    required this.orderStatus,
    required this.orderType,
    required this.paymentStatus,
    required this.tokenFCM,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'waiter': waiter,
      'cashier': cashier,
      'customer_name': customerName,
      'guest': guest,
      'gross_amount': grossAmount,
      'sub_total': subTotal,
      'total_addon': totalAddon,
      'total_diskon_menu': totalDiskonMenu,
      'service_charge': serviceCharge,
      'sales_type': salesType,
      'tax': tax,
      'round': round,
      'pesanan': pesanan,
      'totalVoucher': totalVoucher,
      'tableOrder_id': tableOrderId,
      'table_number': tableNumber,
      'order_time': orderTime,
      'order_id': orderId,
      'order_status': orderStatus,
      'order_type': orderType,
      'payment_status': paymentStatus,
      'uid': uid,
      'tokenFCM': tokenFCM,
    };
  }
}

class OrderFunction {
  String tableNumber;
  OrderFunction({
    required this.tableNumber,
  });
  Future addOrder(OrderModel order, String idDoc) {
    return FirebaseFirestore.instance
        .collection('tables')
        .doc(tableNumber)
        .collection('orders')
        .doc(idDoc)
        .set(order.toMap());
  }

  static Future<void> addCartItemsInCollection(
      String tableNumber, String tableOrderId, List dataCart) async {
    CollectionReference ordersCollection = FirebaseFirestore.instance
        .collection('tables')
        .doc(tableNumber)
        .collection('orders')
        .doc(tableOrderId)
        .collection("pesanan");

    for (int a = 0; a < dataCart.length; a++) {
      // Pastikan menggunakan await di dalam loop
      await ordersCollection.add(dataCart[a]);
    }
  }
}
