import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class TableMenuSalesComparisonReport extends StatefulWidget {
  final List transaction;
  final String type;
  const TableMenuSalesComparisonReport(
      {super.key, required this.transaction, required this.type});

  @override
  State<TableMenuSalesComparisonReport> createState() =>
      _TableMenuSalesComparisonReportState();
}

class _TableMenuSalesComparisonReportState
    extends State<TableMenuSalesComparisonReport> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      showBottomBorder: true,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Theme.of(context).colorScheme.background,
      ),
      headingRowHeight: 50.h,
      dataRowMaxHeight: 50.h,
      dataRowMinHeight: 50.h,
      dataTextStyle:
          Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
      headingTextStyle:
          Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Sub Total')),
        DataColumn(label: Text('Additional')),
        DataColumn(label: Text('Discount')),
        DataColumn(label: Text('Grand Total')),
      ],
      rows: _buildRows(),
    );
  }

  List<DataRow> _buildRows() {
    // Group transactions by date
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in widget.transaction) {
      String date = widget.type == "This Year"
          ? DateFormat('MMMM yyyy').format(
              DateTime.parse(transaction['transaction_time'].toString()))
          : DateFormat('EEEE, d MMMM yyyy').format(
              DateTime.parse(transaction['transaction_time'].toString()));
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    // Variables for calculating totals
    int totalQuantity = 0;
    num totalSubTotal = 0;
    num totalAdditional = 0;
    num totalDiscount = 0;
    num totalGrandTotal = 0;

    // Create rows based on grouped transactions
    List<DataRow> rows = [];
    groupedTransactions.forEach((date, transactions) {
      int dateTotalQuantity = 0;
      num dateTotalSubTotal = 0;
      num dateTotalAdditional = 0;
      num dateTotalDiscount = 0;
      num dateTotalGrandTotal = 0;

      for (var transaction in transactions) {
        if (transaction["transaction_status"] == "sukses") {
          transaction['pesanan'].forEach((item) {
            int quantity = item['quantity'];
            num price = item['price'];
            num discount = item['discount'];

            // Calculate values
            num subTotal = price * quantity;
            num additional =
                0; // You need to get additional value from somewhere
            num grossAmount = (price - (price * discount)) * quantity;
            num totalDiscountItem = (price * discount) * quantity;
            num grandTotalItem = grossAmount + totalDiscountItem;

            // Update date totals
            dateTotalQuantity += quantity;
            dateTotalSubTotal += subTotal;
            dateTotalAdditional += additional;
            dateTotalDiscount += totalDiscountItem;
            dateTotalGrandTotal += grandTotalItem;

            // Update overall totals
            totalQuantity += quantity;
            totalSubTotal += subTotal;
            totalAdditional += additional;
            totalDiscount += totalDiscountItem;
            totalGrandTotal += grandTotalItem;
          });
        }
      }

      rows.add(DataRow(cells: [
        DataCell(Text(date)),
        DataCell(Text(dateTotalQuantity.toString())),
        DataCell(Text(CurrencyFormat.convertToIdr(dateTotalSubTotal, 0))),
        DataCell(Text(CurrencyFormat.convertToIdr(dateTotalAdditional, 0))),
        DataCell(Text(CurrencyFormat.convertToIdr(dateTotalDiscount, 0))),
        DataCell(Text(CurrencyFormat.convertToIdr(dateTotalGrandTotal, 0))),
      ]));
    });

    // Add the total row
    rows.add(DataRow(cells: [
      DataCell(Text(
        '####',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        totalQuantity.toString(),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalSubTotal, 0),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalAdditional, 0),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalDiscount, 0),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalGrandTotal, 0),
      )),
    ]));

    return rows;
  }
}
