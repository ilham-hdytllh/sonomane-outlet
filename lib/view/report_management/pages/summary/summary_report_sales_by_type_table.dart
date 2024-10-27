import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class SummaryReportSalesByTypeTable extends StatefulWidget {
  final List transaction;
  const SummaryReportSalesByTypeTable({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<SummaryReportSalesByTypeTable> createState() =>
      _SummaryReportSalesByTypeTableState();
}

class _SummaryReportSalesByTypeTableState
    extends State<SummaryReportSalesByTypeTable> {
  @override
  Widget build(BuildContext context) {
    Map<String, num> dineInData = {
      'qty': 0,
      'value': 0,
      'billCount': 0,
      'itemSales': 0,
      'discountItem': 0,
      'discountBill': 0,
      'netSales': 0,
    };

    Map<String, num> deliveryData = {
      'qty': 0,
      'value': 0,
      'billCount': 0,
      'itemSales': 0,
      'discountItem': 0,
      'discountBill': 0,
      'netSales': 0,
    };

// Iterate through transactions and update data
    for (var transaction in widget.transaction) {
      final transactionStatus = transaction['transaction_status'];
      if (transactionStatus == 'sukses') {
        final salesType = transaction['sales_type'];
        final items = transaction['pesanan'];

        if (salesType == 'Dine In' || salesType == 'Delivery') {
          for (var item in items) {
            final quantity = item['quantity'];
            final price = item['price'];
            final discount = item['discount'];

            // Update data for the respective sales type
            final salesData =
                salesType == 'Dine In' ? dineInData : deliveryData;

            salesData['qty'] = (salesData['qty'] ?? 0) + quantity;
            salesData['value'] =
                (salesData['value'] ?? 0) + (price * quantity)?.toInt();
            salesData['itemSales'] =
                (salesData['itemSales'] ?? 0) + (price * quantity)?.toInt();
            salesData['discountItem'] = (salesData['discountItem'] ?? 0) +
                (discount * price * quantity)?.toInt();
          }

          salesType == 'Dine In'
              ? dineInData['billCount'] = (dineInData['billCount'] ?? 0) + 1
              : deliveryData['billCount'] =
                  (deliveryData['billCount'] ?? 0) + 1;

          // Update discountBill and netSales
          dineInData['discountBill'] = (dineInData['discountBill'] ?? 0) +
              (transaction['totalVoucher'] ?? 0);
          deliveryData['discountBill'] = (deliveryData['discountBill'] ?? 0) +
              (transaction['totalVoucher'] ?? 0);

          dineInData['netSales'] = (dineInData['itemSales'] ?? 0) -
              (dineInData['discountItem'] ?? 0) -
              (dineInData['discountBill'] ?? 0);
          deliveryData['netSales'] = (deliveryData['itemSales'] ?? 0) -
              (deliveryData['discountItem'] ?? 0) -
              (deliveryData['discountBill'] ?? 0);
        }
      }
    }
    num totalQty = (dineInData['qty'] ?? 0) + (deliveryData['qty'] ?? 0);
    num totalItemSales =
        (dineInData['itemSales'] ?? 0) + (deliveryData['itemSales'] ?? 0);
    num totalDiscountItem =
        (dineInData['discountItem'] ?? 0) + (deliveryData['discountItem'] ?? 0);
    num totalDiscountBill =
        (dineInData['discountBill'] ?? 0) + (deliveryData['discountBill'] ?? 0);
    num totalNetSales =
        (dineInData['netSales'] ?? 0) + (deliveryData['netSales'] ?? 0);
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
              DataColumn(label: Text('%')),
              DataColumn(label: Text('Item Sales')),
              DataColumn(label: Text('%')),
              DataColumn(label: Text('Discount Item')),
              DataColumn(label: Text('Discount Bill')),
              DataColumn(label: Text('Net Sales')),
              DataColumn(label: Text('%')),
            ],
            rows: [
              if (dineInData['qty'] != 0 || deliveryData['qty'] != 0)
                DataRow(cells: [
                  const DataCell(Text('Dine In')),
                  DataCell(Text(dineInData['qty'].toString())),
                  DataCell(Text(
                      "${((dineInData['qty'] ?? 0) / (((dineInData['qty'] ?? 0) + (deliveryData['qty'] ?? 0)) != 0 ? ((dineInData['qty'] ?? 0) + (deliveryData['qty'] ?? 0)) : 1) * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(dineInData['itemSales'], 0))),
                  DataCell(Text(
                      "${((dineInData['itemSales'] ?? 0) / (((dineInData['itemSales'] ?? 0) + (deliveryData['itemSales'] ?? 0)) != 0 ? ((dineInData['itemSales'] ?? 0) + (deliveryData['itemSales'] ?? 0)) : 1) * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      dineInData['discountItem'], 0))),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      dineInData['discountBill'], 0))),
                  DataCell(Text(
                      CurrencyFormat.convertToIdr(dineInData['netSales'], 0))),
                  DataCell(Text(
                      "${((dineInData['netSales'] ?? 0) / (((dineInData['netSales'] ?? 0) + (deliveryData['netSales'] ?? 0)) != 0 ? ((dineInData['netSales'] ?? 0) + (deliveryData['netSales'] ?? 0)) : 1) * 100).toStringAsFixed(2)}%")),
                ]),
              if (deliveryData['qty'] != 0)
                DataRow(cells: [
                  const DataCell(Text('Delivery')),
                  DataCell(Text(deliveryData['qty'].toString())),
                  DataCell(Text(
                      "${((deliveryData['qty'] ?? 0) / (((dineInData['qty'] ?? 0) + (deliveryData['qty'] ?? 0)) != 0 ? ((dineInData['qty'] ?? 0) + (deliveryData['qty'] ?? 0)) : 1) * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      deliveryData['itemSales'], 0))),
                  DataCell(Text(
                      "${((deliveryData['itemSales'] ?? 0) / (((dineInData['itemSales'] ?? 0) + (deliveryData['itemSales'] ?? 0)) != 0 ? ((dineInData['itemSales'] ?? 0) + (deliveryData['itemSales'] ?? 0)) : 1) * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      deliveryData['discountItem'], 0))),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      deliveryData['discountBill'], 0))),
                  DataCell(Text(CurrencyFormat.convertToIdr(
                      deliveryData['netSales'], 0))),
                  DataCell(Text(
                      "${((deliveryData['netSales'] ?? 0) / (((dineInData['netSales'] ?? 0) + (deliveryData['netSales'] ?? 0)) != 0 ? ((dineInData['netSales'] ?? 0) + (deliveryData['netSales'] ?? 0)) : 1) * 100).toStringAsFixed(2)}%")),
                ]),
              if (dineInData['qty'] != 0 || deliveryData['qty'] != 0)
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
              ),
      ],
    );
  }
}
