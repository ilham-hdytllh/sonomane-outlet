import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class TableSalesGrandTotal extends StatefulWidget {
  final List data;

  const TableSalesGrandTotal({Key? key, required this.data}) : super(key: key);

  @override
  State<TableSalesGrandTotal> createState() => _TableSalesGrandTotalState();
}

class _TableSalesGrandTotalState extends State<TableSalesGrandTotal> {
  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, num>> groupedData = {
      'sukses': {
        'count': 0,
        'totalSales': 0,
        'totalDiscount': 0,
        'totalService': 0,
        'totalTax': 0,
        'totalNonTax': 0,
        'grandTotal': 0
      },
      'gagal': {
        'count': 0,
        'totalSales': 0,
        'totalDiscount': 0,
        'totalService': 0,
        'totalTax': 0,
        'totalNonTax': 0,
        'grandTotal': 0
      },
      'void': {
        'count': 0,
        'totalSales': 0,
        'totalDiscount': 0,
        'totalService': 0,
        'totalTax': 0,
        'totalNonTax': 0,
        'grandTotal': 0
      },
    };

    // Grouping data berdasarkan payment_type
    for (var transaction in widget.data) {
      final String transactionStatus = transaction['transaction_status'];
      final num grossAmount =
          transaction['sub_total'] + transaction['total_addon'];
      final num diskon = transaction['total_diskon_menu'];
      final num service = transaction['service_charge'];
      final num tax = transaction['tax'];
      const num nonTax = 0;
      final num grandTotal = transaction['gross_amount'];

      final Map<String, num>? statusData = groupedData[transactionStatus];
      if (statusData != null) {
        statusData['count'] = (statusData['count'] ?? 0) + 1;
        statusData['totalSales'] =
            (statusData['totalSales'] ?? 0) + grossAmount;
        statusData['totalDiscount'] =
            (statusData['totalDiscount'] ?? 0) + diskon;
        statusData['totalService'] =
            (statusData['totalService'] ?? 0) + service;
        statusData['totalTax'] = (statusData['totalTax'] ?? 0) + tax;
        statusData['totalNonTax'] = (statusData['totalNonTax'] ?? 0) + nonTax;
        statusData['grandTotal'] = (statusData['grandTotal'] ?? 0) + grandTotal;
      }
    }

    // Membuat baris untuk setiap payment_type
    List<DataRow> rows = [];
    for (var transactionStatus in ['sukses', 'gagal', 'void']) {
      final Map<String, num>? statusData = groupedData[transactionStatus];
      if (statusData != null) {
        final num totalCount = statusData['count']!;
        final num totalSales = statusData['totalSales']!;
        final num totalDiscount = statusData['totalDiscount']!;
        final num totalService = statusData['totalService']!;
        final num totalTax = statusData['totalTax']!;
        final num totalNonTax = statusData['totalNonTax']!;
        final num grandTotal = statusData['grandTotal']!;

        rows.add(DataRow(
          cells: [
            DataCell(Text(transactionStatus == "sukses"
                ? "Close"
                : transactionStatus == "gagal"
                    ? "Cancel"
                    : "Void")),
            DataCell(Text(totalCount.toString())),
            DataCell(Text(CurrencyFormat.convertToIdr(totalSales, 0))),
            DataCell(Text(CurrencyFormat.convertToIdr(totalDiscount, 0))),
            DataCell(Text(CurrencyFormat.convertToIdr(totalService, 0))),
            DataCell(Text(CurrencyFormat.convertToIdr(totalTax, 0))),
            DataCell(Text(CurrencyFormat.convertToIdr(totalNonTax, 0))),
            DataCell(Text(CurrencyFormat.convertToIdr(grandTotal, 0))),
          ],
        ));
      }
    }

    // Add grand total row
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          showBottomBorder: true,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).colorScheme.background,
          ),
          headingRowHeight: 50.h,
          dataRowMaxHeight: 50.h,
          dataRowMinHeight: 50.h,
          headingTextStyle:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
          columns: const [
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Trans Number')),
            DataColumn(label: Text('Total Sales')),
            DataColumn(label: Text('Total Discount')),
            DataColumn(label: Text('Total s/Charge')),
            DataColumn(label: Text('Total Tax')),
            DataColumn(label: Text('Total Non Tax')),
            DataColumn(label: Text('Grand Total')),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
