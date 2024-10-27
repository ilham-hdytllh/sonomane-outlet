import 'package:flutter/material.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class TablePercentagePayment extends StatefulWidget {
  final List data;

  const TablePercentagePayment({Key? key, required this.data})
      : super(key: key);

  @override
  State<TablePercentagePayment> createState() => _TablePercentagePaymentState();
}

class _TablePercentagePaymentState extends State<TablePercentagePayment> {
  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, num>> groupedData = {};

    // Grouping data berdasarkan payment_type
    for (var transaction in widget.data) {
      if (transaction["transaction_status"] == "sukses") {
        final String paymentType = transaction['payment_type'];
        final num grossAmount = transaction['gross_amount'];
        final num cashAccept = transaction['cash_accept'] ?? 0;
        final num change = transaction['cash_accept'] != null
            ? (transaction['cash_accept'] - transaction['gross_amount'])
            : 0;
        if (groupedData.containsKey(paymentType)) {
          groupedData[paymentType]!['count'] =
              (groupedData[paymentType]!['count'] ?? 0) + 1;
          groupedData[paymentType]!['paidAmount'] =
              (groupedData[paymentType]!['paidAmount'] ?? 0) +
                  (cashAccept == 0 ? grossAmount : cashAccept);
          groupedData[paymentType]!['change'] =
              (groupedData[paymentType]!['change'] ?? 0) + change;
          groupedData[paymentType]!['total'] =
              (groupedData[paymentType]!['total'] ?? 0) +
                  (cashAccept == 0 ? grossAmount : cashAccept - change);
        } else {
          groupedData[paymentType] = {
            'count': 1,
            'paidAmount': cashAccept == 0 ? grossAmount : cashAccept,
            'change': change,
            'total': cashAccept == 0 ? grossAmount : cashAccept - change,
          };
        }
      }
    }

    num grandTotalCount = 0;
    num grandTotalPaidAmount = 0;
    num grandTotalChange = 0;
    num grandTotal = 0;

    num sumOfTotals = groupedData.values
        .map<num>((data) => data['total']!)
        .fold(0, (previous, current) => previous + current);

    // Membuat baris untuk setiap payment_type
    List<DataRow> rows = [];
    groupedData.forEach((paymentType, data) {
      final num totalCount = data['count']!;
      final num totalPaidAmount = data['paidAmount']!;
      final num totalChange = data['change']!;
      final num total = data['total']!;
      final double percentage = total / sumOfTotals * 100;

      // Increment grand total values
      grandTotalCount += totalCount;
      grandTotalPaidAmount += totalPaidAmount;
      grandTotalChange += totalChange;
      grandTotal += total;

      rows.add(DataRow(
        cells: [
          DataCell(Text(paymentType.toString())),
          DataCell(Text(totalCount.toString())),
          DataCell(Text(CurrencyFormat.convertToIdr(totalPaidAmount, 0))),
          DataCell(Text(CurrencyFormat.convertToIdr(totalChange, 0))),
          DataCell(Text(CurrencyFormat.convertToIdr(total, 0))),
          DataCell(Text('${percentage.toStringAsFixed(2)}%')),
        ],
      ));
    }); // Add grand total row
    rows.add(DataRow(
      color: MaterialStateProperty.all(SonomaneColor.secondaryContainerDark),
      cells: [
        const DataCell(Text('Grand Total')),
        DataCell(Text(grandTotalCount.toString())),
        DataCell(Text(CurrencyFormat.convertToIdr(grandTotalPaidAmount, 0))),
        DataCell(Text(CurrencyFormat.convertToIdr(grandTotalChange, 0))),
        DataCell(Text(CurrencyFormat.convertToIdr(grandTotal, 0))),
        const DataCell(Text('100.00%')),
      ],
    ));

    return DataTable(
      showBottomBorder: true,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Theme.of(context).colorScheme.background,
      ),
      headingRowHeight: 50,
      dataRowMaxHeight: 50,
      dataRowMinHeight: 50,
      headingTextStyle:
          Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
      columns: const [
        DataColumn(label: Text('Payment Type')),
        DataColumn(label: Text('#Paid')),
        DataColumn(label: Text('Paid Amount')),
        DataColumn(label: Text('Change')),
        DataColumn(label: Text('Total')),
        DataColumn(label: Text('%/All')),
      ],
      rows: rows,
    );
  }
}
