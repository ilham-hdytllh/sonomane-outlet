import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class SummaryReportPeriodeTable extends StatefulWidget {
  final List transaction;
  const SummaryReportPeriodeTable({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<SummaryReportPeriodeTable> createState() =>
      _SummaryReportPeriodeTableState();
}

class _SummaryReportPeriodeTableState extends State<SummaryReportPeriodeTable> {
  late List<DataRow> dataRows;

  @override
  void initState() {
    super.initState();
    // Initialize dataRows with the aggregated data
    dataRows = _buildDataRows(context);
  }

  List<DataRow> _buildDataRows(context) {
    // Map to store aggregated data for each time period
    Map<String, Map<String, dynamic>> aggregatedData = {};

    // Initialize data for all periods with default values
    List<String> allPeriods = [
      '00:00 - 05:59',
      '06:00 - 11:59',
      '12:00 - 17:59',
      '18:00 - 23:59',
    ];

    for (var period in allPeriods) {
      aggregatedData[period] = {
        'Qty': 0,
        'ItemSales': 0,
        'DiscountItem': 0,
        'DiscountBill': 0,
        'NetSales': 0,
      };
    }

    // Iterate through transactions to aggregate data
    for (var transaction in widget.transaction) {
      if (transaction["transaction_status"] == "sukses") {
        String period = _getPeriod(transaction['transaction_time']);

        for (var pesanan in transaction["pesanan"]) {
          aggregatedData[period]!['Qty'] += pesanan['quantity'];
          aggregatedData[period]!['ItemSales'] +=
              pesanan['price'] * pesanan['quantity'];
          aggregatedData[period]!['DiscountItem'] +=
              pesanan['price'] * pesanan['quantity'] * pesanan['discount'];
          aggregatedData[period]!['DiscountBill'] +=
              transaction['totalVoucher'];
          aggregatedData[period]!['NetSales'] += (pesanan['price'] -
              (pesanan['price'] * pesanan['quantity'] * pesanan['discount']) -
              transaction['totalVoucher']);
        }
      }
    }

    // Create DataRow widgets based on aggregated data
    List<DataRow> rows = [];

    double totalQty = 0;
    double totalItemSales = 0;
    double totalDiscountItem = 0;
    double totalDiscountBill = 0;
    double totalNetSales = 0;
    aggregatedData.forEach((period, data) {
      totalQty += data['Qty'];
      totalItemSales += data['ItemSales'];
      totalDiscountItem += data['DiscountItem'];
      totalDiscountBill += data['DiscountBill'];
      totalNetSales += data['NetSales'];
      rows.add(DataRow(
        cells: [
          DataCell(Text(period)),
          DataCell(Text(data['Qty'].toStringAsFixed(0))),
          DataCell(Text(data['Qty'] == 0
              ? "0.0%"
              : "${((data['Qty'] / totalQty) * 100).toStringAsFixed(2)}%")),
          DataCell(Text(CurrencyFormat.convertToIdr(data['ItemSales'], 0))),
          DataCell(Text(data['ItemSales'] == 0
              ? "0.0%"
              : "${((data['ItemSales'] / totalItemSales) * 100).toStringAsFixed(2)}%")),
          DataCell(Text(CurrencyFormat.convertToIdr(data['DiscountItem'], 0))),
          DataCell(Text(CurrencyFormat.convertToIdr(data['DiscountBill'], 0))),
          DataCell(Text(CurrencyFormat.convertToIdr(data['NetSales'], 0))),
          DataCell(Text(data['NetSales'] == 0
              ? "0.0%"
              : "${((data['NetSales'] / totalNetSales) * 100).toStringAsFixed(2)}%")),
        ],
      ));
    });

    // Add total row
    rows.add(DataRow(
      cells: [
        DataCell(Text(
          'Total',
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          totalQty.toStringAsFixed(0),
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          "100%",
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          CurrencyFormat.convertToIdr(totalItemSales, 0),
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          "100%",
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          CurrencyFormat.convertToIdr(totalDiscountItem, 0),
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          CurrencyFormat.convertToIdr(totalDiscountBill, 0),
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          CurrencyFormat.convertToIdr(totalNetSales, 0),
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          "100%",
          style: GoogleFonts.nunitoSans(
              fontSize: 14.sp, fontWeight: FontWeight.bold),
        )),
      ],
    ));

    return rows;
  }

  String _getPeriod(String transactionTime) {
    DateTime time = DateTime.parse(transactionTime);

    if (time.hour >= 0 && time.hour < 6) {
      return '00:00 - 05:59';
    } else if (time.hour >= 6 && time.hour < 12) {
      return '06:00 - 11:59';
    } else if (time.hour >= 12 && time.hour < 18) {
      return '12:00 - 17:59';
    } else {
      return '18:00 - 23:59';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if there is any data for any period
    bool hasData = widget.transaction.any((transaction) =>
        transaction["transaction_status"] == "sukses" &&
        _getPeriod(transaction['transaction_time']).isNotEmpty);

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
              DataColumn(label: Text('Period')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('%')),
              DataColumn(label: Text('Item Sales')),
              DataColumn(label: Text('%')),
              DataColumn(label: Text('Discount Item')),
              DataColumn(label: Text('Discount Bill')),
              DataColumn(label: Text('Net Sales')),
              DataColumn(label: Text('%')),
            ],
            rows: hasData ? dataRows : [],
          ),
        ),
        if (!hasData)
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
