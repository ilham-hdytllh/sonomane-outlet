import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sonomaneoutlet/common/extension_round500.dart';
import 'package:sonomaneoutlet/model/transaction/transaction.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/custom_button_icon.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField_no_title.dart';
import 'package:sonomaneoutlet/shared_widget/preview_receipt_dialog.dart';
import 'package:sonomaneoutlet/view/order_payment/widget/card_order_to_pay.dart';
// import 'package:sonomaneoutlet/view/pos_management/pages/payment/qrcode_snap.dart';
import 'package:sonomaneoutlet/view/receipt/receipt_view.dart';

// ignore: must_be_immutable
class CombineTable extends StatefulWidget {
  final List daftarmeja;
  final VoidCallback refresh;
  const CombineTable({
    super.key,
    required this.daftarmeja,
    required this.refresh,
  });

  @override
  State<CombineTable> createState() => _CombineTableState();
}

class _CombineTableState extends State<CombineTable> {
  String _selectPaymentMethod = "debit_bca";
  final List _paymentMethod = [
    {
      "id": 1,
      "image": "assets/images/bca.png",
      "name": "Debit BCA",
      "code": "debit_bca"
    },
    {
      "id": 2,
      "image": "assets/images/mandiri.png",
      "name": "Debit Mandiri",
      "code": "debit_mandiri"
    },
    {
      "id": 3,
      "image": "assets/images/bca.png",
      "name": "Credit BCA",
      "code": "cc_bca"
    },
    {
      "id": 4,
      "image": "assets/images/mandiri.png",
      "name": "Credit Mandiri",
      "code": "cc_mandiri"
    },
    {
      "id": 5,
      "image": "assets/images/go_food.png",
      "name": "Go Food",
      "code": "go_food"
    },
    {
      "id": 6,
      "image": "assets/images/grab_food.png",
      "name": "Grab Food",
      "code": "grab_food"
    },
    {
      "id": 7,
      "image": "assets/images/qris.png",
      "name": "Qris BCA",
      "code": "qris_bca"
    },
    {
      "id": 8,
      "image": "assets/images/qris.png",
      "name": "Qris Mandiri",
      "code": "qris_mandiri"
    }
  ];
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool isLoading = false;
  bool isLoading1 = false;

  //variable numPad
  final List<String> _danaDiterima = [];
  final TextEditingController _duitBayar = TextEditingController();
  final TextEditingController _discountAmount = TextEditingController();
  final List<String> _numPad = [
    '7',
    '8',
    '9',
    '4',
    '5',
    '6',
    '1',
    '2',
    '3',
    '0',
    'C',
    '<-'
  ];

  final List<Map<String, dynamic>> _semuaOrder = [];
  final List _combinedPesanan = [];
  final List _combinedOrderId = [];
  final List _combinedCustomerName = [];
  final List _combinedWaiterName = [];
  final List _combinedTableNumber = [];
  final List _combinedSalesType = [];
  final List _combinedTableOrderId = [];
  final List _combinedTokenFCM = [];
  final List _combinedUID = [];

  num _combineGuest = 1;
  // num _totalVoucher = 0;
  double subTotal = 0;
  double totalDiskonMenu = 0;
  double totalAddons = 0;
  double totalVoucher = 0;
  num discountBill = 0;

  _mergeOrder() {
    for (var order in _semuaOrder) {
      setState(() {
        _combinedPesanan.addAll(order['pesanan']);
        _combinedOrderId.add(order['tableOrderid']);
        _combinedCustomerName.add(order['customer_name']);
        _combinedTableNumber.add(order['table_number']);
        // _totalVoucher += order['totalVoucher'];

        _combinedWaiterName.add(order["waiter"]);
        _combineGuest += order['guest'];
        _combinedSalesType.add(order['sales_type']);
        _combinedTableOrderId.add(order['tableOrder_id']);
        _combinedTokenFCM.addAll(order['tokenFCM']);
        _combinedUID.addAll(order['uid']);
      });
    }
  }

  void _setCalculate() {
    for (int z = 0; z < _semuaOrder.length; z++) {
      totalVoucher += _semuaOrder[z]['totalVoucher'];

      for (var i = 0; i < _semuaOrder[z]['pesanan'].length; i++) {
        for (var a = 0;
            a < _semuaOrder[z]['pesanan'][i]['addons'].length;
            a++) {
          totalAddons += _semuaOrder[z]['pesanan'][i]['addons'][a]['price'] *
              _semuaOrder[z]['pesanan'][i]['quantity'];
        }
        subTotal += (_semuaOrder[z]['pesanan'][i]['price'] *
                _semuaOrder[z]['pesanan'][i]['quantity']) -
            (_semuaOrder[z]['pesanan'][i]['price'] *
                _semuaOrder[z]['pesanan'][i]['quantity'] *
                _semuaOrder[z]['pesanan'][i]['discount']);

        totalDiskonMenu += _semuaOrder[z]['pesanan'][i]['price'] *
            _semuaOrder[z]['pesanan'][i]['quantity'] *
            _semuaOrder[z]['pesanan'][i]['discount'];
      }
    }
    setState(() {});
  }

  Stream? order;

  @override
  void initState() {
    super.initState();

    order = FirebaseFirestore.instance
        .collectionGroup('orders')
        .where("table_number", whereIn: widget.daftarmeja)
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    _semuaOrder;
    _combinedPesanan;
    _combinedOrderId;
    _combinedCustomerName;
    _combinedTableNumber;
    _discountAmount;
    isLoading;
    isLoading1;
    _danaDiterima;
    _duitBayar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              size: 24.sp,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'List Order',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.0.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height *
                                      0.652,
                                  child: StreamBuilder(
                                      stream: order,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'something when eror');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        }

                                        if (snapshot.data!.docs.isNotEmpty) {
                                          final List ordersDocs = [];
                                          snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                            Map a = document.data()
                                                as Map<String, dynamic>;
                                            ordersDocs.add(a);
                                          }).toList();
                                          return ScrollConfiguration(
                                            behavior: NoGloww(),
                                            child: SingleChildScrollView(
                                              child: StaggeredGrid.count(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                children: [
                                                  for (int a = 0;
                                                      a < ordersDocs.length;
                                                      a++) ...{
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (ordersDocs[a][
                                                                'payment_status'] !=
                                                            'telah dibayar') {
                                                          if (_semuaOrder.any(
                                                              (element) =>
                                                                  element[
                                                                      'tableOrder_id'] ==
                                                                  ordersDocs[a][
                                                                      'tableOrder_id'])) {
                                                            _semuaOrder.removeWhere(
                                                                (element) =>
                                                                    element[
                                                                        'tableOrder_id'] ==
                                                                    ordersDocs[
                                                                            a][
                                                                        'tableOrder_id']);
                                                          } else {
                                                            _semuaOrder.add({
                                                              'cashier':
                                                                  ordersDocs[a][
                                                                      'cashier'],
                                                              'customer_name':
                                                                  ordersDocs[a][
                                                                      'customer_name'],
                                                              'gross_amount':
                                                                  ordersDocs[a][
                                                                      'gross_amount'],
                                                              'guest':
                                                                  ordersDocs[a]
                                                                      ['guest'],
                                                              'order_id':
                                                                  ordersDocs[a][
                                                                      'order_id'],
                                                              'order_status':
                                                                  ordersDocs[a][
                                                                      'order_status'],
                                                              'order_time':
                                                                  ordersDocs[a][
                                                                      'order_time'],
                                                              'order_type':
                                                                  ordersDocs[a][
                                                                      'order_type'],
                                                              'payment_status':
                                                                  ordersDocs[a][
                                                                      'payment_status'],
                                                              'pesanan':
                                                                  ordersDocs[a][
                                                                      'pesanan'],
                                                              'round':
                                                                  ordersDocs[a]
                                                                      ['round'],
                                                              'sales_type':
                                                                  ordersDocs[a][
                                                                      'sales_type'],
                                                              'service_charge':
                                                                  ordersDocs[a][
                                                                      'service_charge'],
                                                              'sub_total':
                                                                  ordersDocs[a][
                                                                      'sub_total'],
                                                              'tableOrder_id':
                                                                  ordersDocs[a][
                                                                      'tableOrder_id'],
                                                              'table_number':
                                                                  ordersDocs[a][
                                                                      'table_number'],
                                                              'tax':
                                                                  ordersDocs[a]
                                                                      ['tax'],
                                                              'totalVoucher':
                                                                  ordersDocs[a][
                                                                      'totalVoucher'],
                                                              'total_addon':
                                                                  ordersDocs[a][
                                                                      'total_addon'],
                                                              'total_diskon_menu':
                                                                  ordersDocs[a][
                                                                      'total_diskon_menu'],
                                                              'waiter':
                                                                  ordersDocs[a][
                                                                      'waiter'],
                                                              'tokenFCM':
                                                                  ordersDocs[a][
                                                                      'tokenFCM'],
                                                              'uid':
                                                                  ordersDocs[a]
                                                                      ['uid'],
                                                            });
                                                          }

                                                          _combinedPesanan
                                                              .clear();
                                                          _combinedOrderId
                                                              .clear();
                                                          _combinedCustomerName
                                                              .clear();
                                                          _combinedWaiterName
                                                              .clear();
                                                          _combinedTableNumber
                                                              .clear();
                                                          _combinedSalesType
                                                              .clear();
                                                          _combinedTableOrderId
                                                              .clear();
                                                          _combinedUID.clear();
                                                          _combinedTokenFCM
                                                              .clear();

                                                          _combineGuest = 1;
                                                          // _totalVoucher = 0;
                                                          subTotal = 0;
                                                          totalDiskonMenu = 0;
                                                          totalAddons = 0;
                                                          totalVoucher = 0;

                                                          setState(() {});

                                                          _mergeOrder();
                                                          _setCalculate();
                                                        } else {
                                                          null;
                                                        }
                                                      },
                                                      child: CardOrderToPay(
                                                        semuaOrder: _semuaOrder,
                                                        tableOrderid: ordersDocs[
                                                            a]['tableOrder_id'],
                                                        ordertime: ordersDocs[a]
                                                            ['order_time'],
                                                        pesanan: ordersDocs[a]
                                                            ['pesanan'],
                                                        name: ordersDocs[a]
                                                            ['customer_name'],
                                                        paymentstatus: ordersDocs[
                                                                a]
                                                            ['payment_status'],
                                                        totalVoucher:
                                                            ordersDocs[a][
                                                                'totalVoucher'],
                                                      ),
                                                    ),
                                                  },
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                              'Tidak ada order dimeja ini.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(fontSize: 16.sp),
                                            ),
                                          );
                                        }
                                      }),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                              width: double.infinity,
                              height: 80.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                    child: CustomButtonIcon(
                                      title: "Preview Receipt",
                                      isLoading: false,
                                      bgColor: SonomaneColor.primary,
                                      color: SonomaneColor.textTitleDark,
                                      onTap: () {
                                        _combinedPesanan.isNotEmpty
                                            ? showDialog(
                                                context: context,
                                                builder: (context) {
                                                  String transactionID =
                                                      "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";
                                                  return ScrollConfiguration(
                                                    behavior: NoGloww(),
                                                    child:
                                                        SingleChildScrollView(
                                                      child:
                                                          PreviewReceiptDialog(
                                                        datetime: DateFormat(
                                                                'yyyy-MM-dd HH:mm:ss')
                                                            .format(
                                                          DateTime.now(),
                                                        ),
                                                        customerName:
                                                            _combinedCustomerName
                                                                .join(","),
                                                        waiterName:
                                                            _combinedWaiterName
                                                                .join(","),
                                                        cashierName:
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email!
                                                                .split("@")
                                                                .first,
                                                        tableNumber:
                                                            _combinedTableNumber
                                                                .join(","),
                                                        transactionid:
                                                            transactionID,
                                                        pesanan:
                                                            _combinedPesanan,
                                                        refresh: widget.refresh,
                                                        totalVoucher:
                                                            totalVoucher,
                                                        servCharge:
                                                            subTotal * 0.05,
                                                        tax: (subTotal +
                                                                (subTotal *
                                                                    0.05)) *
                                                            0.1,
                                                        round: 0,
                                                        totalBill: subTotal +
                                                            (subTotal * 0.05) +
                                                            ((subTotal +
                                                                    (subTotal *
                                                                        0.05)) *
                                                                0.1),
                                                        subTotal: subTotal,
                                                        grandTotal: subTotal +
                                                            (subTotal * 0.05) +
                                                            ((subTotal +
                                                                    (subTotal *
                                                                        0.05)) *
                                                                0.1),
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : Notifikasi.warningAlert(context,
                                                "Anda belum memilih pesanan satupun.");
                                      },
                                      icon: Icon(
                                        Icons.receipt_long_rounded,
                                        size: 20.sp,
                                        color: SonomaneColor.textTitleDark,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  // StreamBuilder(
                                  //     stream: order,
                                  //     builder: (context, snapshot) {
                                  //       if (snapshot.hasError) {
                                  //         return const Text("Error database");
                                  //       } else if (snapshot.connectionState ==
                                  //           ConnectionState.waiting) {
                                  //         return const SizedBox();
                                  //       }
                                  //       List data = [];
                                  //       snapshot.data!.docs
                                  //           .map((DocumentSnapshot document) {
                                  //         Map a = document.data()
                                  //             as Map<String, dynamic>;
                                  //         data.add(a);
                                  //       }).toList();
                                  //       return SizedBox(
                                  //         height: 50.h,
                                  //         child: CustomButtonIcon(
                                  //           onTap: () async {
                                  //             List dataBanding = [];

                                  //             for (var order in data) {
                                  //               if (order['payment_status'] ==
                                  //                   "telah dibayar") {
                                  //                 dataBanding.add(
                                  //                     order['payment_status'] ==
                                  //                         "telah dibayar");
                                  //               }
                                  //             }
                                  //             if (data.length ==
                                  //                 dataBanding.length) {
                                  //               await FirebaseFirestore.instance
                                  //                   .collection("tables")
                                  //                   .doc(widget.meja)
                                  //                   .collection("orders")
                                  //                   .get()
                                  //                   .then((value) {
                                  //                 for (DocumentSnapshot ds
                                  //                     in value.docs) {
                                  //                   ds.reference.delete();
                                  //                 }
                                  //               });
                                  //             } else {
                                  //               Notifikasi.warningAlert(context,
                                  //                   "Ada pesanan yang belum \ndibayar !");
                                  //             }
                                  //           },
                                  //           title: 'Hapus Pesanan',
                                  //           color: SonomaneColor.textTitleDark,
                                  //           bgColor: SonomaneColor.primary,
                                  //           isLoading: false,
                                  //           icon: Icon(
                                  //             Icons.delete_rounded,
                                  //             size: 20.sp,
                                  //             color:
                                  //                 SonomaneColor.textTitleDark,
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }),
                                  const Spacer(),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total : ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.sp),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                double.parse((((subTotal +
                                                                    totalAddons) -
                                                                totalVoucher) +
                                                            (((subTotal +
                                                                        totalAddons) -
                                                                    totalVoucher) *
                                                                0.05) +
                                                            ((((subTotal + totalAddons) -
                                                                        totalVoucher) +
                                                                    (((subTotal +
                                                                                totalAddons) -
                                                                            totalVoucher) *
                                                                        0.05)) *
                                                                0.1))
                                                        .toStringAsFixed(1))
                                                    .ceil(),
                                                2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total a/round (Cash Only): ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                roundUpToNearest500(
                                                  ((subTotal + totalAddons) -
                                                          totalVoucher) +
                                                      (((subTotal +
                                                                  totalAddons) -
                                                              totalVoucher) *
                                                          0.05) +
                                                      ((((subTotal + totalAddons) -
                                                                  totalVoucher) +
                                                              (((subTotal +
                                                                          totalAddons) -
                                                                      totalVoucher) *
                                                                  0.05)) *
                                                          0.1),
                                                ),
                                                2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        width: 300.w,
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            SizedBox(
                              height: 50.h,
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                controller: _duitBayar,
                                readOnly: true,
                                cursorColor: Colors.transparent,
                                style: Theme.of(context).textTheme.titleMedium,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  hintStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  hintText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1.5.w),
                                  ),
                                  errorStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: SonomaneColor.primary),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1.5.w),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5.w,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1.5.w),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5.w,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: Center(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12.0,
                                      mainAxisSpacing: 12.0,
                                    ),
                                    itemCount: _numPad.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (_numPad[index] == 'C') {
                                            setState(() {
                                              _danaDiterima.clear();
                                              _duitBayar.clear();
                                            });
                                          } else if (_numPad[index] == '<-') {
                                            if (_danaDiterima.length <= 1) {
                                              setState(() {
                                                _danaDiterima.clear();
                                                _duitBayar.clear();
                                              });
                                            } else {
                                              setState(() {
                                                _danaDiterima.removeLast();

                                                _duitBayar.text = int.parse(
                                                        _danaDiterima.join(""))
                                                    .toString();
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _danaDiterima.add(_numPad[index]);

                                              _duitBayar.text = int.parse(
                                                      _danaDiterima.join(""))
                                                  .toString();
                                            });
                                          }
                                        },
                                        child: ClipRRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer),
                                            child: Center(
                                              child: Text(
                                                _numPad[index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                /////--edited by panji--///////
                                Expanded(
                                  child: CustomFormFieldNoTitle(
                                    readOnly: false,
                                    hintText: 'Discount e.g. 5000',
                                    textInputType: TextInputType.number,
                                    textEditingController: _discountAmount,
                                  ),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  height: 60.h,
                                  child: CustomButton(
                                    isLoading: false,
                                    title: "Apply",
                                    onTap: () {
                                      setState(() {
                                        discountBill = _discountAmount
                                                .text.isEmpty
                                            ? 0
                                            : num.parse(_discountAmount.text);
                                      });
                                    },
                                    color: SonomaneColor.textTitleDark,
                                    bgColor: SonomaneColor.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 65.h,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                SonomaneColor.primary),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer,
                                                  content: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: ScrollConfiguration(
                                                      behavior: NoGloww(),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        _paymentMethod
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            _selectPaymentMethod =
                                                                                _paymentMethod[index]["name"];
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              60.h,
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical: 5.h,
                                                                              horizontal: 10.w),
                                                                          decoration: BoxDecoration(
                                                                              color: _selectPaymentMethod == _paymentMethod[index]["name"] ? SonomaneColor.primary.withOpacity(0.2) : Colors.transparent,
                                                                              borderRadius: BorderRadius.circular(16.r),
                                                                              border: Border.all(width: 1, color: _selectPaymentMethod == _paymentMethod[index]["name"] ? SonomaneColor.primary : Theme.of(context).colorScheme.outline)),
                                                                          child:
                                                                              ListTile(
                                                                            leading:
                                                                                SizedBox(
                                                                              width: 60.w,
                                                                              child: Image.asset(
                                                                                _paymentMethod[index]["image"],
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                            title:
                                                                                Text(
                                                                              _paymentMethod[index]["name"],
                                                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),
                                                                            ),
                                                                            trailing:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  _selectPaymentMethod = _paymentMethod[index]["code"];
                                                                                });
                                                                              },
                                                                              child: Transform.scale(
                                                                                scale: 1,
                                                                                child: Checkbox(
                                                                                  splashRadius: 0,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(3.r),
                                                                                  ),
                                                                                  activeColor: SonomaneColor.primary,
                                                                                  checkColor: SonomaneColor.textTitleDark,
                                                                                  value: _selectPaymentMethod == _paymentMethod[index]["code"],
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      _selectPaymentMethod = _paymentMethod[index]["code"];
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                          SizedBox(
                                                            height: 8.h,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.h,
                                                                    horizontal:
                                                                        10.w),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 60.h,
                                                              child:
                                                                  CustomButton(
                                                                      isLoading:
                                                                          isLoading,
                                                                      title:
                                                                          "Lanjut Bayar",
                                                                      onTap:
                                                                          () async {
                                                                        if (isLoading ==
                                                                                true ||
                                                                            isLoading1 ==
                                                                                true) {
                                                                          null;
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                true;
                                                                          });
                                                                          await paymentOther(
                                                                            double.parse(((((subTotal - discountBill) + totalAddons) - totalVoucher) + ((((subTotal - discountBill) + totalAddons) - totalVoucher) * 0.05) + (((((subTotal - discountBill) + totalAddons) - totalVoucher) + ((((subTotal - discountBill) + totalAddons) - totalVoucher) * 0.05)) * 0.1)).toStringAsFixed(1)).ceil(),
                                                                            (((subTotal - discountBill) + totalAddons) - totalVoucher) *
                                                                                0.05,
                                                                            ((((subTotal - discountBill) + totalAddons) - totalVoucher) + ((((subTotal - discountBill) + totalAddons) - totalVoucher) * 0.05)) *
                                                                                0.1,
                                                                            _combinedPesanan,
                                                                            subTotal,
                                                                            totalAddons,
                                                                            totalDiskonMenu,
                                                                            discountBill,
                                                                          );

                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                false;
                                                                          });
                                                                        }
                                                                      },
                                                                      color: SonomaneColor
                                                                          .textTitleDark,
                                                                      bgColor:
                                                                          SonomaneColor
                                                                              .primary),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            });
                                      },
                                      child: isLoading1 == false
                                          ? Text(
                                              "Other",
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontSize: 14.sp,
                                                      color: SonomaneColor
                                                          .textTitleDark),
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    SonomaneColor.textTitleDark,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 65.h,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                SonomaneColor.primary),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      onPressed: () async {
                                        if (isLoading == true ||
                                            isLoading1 == true) {
                                          null;
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (_semuaOrder.isEmpty) {
                                            Notifikasi.erorAlert(context,
                                                "Anda belum memilih orderan satupun !.");
                                          } else if (_duitBayar.text.isEmpty) {
                                            Notifikasi.erorAlert(context,
                                                "Anda belum menginput nominal pembayaran !.");
                                          } else {
                                            if (_duitBayar.text.isEmpty) {
                                              Notifikasi.erorAlert(context,
                                                  "Anda Belum Memasukkan Nominal !");
                                            } else if (int.parse(
                                                    _duitBayar.text) <
                                                roundUpToNearest500(((subTotal +
                                                            totalAddons) -
                                                        totalVoucher) +
                                                    (((subTotal + totalAddons) -
                                                            totalVoucher) *
                                                        0.05) +
                                                    ((((subTotal + totalAddons) -
                                                                totalVoucher) +
                                                            (((subTotal +
                                                                        totalAddons) -
                                                                    totalVoucher) *
                                                                0.05)) *
                                                        0.1))) {
                                              Notifikasi.erorAlert(context,
                                                  "Nominal Pembayaran Kurang !");
                                            } else {
                                              await paymentTunai(
                                                double.parse(((((subTotal -
                                                                        discountBill) +
                                                                    totalAddons) -
                                                                totalVoucher) +
                                                            ((((subTotal - discountBill) +
                                                                        totalAddons) -
                                                                    totalVoucher) *
                                                                0.05) +
                                                            (((((subTotal - discountBill) +
                                                                            totalAddons) -
                                                                        totalVoucher) +
                                                                    ((((subTotal - discountBill) +
                                                                                totalAddons) -
                                                                            totalVoucher) *
                                                                        0.05)) *
                                                                0.1))
                                                        .toStringAsFixed(1))
                                                    .ceil(),
                                                (((subTotal - discountBill) +
                                                            totalAddons) -
                                                        totalVoucher) *
                                                    0.05,
                                                ((((subTotal - discountBill) +
                                                                totalAddons) -
                                                            totalVoucher) +
                                                        ((((subTotal - discountBill) +
                                                                    totalAddons) -
                                                                totalVoucher) *
                                                            0.05)) *
                                                    0.1,
                                                _combinedPesanan,
                                                int.parse(_duitBayar.text),
                                                subTotal,
                                                totalAddons,
                                                totalDiskonMenu,
                                                discountBill,
                                              );
                                            }
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                      child: isLoading == false
                                          ? Text(
                                              "Cash",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontSize: 14.sp,
                                                      color: SonomaneColor
                                                          .textTitleDark),
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    SonomaneColor.textTitleDark,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              const SonomaneFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // payment order
  paymentOther(num totalAkhir, num servCharge, num ppn, List dataCart,
      num subTotal, num totalAddon, num totalDiskon, num discountBill) async {
    String transactionID =
        "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

    TransactionModel transaction = TransactionModel(
        waiter: _combinedWaiterName.join(","),
        cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
        customerName: _combinedCustomerName.join(","),
        guest: _combineGuest,
        grossAmount: roundUpToNearest500(totalAkhir),
        subTotal: subTotal,
        totalAddon: totalAddon,
        totalDiskonMenu: totalDiskon,
        serviceCharge: servCharge,
        tax: ppn,
        round: totalAkhir,
        pesanan: dataCart,
        totalVoucher: totalVoucher,
        tableNumber: _combinedTableNumber.join(","),
        paymentStatus: 'telah dibayar',
        salesType: _combinedSalesType[0],
        tableOrderId: _combinedTableOrderId.join(","),
        paymentType: _selectPaymentMethod,
        transactionTime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.now(),
        )} +07:00",
        transactionStatus: 'sukses',
        transactionId: transactionID,
        uid: _combinedUID,
        tokenFCM: _combinedTokenFCM,
        combineORno: true,
        discountBill: discountBill);

    try {
      await TransactionFunction().addTransaction(transaction, transactionID);

      for (var dataMeja in widget.daftarmeja) {
        final checkMeja = await FirebaseFirestore.instance
            .collection("tables")
            .doc(dataMeja)
            .get();
        if (checkMeja.exists) {
          for (var data in _combinedTableOrderId) {
            final checkOrder = await FirebaseFirestore.instance
                .collection("tables")
                .doc(dataMeja)
                .collection("orders")
                .doc(data)
                .get();
            if (checkOrder.exists) {
              await FirebaseFirestore.instance
                  .collection("tables")
                  .doc(dataMeja)
                  .collection("orders")
                  .doc(data)
                  .update({"payment_status": "telah dibayar"});
            }
          }
        }
      }
      Map tokenList = {
        "tokenFCM": _combinedTokenFCM,
      };

      // ignore: unused_local_variable, use_build_context_synchronously
      if (_combinedTokenFCM.isNotEmpty) {
        // ignore: use_build_context_synchronously
        await apiBaseHelper.post(
          "$baseUrl/push-notif",
          tokenList,
          context,
        );
      }

      await Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ScreenInvoice(
                  datetime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
                    DateTime.now(),
                  )} +07:00",
                  customerName: _combinedCustomerName.join(","),
                  waiterName: _combinedWaiterName.join(","),
                  tableNumber: _combinedTableNumber.join(","),
                  cashierName: FirebaseAuth.instance.currentUser!.email!
                      .split("@")
                      .first,
                  pesanan: dataCart,
                  servCharge: servCharge,
                  tax: ppn,
                  round: 0,
                  totalBill: totalAkhir,
                  grandTotal: totalAkhir,
                  subTotal: totalAkhir - ppn - servCharge,
                  refresh: widget.refresh,
                  transactionid: transactionID,
                  totalVoucher: totalVoucher,
                  discountBill: discountBill,
                )));
        widget.refresh();
        setState(() {
          _duitBayar.clear();
          _danaDiterima.clear();
        });
      });

      // ignore: use_build_context_synchronously
      Notifikasi.successAlert(context, "Pembayaran Sukses");
    } catch (eror) {
      // ignore: use_build_context_synchronously
      CustomToast.errorToast(context, eror.toString());
    }
  }

  //payment by cash
  paymentTunai(
      num totalAkhir,
      num servCharge,
      num ppn,
      List dataCart,
      int uangDiterima,
      num subTotal,
      num totalAddon,
      num totalDiskon,
      num discountBill) async {
    String transactionID =
        "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

    TransactionModel transaction = TransactionModel(
        waiter: _combinedWaiterName.join(","),
        cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
        customerName: _combinedCustomerName.join(","),
        guest: _combineGuest,
        grossAmount: roundUpToNearest500(totalAkhir),
        subTotal: subTotal,
        totalAddon: totalAddon,
        totalDiskonMenu: totalDiskon,
        serviceCharge: servCharge,
        tax: ppn,
        round: roundUpToNearest500(totalAkhir) - totalAkhir,
        pesanan: dataCart,
        totalVoucher: totalVoucher,
        tableNumber: _combinedTableNumber.join(","),
        paymentStatus: 'telah dibayar',
        salesType: _combinedSalesType[0],
        tableOrderId: _combinedTableOrderId.join(","),
        paymentType: 'tunai',
        transactionTime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.now(),
        )} +07:00",
        transactionStatus: 'sukses',
        cashAccept: uangDiterima,
        change: uangDiterima - roundUpToNearest500(totalAkhir),
        transactionId: transactionID,
        uid: _combinedUID,
        tokenFCM: _combinedTokenFCM,
        combineORno: true,
        discountBill: discountBill);

    try {
      await TransactionFunction().addTransaction(transaction, transactionID);

      for (var dataMeja in widget.daftarmeja) {
        final checkMeja = await FirebaseFirestore.instance
            .collection("tables")
            .doc(dataMeja)
            .get();
        if (checkMeja.exists) {
          for (var data in _combinedTableOrderId) {
            final checkOrder = await FirebaseFirestore.instance
                .collection("tables")
                .doc(dataMeja)
                .collection("orders")
                .doc(data)
                .get();
            if (checkOrder.exists) {
              await FirebaseFirestore.instance
                  .collection("tables")
                  .doc(dataMeja)
                  .collection("orders")
                  .doc(data)
                  .update({"payment_status": "telah dibayar"});
            }
          }
        }
      }

      Map tokenList = {
        "tokenFCM": _combinedTokenFCM,
      };

      // ignore: unused_local_variable, use_build_context_synchronously
      if (_combinedTokenFCM.isNotEmpty) {
        // ignore: use_build_context_synchronously
        await apiBaseHelper.post(
          "$baseUrl/push-notif",
          tokenList,
          context,
        );
      }

      await Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ScreenInvoice(
                  datetime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
                    DateTime.now(),
                  )} +07:00",
                  customerName: _combinedCustomerName.join(","),
                  waiterName: _combinedWaiterName.join(","),
                  tableNumber: _combinedTableNumber.join(","),
                  cashierName: FirebaseAuth.instance.currentUser!.email!
                      .split("@")
                      .first,
                  pesanan: dataCart,
                  servCharge: servCharge,
                  tax: ppn,
                  round: roundUpToNearest500(totalAkhir) - totalAkhir,
                  totalBill: roundUpToNearest500(totalAkhir) -
                      (roundUpToNearest500(totalAkhir) - totalAkhir),
                  grandTotal: roundUpToNearest500(totalAkhir),
                  subTotal: roundUpToNearest500(totalAkhir) -
                      (roundUpToNearest500(totalAkhir) - totalAkhir) -
                      ppn -
                      servCharge,
                  refresh: widget.refresh,
                  transactionid: transactionID,
                  cashaccept: uangDiterima,
                  totalVoucher: totalVoucher,
                  discountBill: discountBill,
                )));
        widget.refresh();
        setState(() {
          _duitBayar.clear();
          _danaDiterima.clear();
        });
      });

      // ignore: use_build_context_synchronously
      Notifikasi.successAlert(context, "Pembayaran Sukses");
    } catch (eror) {
      // ignore: use_build_context_synchronously
      CustomToast.errorToast(context, eror.toString());
    }
  }

  // //payment by midtrans
  // paymentMidtrans(num totalAkhir, num servCharge, num ppn, List dataCart,
  //     num subTotal, num totalAddon, num totalDiskon) async {
  //   String transactionID =
  //       "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

  //   TransactionModel transaction = TransactionModel(
  //     waiter: _combinedWaiterName.toSet().toList().join(", "),
  //     cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
  //     customerName: _combinedCustomerName.join(", "),
  //     guest: _combineGuest,
  //     grossAmount: totalAkhir,
  //     subTotal: subTotal,
  //     totalAddon: totalAddon,
  //     totalDiskonMenu: totalDiskon,
  //     serviceCharge: servCharge,
  //     tax: ppn,
  //     round: 0,
  //     pesanan: dataCart,
  //     totalVoucher: totalVoucher,
  //     tableNumber: _combinedTableNumber.toSet().toList().join(", "),
  //     paymentStatus: 'belum dibayar',
  //     salesType: _combinedSalesType[0],
  //     tableOrderId: _combinedTableOrderId.join(", "),
  //     paymentType: 'payment gateway',
  //     transactionTime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
  //       DateTime.now(),
  //     )} +07:00",
  //     transactionStatus: 'pending',
  //     transactionId: transactionID,
  //     uid: _combinedUID,
  //     tokenFCM: _combinedTokenFCM,
  //     combineORno: true,
  //   );

  //   try {
  //     // hapus semua keranjang
  //     await FirebaseFirestore.instance
  //         .collection('cartspos')
  //         .get()
  //         .then((snapshot) {
  //       for (DocumentSnapshot ds in snapshot.docs) {
  //         ds.reference.delete();
  //       }
  //     });

  //     // ignore: use_build_context_synchronously
  //     final response = await apiBaseHelper.post(
  //       "$baseUrl/transaction/snap-pos",
  //       transaction.toMap(),
  //       context,
  //     );

  //     if (response["status_code"] == 200) {
  //       Map<String, dynamic> callback = response["data"];
  //       // ignore: use_build_context_synchronously
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) =>
  //             QrcodeSnap(data: callback, refresh: widget.refresh),
  //       ));
  //       debugPrint(callback["transactionRedirectUrl"]);
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       Notifikasi.erorAlert(context, "Transaksi Gagal");
  //     }

  //     // _virtualpages(
  //     //   hasil: response['redirectURL'].toString(),
  //     //   orderid: response['transaction_id'].toString(),
  //     //   grossamount:
  //     //       CurrencyFormat.convertToIdr(response['gross_amount'], 2).toString(),
  //     // );

  //     widget.refresh;
  //   } catch (eror) {
  //     // ignore: use_build_context_synchronously
  //     CustomToast.errorToast(context, "Terjadi kesalahan");
  //   }
  // }
}
