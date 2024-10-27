import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/shared_widget/text_row_summary_repor.dart';

class SummaryReportMenuCancel extends StatefulWidget {
  final List data;
  const SummaryReportMenuCancel({super.key, required this.data});

  @override
  State<SummaryReportMenuCancel> createState() =>
      _SummaryReportMenuCancelState();
}

class _SummaryReportMenuCancelState extends State<SummaryReportMenuCancel> {
  num _totalCancelQty = 0;
  num _totalCancelValue = 0;

  void _setValue() {
    for (var transaction in widget.data) {
      if (transaction['transaction_status'] == 'gagal') {
        for (var pesanan in transaction['pesanan']) {
          int qty = pesanan['quantity'];
          num cancelPrice =
              (pesanan['price'] - (pesanan['price'] * pesanan['discount'])) *
                  qty;

          // Menghitung totalCancelQty dan totalCancelValue
          _totalCancelQty += qty;
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
                "Cancel Menu Summary",
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
            title: "Cancel # Menu (s) :",
            numberic: _totalCancelQty.toString(),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Total Cancel Amount :",
            numberic: CurrencyFormat.convertToIdr(_totalCancelValue, 0),
          ),
        ],
      ),
    );
  }
}
