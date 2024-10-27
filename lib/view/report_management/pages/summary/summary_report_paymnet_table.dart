import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class SummaryReportPaymentTable extends StatefulWidget {
  final List transaction;
  const SummaryReportPaymentTable({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<SummaryReportPaymentTable> createState() =>
      _SummaryReportPaymentTableState();
}

class _SummaryReportPaymentTableState extends State<SummaryReportPaymentTable> {
  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, num>> categoryData = {};

    // Total quantity variable
    num totalQty = 0;

    // Iterate through transactions and update data
    for (var transaction in widget.transaction) {
      final transactionStatus = transaction['transaction_status'];

      final paymentType = transaction['payment_type'];
      if (transactionStatus == 'sukses') {
        num quantity = 1; // Initialize quantity to 1

        final cashAccept = transaction['cash_accept'] ?? 0; // Handle null
        final grossAmount = transaction['gross_amount'];

        // Update data for the respective category
        categoryData[paymentType] ??= {
          'qty': 0,
          'paidAmount': 0,
          'change': 0,
          'total': 0,
          'percent': 0,
        };

        final salesData = categoryData[paymentType]!;

        // Increment total quantity
        totalQty += quantity;

        salesData['qty'] = (salesData['qty'] ?? 0) + quantity;
        salesData['paidAmount'] = (salesData['paidAmount'] ?? 0) + cashAccept;
        salesData['change'] = 0; // Always set change to 0
        salesData['total'] = (salesData['total'] ?? 0) + grossAmount;
      }
    }

    // Calculate totals
    num totalPaidAmount = 0;
    num totalGrossAmount = 0;
    if (categoryData.isNotEmpty) {
      // Calculate totals
      totalPaidAmount = categoryData.values
          .map((categorySales) => categorySales['paidAmount'] ?? 0)
          .reduce((a, b) => a + b);
      totalGrossAmount = categoryData.values
          .map((categorySales) => categorySales['total'] ?? 0)
          .reduce((a, b) => a + b);
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: DataTable(
            showBottomBorder: true,
            headingRowColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.primaryContainer,
            ),
            columnSpacing: 20,
            headingRowHeight: 45.h,
            dataRowMaxHeight: 45.h,
            dataRowMinHeight: 45.h,
            dataTextStyle: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
            headingTextStyle: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
            columns: const [
              DataColumn(label: Text('Payment Type')),
              DataColumn(label: Text('#Paid')),
              DataColumn(label: Text('Paid Amount')),
              DataColumn(label: Text('Change')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('%/All')),
            ],
            rows: [
              for (var entry in categoryData.entries)
                DataRow(cells: [
                  DataCell(Text(entry.key.toString().capitalize())),
                  DataCell(Text(entry.value['qty'].toString())),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      entry.value['paidAmount'], 0))),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(entry.value['change'], 0))),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(entry.value['total'], 0))),
                  DataCell(Text(
                      "${(((entry.value['total'] ?? 0) / (totalGrossAmount)) * 100).toStringAsFixed(2)}%")),
                ]),
              if (categoryData.isNotEmpty)
                DataRow(cells: [
                  DataCell(Text(
                    'Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    totalQty.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(totalPaidAmount, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    "0", // Always set change to 0 for total row
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(totalGrossAmount, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    "100%",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                ]),
            ],
          ),
        ),
        if (widget.transaction.isEmpty)
          SizedBox(
            height: 50.h,
            width: double.infinity,
            child: Center(
              child: Text(
                "- No Record(s) -",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            ),
          ),
      ],
    );
  }
}
