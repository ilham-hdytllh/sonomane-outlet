import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class TableWaiterCancelReport extends StatefulWidget {
  final String type;
  final List transaction;
  const TableWaiterCancelReport(
      {super.key, required this.type, required this.transaction});

  @override
  State<TableWaiterCancelReport> createState() =>
      _TableWaiterCancelReportState();
}

class _TableWaiterCancelReportState extends State<TableWaiterCancelReport> {
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
        DataColumn(label: Text('No')),
        DataColumn(label: Text('Waiter')),
        DataColumn(label: Text('#Qty')),
        DataColumn(label: Text('%Qty')),
        DataColumn(label: Text('Total')),
        DataColumn(label: Text('%Total')),
      ],
      rows: _buildRows(),
    );
  }

  List<DataRow> _buildRows() {
    // Filter transactions with 'sukses' status
    List successfulTransactions = widget.transaction
        .where((transaction) => transaction['transaction_status'] == 'gagal')
        .toList();
    int totalQty = 0;
    double totalAmount = 0;
    // Group successful transactions by waiter
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in successfulTransactions) {
      String waiter = transaction['waiter'];
      if (!groupedTransactions.containsKey(waiter)) {
        groupedTransactions[waiter] = [];
      }
      groupedTransactions[waiter]!.add(transaction);
    }

    // Sort transactions within each group by gross_amount
    groupedTransactions.forEach((waiter, transactions) {
      transactions.sort((a, b) => (b['gross_amount'] as num)
          .toDouble()
          .compareTo((a['gross_amount'] as num).toDouble()));
    });

    // Calculate totalQty and totalAmount only once after obtaining all successful transactions
    totalQty = groupedTransactions.values
        .map((transactions) => transactions.length)
        .fold(0, (value, element) => value + element);

    totalAmount = groupedTransactions.values.fold(
        0,
        (num sum, transactions) =>
            sum +
            transactions.fold(
                0,
                (double transSum, transaction) =>
                    transSum +
                    (transaction['gross_amount'] as num).toDouble()));

    // Create rows based on grouped transactions
    List<DataRow> rows = [];

    // Sort groups by total gross_amount
    List<MapEntry<String, List<Map<String, dynamic>>>> sortedGroups =
        groupedTransactions.entries.toList()
          ..sort((a, b) {
            double totalAmountA = a.value.fold(
                0,
                (double sum, transaction) =>
                    sum + (transaction['gross_amount'] as num).toDouble());
            double totalAmountB = b.value.fold(
                0,
                (double sum, transaction) =>
                    sum + (transaction['gross_amount'] as num).toDouble());
            return totalAmountB.compareTo(totalAmountA);
          });

    for (var entry in sortedGroups) {
      String waiter = entry.key;
      List<Map<String, dynamic>> transactions = entry.value;

      double total = transactions.fold(
          0,
          (double sum, transaction) =>
              sum + (transaction['gross_amount'] as num).toDouble());

      rows.add(DataRow(cells: [
        DataCell(Text(rows.length.toString())),
        DataCell(Text(waiter.capitalize())),
        DataCell(Text(transactions.length.toString())),
        DataCell(Text(
            '${((100 / totalQty) * transactions.length).toStringAsFixed(2)}%')),
        DataCell(Text(CurrencyFormat.convertToIdr(total, 0))),
        DataCell(Text('${((100 / totalAmount) * total).toStringAsFixed(2)}%')),
      ]));
    }

    return rows;
  }
}
