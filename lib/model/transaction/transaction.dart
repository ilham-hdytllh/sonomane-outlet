import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String waiter;
  String cashier;
  String customerName;
  num guest;
  num grossAmount;
  num subTotal;
  num totalAddon;
  num totalDiskonMenu;
  num serviceCharge;
  String salesType;
  num tax;
  num round;
  List pesanan;
  num totalVoucher;
  String paymentType;
  String tableNumber;
  String transactionTime;
  String tableOrderId;
  String transactionStatus;
  String paymentStatus;
  num? cashAccept;
  num? change;
  String transactionId;
  List tokenFCM;
  List uid;
  bool combineORno;
  num discountBill;

  TransactionModel({
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
    required this.paymentType,
    required this.tableNumber,
    required this.transactionTime,
    required this.tableOrderId,
    required this.transactionStatus,
    required this.paymentStatus,
    this.cashAccept,
    this.change,
    required this.transactionId,
    required this.tokenFCM,
    required this.uid,
    required this.combineORno,
    required this.discountBill,
  });

  Map<String, dynamic> toMap() {
    return {
      'waiter': waiter,
      'cashier': cashier,
      'customer_name': customerName, //
      'guest': guest, //
      'gross_amount': grossAmount, //
      'sub_total': subTotal, //
      'total_addon': totalAddon, //
      'total_diskon_menu': totalDiskonMenu, //
      'service_charge': serviceCharge, //
      'sales_type': salesType, //
      'tax': tax, //
      'round': round,
      'change': change,
      'cash_accept': cashAccept,
      'pesanan': pesanan, //
      'totalVoucher': totalVoucher, //
      'payment_type': paymentType, //
      'table_number': tableNumber, //
      'transaction_time': transactionTime, //
      'tableOrder_id': tableOrderId, //
      'transaction_status': transactionStatus,
      'payment_status': paymentStatus, //
      'transaction_id': transactionId, //
      'uid': uid,
      'tokenFCM': tokenFCM,
      'combineORno': combineORno,
      'discountBill': discountBill
    };
  }
}

class TransactionFunction {
  Stream getTransactionFilter(String where) {
    return FirebaseFirestore.instance
        .collection("transaction")
        .orderBy('transaction_time', descending: true)
        .where('transaction_status', isEqualTo: where)
        .snapshots();
  }

  Stream getTransaction() {
    return FirebaseFirestore.instance
        .collection("transaction")
        .orderBy('transaction_time', descending: true)
        .snapshots();
  }

  Future addTransaction(TransactionModel order, String idDoc) {
    return FirebaseFirestore.instance
        .collection('transaction')
        .doc(idDoc)
        .set(order.toMap());
  }
}
