import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/receipt/receipt_view.dart';

class QrcodeSnap extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function refresh;
  const QrcodeSnap({super.key, required this.data, required this.refresh});

  @override
  State<QrcodeSnap> createState() => _QrcodeSnapState();
}

class _QrcodeSnapState extends State<QrcodeSnap> {
  @override
  void initState() {
    super.initState();
    while (true) {
      FirebaseFirestore.instance
          .collection("transaction")
          .doc(widget.data["transaction_id"])
          .snapshots()
          .listen(
        (event) {
          var a = event['transaction_status'];
          if (a == 'sukses') {
            widget.refresh();
            Notifikasi.successAlert(context, "Pembayaran Berhasil");
            Future.delayed(const Duration(seconds: 4), () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ScreenInvoice(
                        datetime: widget.data["transaction_time"],
                        customerName: widget.data["customer_name"],
                        waiterName: widget.data["waiter"],
                        tableNumber: widget.data["table_number"],
                        cashierName: widget.data["cashier"],
                        pesanan: widget.data["pesanan"],
                        servCharge: widget.data["service_charge"],
                        tax: widget.data["tax"],
                        round: 0,
                        totalBill: widget.data["gross_amount"],
                        grandTotal: widget.data["gross_amount"],
                        subTotal: widget.data["sub_total"],
                        refresh: () {},
                        transactionid: widget.data["transaction_id"],
                        totalVoucher: widget.data["totalVoucher"],
                        discountBill: widget.data["discountBill"],
                      )));
            });
          } else {}
        },
      );
      break;
    }
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
                              color: SonomaneColor.textTitleDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Summary Order',
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
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(30.h),
                      width: 450.h,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.r),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Please Scan to Continue',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontSize: 34.sp),
                          ),
                          Text(
                            'Customer Name : ${widget.data["customer_name"].toString().capitalize()}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 24.sp),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          PrettyQr(
                              size: 380.h,
                              image: const AssetImage(
                                  "assets/images/logo_sonomane-removebg-preview.png"),
                              data: widget.data["transactionRedirectUrl"],
                              elementColor:
                                  Theme.of(context).colorScheme.tertiary),
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            'Gross Amount : ${CurrencyFormat.convertToIdr(widget.data["gross_amount"], 0)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 28.sp,
                                    color: SonomaneColor.primary),
                          ),
                        ],
                      ),
                    ),
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
}
