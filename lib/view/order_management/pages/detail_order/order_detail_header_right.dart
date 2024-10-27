import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/view/receipt/receipt_view.dart';

class OrderDetailHeaderRight extends StatelessWidget {
  final String iddoc;
  final String transactionid;
  final num? cashaccept;
  final num totalVoucher;
  final String paymentstatus;
  final String transactionstatus;
  final String orderid;
  final String datetime;
  final List pesanan;
  final String nameuser;

  final String metodepayment;
  const OrderDetailHeaderRight({
    super.key,
    required this.iddoc,
    required this.transactionid,
    this.cashaccept,
    required this.totalVoucher,
    required this.paymentstatus,
    required this.transactionstatus,
    required this.orderid,
    required this.datetime,
    required this.pesanan,
    required this.nameuser,
    required this.metodepayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(SonomaneColor.blue),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            ),
          ),
          onPressed: () {
            if (paymentstatus == 'telah dibayar') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScreenInvoice(
                    datetime: datetime,
                    cashierName: nameuser,
                    pesanan: pesanan,
                    transactionid: transactionid,
                    cashaccept: cashaccept,
                    totalVoucher: totalVoucher,
                    refresh: () {},
                    customerName: '',
                    waiterName: '',
                    tableNumber: '',
                    servCharge: 0,
                    tax: 0,
                    round: 0,
                    totalBill: 0,
                    subTotal: 0,
                    grandTotal: 0,
                    discountBill: 0,
                    /*
                      * edited oleh panji
                      * discount bill disini gw kasih 0, buat default aja, gw ngga tau cara dapetinnya gimana,
                      * biar ngga error aja
                    **/
                  ),
                ),
              );
            } else {
              Notifikasi.warningAlert(
                  context, 'Selesaikan pembayaran terlebih dahulu');
            }
          },
          icon: Icon(
            Icons.print,
            size: 18.sp,
            color: SonomaneColor.textTitleDark,
          ),
          label: Text(
            'Print Invoice',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: SonomaneColor.textTitleDark,
                  fontSize: 14.sp,
                ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Metode Pembayaran  :  ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              metodepayment.toString().capitalize(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Status Pembayaran  :  ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
              decoration: BoxDecoration(
                color: paymentstatus == 'telah dibayar'
                    ? Colors.green.withOpacity(0.1)
                    : SonomaneColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  paymentstatus.toString().capitalize(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14.sp,
                        color: paymentstatus == 'telah dibayar'
                            ? Colors.green
                            : SonomaneColor.primary,
                      ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Status Transaksi  :  ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
              decoration: BoxDecoration(
                color: transactionstatus == 'sukses'
                    ? Colors.green.withOpacity(0.1)
                    : SonomaneColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  transactionstatus.toString().capitalize(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14.sp,
                        color: transactionstatus == 'sukses'
                            ? Colors.green
                            : SonomaneColor.primary,
                      ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
