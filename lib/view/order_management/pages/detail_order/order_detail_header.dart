import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class OrderDetailHeader extends StatelessWidget {
  final String orderid;
  final String datetime;
  final String urlPayment;
  final List pesanan;
  final String paymentstatus;
  final String tableNumber;
  final String transactionid;
  const OrderDetailHeader({
    super.key,
    required this.orderid,
    required this.datetime,
    required this.urlPayment,
    required this.pesanan,
    required this.paymentstatus,
    required this.tableNumber,
    required this.transactionid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ID Transk #$transactionid',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10.w,
            ),
            // (paymentstatus == 'belum dibayar')
            //     ? IconButton(
            //         icon: Icon(
            //           Icons.edit,
            //           size: 30.sp,
            //           color: Theme.of(context).colorScheme.tertiary,
            //         ),
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => ScreenPosUpdate(
            //                 id: orderid,
            //                 pesanan: pesanan,
            //               ),
            //             ),
            //           );
            //         },
            //       )
            //     : const SizedBox(),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: Theme.of(context).colorScheme.tertiary,
              size: 18.sp,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              'ID Order  :  ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: SonomaneColor.scaffoldColorDark,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  orderid,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14.sp,
                        color: SonomaneColor.textTitleDark,
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
          children: [
            Icon(
              Icons.table_restaurant,
              color: Theme.of(context).colorScheme.tertiary,
              size: 18.sp,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              'No Meja  :  ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: SonomaneColor.scaffoldColorDark,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  tableNumber,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14.sp,
                        color: SonomaneColor.textTitleDark,
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
          children: [
            Text(
              'Tanggal & Waktu Pesan  :  ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: Theme.of(context).colorScheme.tertiary,
              size: 16.sp,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              datetime,
              overflow: TextOverflow.ellipsis,
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
        (urlPayment != '')
            ? PrettyQr(
                size: 150.sp,
                data: urlPayment.toString(),
                roundEdges: true,
                elementColor: Theme.of(context).colorScheme.tertiary,
              )
            : const SizedBox(),
      ],
    );
  }
}
