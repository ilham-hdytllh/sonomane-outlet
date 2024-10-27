import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/shared_widget/text_row_summary_repor.dart';

class SummaryReportCancelBill extends StatefulWidget {
  final List data;
  const SummaryReportCancelBill({super.key, required this.data});

  @override
  State<SummaryReportCancelBill> createState() =>
      _SummaryReportCancelBillState();
}

class _SummaryReportCancelBillState extends State<SummaryReportCancelBill> {
  num _totalCancelQty = 0;
  num _totalCancelValue = 0;

  void _setValue() {
    for (var transaction in widget.data) {
      if (transaction['transaction_status'] == 'gagal') {
        // Menghitung totalCancelQty dan totalCancelValue
        _totalCancelQty++;
        for (var pesanan in transaction['pesanan']) {
          int qty = pesanan['quantity'];
          num cancelPrice =
              (pesanan['price'] - (pesanan['price'] * pesanan['discount'])) *
                  qty;

          _totalCancelValue += cancelPrice.toDouble();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setValue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
            width: 0.6.w, color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Theme.of(context).colorScheme.background),
            child: Center(
              child: Text(
                "Cancel Bill Summary",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18.sp,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          RowSummaryReport(
            title: "# Cancel with Menu :",
            numberic: _totalCancelQty.toString(),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Total Cancel with Menu :",
            numberic: CurrencyFormat.convertToIdr(_totalCancelValue, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          const RowSummaryReport(
            title: "# Cancel without Menu :",
            numberic: "0",
          ),
        ],
      ),
    );
  }
}
