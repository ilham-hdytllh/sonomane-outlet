import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/shared_widget/text_row_summary_repor.dart';

class SummaryReportVoidPayment extends StatefulWidget {
  final List data;
  const SummaryReportVoidPayment({super.key, required this.data});

  @override
  State<SummaryReportVoidPayment> createState() =>
      _SummaryReportVoidPaymentState();
}

class _SummaryReportVoidPaymentState extends State<SummaryReportVoidPayment> {
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
                "Void Payment Summary",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18.sp,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          const RowSummaryReport(
            title: "Void # Payment (s) :",
            numberic: "0",
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Void Amount :",
            numberic: CurrencyFormat.convertToIdr(0, 0),
          ),
        ],
      ),
    );
  }
}
