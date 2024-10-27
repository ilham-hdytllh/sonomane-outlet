import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class SummaryReportSubCategoryTable extends StatefulWidget {
  final List transaction;
  const SummaryReportSubCategoryTable({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<SummaryReportSubCategoryTable> createState() =>
      _SummaryReportSubCategoryTableState();
}

class _SummaryReportSubCategoryTableState
    extends State<SummaryReportSubCategoryTable> {
  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, num>> categoryData = {};

    // Iterate through transactions and update data
    for (var transaction in widget.transaction) {
      final transactionStatus = transaction['transaction_status'];
      if (transactionStatus == 'sukses') {
        final items = transaction['pesanan'];

        for (var item in items) {
          final category = item['subcategory'];
          final quantity = item['quantity'];
          final price = item['price'];
          final discount = item['discount'];

          // Update data for the respective category
          categoryData[category] ??= {
            'qty': 0,
            'value': 0,
            'itemSales': 0,
            'discountItem': 0,
            'discountBill': 0,
            'netSales': 0,
          };

          final salesData = categoryData[category]!;

          salesData['qty'] = (salesData['qty'] ?? 0) + quantity;
          salesData['value'] =
              (salesData['value'] ?? 0) + (price * quantity)?.toInt();
          salesData['itemSales'] =
              (salesData['itemSales'] ?? 0) + (price * quantity)?.toInt();
          salesData['discountItem'] = (salesData['discountItem'] ?? 0) +
              (discount * price * quantity)?.toInt();
          salesData['netSales'] = (salesData['netSales'] ?? 0) +
              ((price * quantity) - discount * price * quantity)?.toInt();
        }
      }
    }

    // Calculate totals
    num totalQty = 0;
    num totalItemSales = 0;
    num totalDiscountItem = 0;
    num totalDiscountBill = 0;
    num totalNetSales = 0;

    if (categoryData.isNotEmpty) {
      // Calculate totals
      totalQty = categoryData.values
          .map((categorySales) => categorySales['qty'] ?? 0)
          .reduce((a, b) => a + b);
      totalItemSales = categoryData.values
          .map((categorySales) => categorySales['itemSales'] ?? 0)
          .reduce((a, b) => a + b);
      totalDiscountItem = categoryData.values
          .map((categorySales) => categorySales['discountItem'] ?? 0)
          .reduce((a, b) => a + b);
      totalDiscountBill = categoryData.values
          .map((categorySales) => categorySales['discountBill'] ?? 0)
          .reduce((a, b) => a + b);
      totalNetSales = categoryData.values
          .map((categorySales) => categorySales['netSales'] ?? 0)
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
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('%')),
              DataColumn(label: Text('Item Sales')),
              DataColumn(label: Text('%')),
              DataColumn(label: Text('Discount Item')),
              DataColumn(label: Text('Discount Bill')),
              DataColumn(label: Text('Net Sales')),
              DataColumn(label: Text('%')),
            ],
            rows: [
              for (var entry in categoryData.entries)
                DataRow(cells: [
                  DataCell(Text(entry.key.toString().capitalize())),
                  DataCell(Text(entry.value['qty'].toString())),
                  DataCell(Text(
                      "${((entry.value['qty'] ?? 0) / totalQty * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      entry.value['itemSales'], 0))),
                  DataCell(Text(
                      "${((entry.value['itemSales'] ?? 0) / totalItemSales * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      entry.value['discountItem'], 0))),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      entry.value['discountBill'], 0))),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(entry.value['netSales'], 0))),
                  DataCell(Text(
                      "${((entry.value['netSales'] ?? 0) / totalNetSales * 100).toStringAsFixed(2)}%")),
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
                    "${100}%",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(totalItemSales, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    "${100}%",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(totalDiscountItem, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(totalDiscountBill, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    CurrencyFormat.convertToIdr(totalNetSales, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    "${100}%",
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
