import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class SummaryReportBillTable extends StatefulWidget {
  final List transaction;
  const SummaryReportBillTable({super.key, required this.transaction});

  @override
  State<SummaryReportBillTable> createState() => _SummaryReportBillTableState();
}

class _SummaryReportBillTableState extends State<SummaryReportBillTable> {
  @override
  Widget build(BuildContext context) {
    Map<String, num> dineInData = {'qty': 0, 'value': 0, 'billCount': 0};
    Map<String, num> deliveryData = {'qty': 0, 'value': 0, 'billCount': 0};

    // Iterate through transactions and update data
    for (var transaction in widget.transaction) {
      final transactionStatus = transaction['transaction_status'];
      if (transactionStatus == 'sukses') {
        final salesType = transaction['sales_type'];
        final grossAmount = transaction['gross_amount'].toDouble();

        if (salesType == 'Dine In') {
          dineInData['qty'] = (dineInData['qty'] ?? 0) + 1;
          dineInData['value'] =
              (dineInData['value'] ?? 0) + (grossAmount?.toInt() ?? 0);
          dineInData['billCount'] = (deliveryData['billCount'] ?? 0) + 1;
        } else if (salesType == 'Delivery') {
          deliveryData['qty'] = (deliveryData['qty'] ?? 0) + 1;
          deliveryData['value'] =
              (deliveryData['value'] ?? 0) + (grossAmount?.toInt() ?? 0);
          deliveryData['billCount'] = (deliveryData['billCount'] ?? 0) + 1;
        }
      }
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
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Value')),
              DataColumn(label: Text('Average Qty Daily')),
              DataColumn(label: Text('Average Value Daily')),
            ],
            rows: [
              if (dineInData['qty'] != 0 || deliveryData['qty'] != 0)
                DataRow(cells: [
                  const DataCell(Text('Dine In')),
                  DataCell(Text(dineInData['qty'].toString())),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(dineInData['value'], 0))),
                  DataCell(Text(
                      (dineInData['billCount'] ?? 0 / (dineInData['qty'] ?? 1))
                          .toStringAsFixed(0))),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      dineInData['value'] ?? 0 / (dineInData['billCount'] ?? 1),
                      0))),
                ]),
              if (deliveryData['qty'] != 0)
                DataRow(cells: [
                  const DataCell(Text('Delivery')),
                  DataCell(Text(deliveryData['qty'].toString())),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(deliveryData['value'], 0))),
                  DataCell(Text((deliveryData['billCount'] ??
                          0 / (deliveryData['qty'] ?? 1))
                      .toStringAsFixed(0))),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      deliveryData['value'] ??
                          0 / (deliveryData['billCount'] ?? 1),
                      0))),
                ]),
              if (dineInData['qty'] != 0 || deliveryData['qty'] != 0)
                DataRow(cells: [
                  DataCell(Text(
                    'Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  )),
                  DataCell(Text(
                    ((dineInData['qty'] ?? 0) + (deliveryData['qty'] ?? 0))
                        .toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(
                      ((dineInData['value'] ?? 0) +
                              (deliveryData['value'] ?? 0))
                          .toDouble(),
                      0,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  )),
                  DataCell(Text(
                    (((dineInData['billCount'] ?? 0) +
                                (deliveryData['billCount'] ?? 0)) /
                            (((dineInData['qty'] ?? 0) +
                                        (deliveryData['qty'] ?? 0)) ==
                                    0
                                ? 1
                                : ((dineInData['qty'] ?? 0) +
                                    (deliveryData['qty'] ?? 0))))
                        .toStringAsFixed(0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  )),
                  DataCell(
                    Text(
                      CurrencyFormat.convertToIdr(
                        ((dineInData['value'] ??
                                    0 / (dineInData['billCount'] ?? 1)) +
                                (deliveryData['value'] ??
                                    0 / (deliveryData['billCount'] ?? 1)))
                            .toDouble(),
                        0,
                      ),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                  ),
                ]),
            ],
          ),
        ),
        (dineInData['qty'] != 0 || deliveryData['qty'] != 0)
            ? const SizedBox()
            : SizedBox(
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
              )
      ],
    );
  }
}
