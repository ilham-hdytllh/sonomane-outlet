import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/view/report_management/pages/payment_report/container_table.dart';

class TableSalesReport extends StatefulWidget {
  final List data;
  final int lengthRow;
  final String type;

  const TableSalesReport(
      {Key? key,
      required this.data,
      required this.lengthRow,
      required this.type})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TableSalesReportState createState() => _TableSalesReportState();
}

class _TableSalesReportState extends State<TableSalesReport> {
  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    if (widget.type == "This Year") {
      for (var transaction in widget.data) {
        final String currentMonth = DateFormat('yyyy-MM')
            .format(DateTime.parse(transaction['transaction_time']));
        if (groupedData.containsKey(currentMonth)) {
          groupedData[currentMonth]!.add(transaction);
        } else {
          groupedData[currentMonth] = [transaction];
        }
      }
    } else {
      for (var transaction in widget.data) {
        final String currentDate =
            transaction['transaction_time'].toString().split(' ')[0];
        if (groupedData.containsKey(currentDate)) {
          groupedData[currentDate]!.add(transaction);
        } else {
          groupedData[currentDate] = [transaction];
        }
      }
    }

    List<DataRow> rows = [];
    int index = 0;
    groupedData.forEach((date, transactions) {
      final List<num> successTotal =
          calculateTotalForDate("sukses", transactions);
      final List<num> cancelTotal =
          calculateTotalForDate("gagal", transactions);
      final List<num> voidsTotal = calculateTotalForDate("void", transactions);

      rows.add(
        DataRow.byIndex(
          index: index,
          cells: [
            DataCell(
              SizedBox(
                child: Text(
                  (index + 1).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
            ),
            DataCell(
              Text(
                widget.type == "This Year"
                    ? DateFormat("MMMM yyyy").format(
                        DateTime.parse(transactions[0]['transaction_time']),
                      )
                    : widget.type == "This Week"
                        ? DateFormat("EEEE, d MMMM yyyy").format(
                            DateTime.parse(transactions[0]['transaction_time']),
                          )
                        : DateFormat("EEEE, d MMMM yyyy").format(
                            DateTime.parse(transactions[0]['transaction_time']),
                          ),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            ),
            const DataCell(
              Column(
                children: [
                  ContainerTable(title: "Close"),
                  ContainerTable(title: "Cancel"),
                  ContainerTable(title: "Void"),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(successTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cancelTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(voidsTotal[0], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(successTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cancelTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(voidsTotal[1], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(successTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cancelTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(voidsTotal[2], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(successTotal[3], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cancelTotal[3], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(voidsTotal[3], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(successTotal[4], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cancelTotal[4], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(voidsTotal[4], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(successTotal[5], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cancelTotal[5], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(voidsTotal[5], 0)),
                ],
              ),
            ),
          ],
        ),
      );
      index++;
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: 0,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.background),
              headingRowHeight: 50.h,
              dataRowMaxHeight: 144.h,
              dataRowMinHeight: 48.h,
              columns: [
                DataColumn(
                  label: Text(
                    'No',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    widget.type != "This Year" ? 'Date' : 'Month',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sub Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Service',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Tax',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Diskon',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Non Tax Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Grand Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
              rows: rows,
            ),
          ),
          widget.data.isEmpty
              ? SizedBox(
                  width: double.infinity,
                  height: 100.h,
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
              : const SizedBox(),
        ],
      ),
    );
  }

  List<num> calculateTotalForDate(
      String transactionStatus, List<Map<String, dynamic>> transactions) {
    num totalBill = 0;
    num totalService = 0;
    num totalTax = 0;
    num totalDiskon = 0;
    num totalNonTax = 0;
    num grandTotal = 0;

    for (var transaction in transactions) {
      if (transaction['transaction_status'] == transactionStatus) {
        totalBill = transaction['sub_total'] + transaction['total_addon'];
        totalDiskon = transaction['total_diskon_menu'];
        totalService = transaction['service_charge'];
        totalTax = transaction['tax'];
        totalNonTax = 0;
        grandTotal = transaction['gross_amount'];
      }
    }

    return [
      totalBill,
      totalService,
      totalTax,
      totalDiskon,
      totalNonTax,
      grandTotal
    ];
  }
}
