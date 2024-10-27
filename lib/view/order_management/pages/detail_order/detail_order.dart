import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/order_management/pages/detail_order/order_detail.dart';

class DetailOrderView extends StatelessWidget {
  final String iddoc;
  final String id;
  final String datetime;
  final String namauser;
  final String paymentstatus;
  final String metodepayment;
  final String totalprice;
  final List pesanan;
  final String urlPayment;
  final String transactionstatus;
  final num? cashaccept;
  final num totalVoucher;
  final String tableNumber;
  final String orderid;
  const DetailOrderView(
      {super.key,
      required this.iddoc,
      required this.id,
      required this.datetime,
      required this.namauser,
      required this.paymentstatus,
      required this.metodepayment,
      required this.totalprice,
      required this.pesanan,
      required this.urlPayment,
      required this.transactionstatus,
      this.cashaccept,
      required this.totalVoucher,
      required this.tableNumber,
      required this.orderid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: SizedBox(
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
                    'Transaksi Detail',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.1.w,
                        color: Theme.of(context).colorScheme.outline),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                  child: ScrollConfiguration(
                    behavior: NoGlow(),
                    child: SingleChildScrollView(
                      child: OrderDetail(
                        paymentstatus: paymentstatus,
                        transactionstatus: transactionstatus,
                        urlPayment: urlPayment,
                        iddoc: iddoc,
                        id: id,
                        datetime: datetime,
                        namauser: namauser,
                        pesanan: pesanan,
                        cashaccept: cashaccept,
                        totalVoucher: totalVoucher,
                        tableNumber: tableNumber,
                        orderid: orderid,
                        metodepayment: metodepayment,
                      ),
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
    );
  }
}
