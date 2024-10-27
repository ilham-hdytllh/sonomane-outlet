import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class TableSalesComparisonReport extends StatefulWidget {
  final List transaction;
  final String type;
  const TableSalesComparisonReport(
      {Key? key, required this.transaction, required this.type})
      : super(key: key);

  @override
  State<TableSalesComparisonReport> createState() =>
      _TableSalesComparisonReportState();
}

class _TableSalesComparisonReportState
    extends State<TableSalesComparisonReport> {
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
        DataColumn(label: Text('Trans')),
        DataColumn(label: Text('Gross Sales')),
        DataColumn(label: Text('Cancel Bill')),
        DataColumn(label: Text('Total Cancel')),
        DataColumn(label: Text('Void Bill')),
        DataColumn(label: Text('Total Void')),
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

    // Initialize totals
    int totalSuccessCount = 0;
    double totalSuccessAmount = 0;
    int totalCancelCount = 0;
    double totalCancelAmount = 0;
    int totalVoidCount = 0;
    double totalVoidAmount = 0;

    // Create rows based on grouped transactions
    List<DataRow> rows = [];
    groupedTransactions.forEach((date, transactions) {
      int successCount = 0;
      double successTotalAmount = 0;
      int cancelCount = 0;
      double cancelTotalAmount = 0;
      int voidCount = 0;
      double voidTotalAmount = 0;

      for (var transaction in transactions) {
        if (transaction['transaction_status'] == 'sukses') {
          successCount++;
          successTotalAmount += (transaction['gross_amount'] as num).toDouble();
        } else if (transaction['transaction_status'] == 'gagal') {
          cancelCount++;
          cancelTotalAmount += (transaction['gross_amount'] as num).toDouble();
        } else if (transaction['transaction_status'] == 'void') {
          voidCount++;
          voidTotalAmount += (transaction['gross_amount'] as num).toDouble();
        }
      }

      // Update totals
      totalSuccessCount += successCount;
      totalSuccessAmount += successTotalAmount;
      totalCancelCount += cancelCount;
      totalCancelAmount += cancelTotalAmount;
      totalVoidCount += voidCount;
      totalVoidAmount += voidTotalAmount;

      rows.add(DataRow(cells: [
        DataCell(Text(date)),
        DataCell(Text(successCount.toString())),
        DataCell(Text(CurrencyFormat.convertToIdr(successTotalAmount, 0))),
        DataCell(Text(cancelCount.toString())),
        DataCell(Text(CurrencyFormat.convertToIdr(cancelTotalAmount, 0))),
        DataCell(Text(voidCount.toString())),
        DataCell(Text(CurrencyFormat.convertToIdr(voidTotalAmount, 0))),
      ]));
    });

    // Add row for totals
    rows.add(DataRow(cells: [
      DataCell(Text(
        '####',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        totalSuccessCount.toString(),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalSuccessAmount, 0),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        totalCancelCount.toString(),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalCancelAmount, 0),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        totalVoidCount.toString(),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        CurrencyFormat.convertToIdr(totalVoidAmount, 0),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
      )),
    ]));

    return rows;
  }
}
