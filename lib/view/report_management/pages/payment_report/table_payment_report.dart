import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';
import 'package:sonomaneoutlet/view/report_management/pages/payment_report/container_table.dart';

class TablePaymentReport extends StatefulWidget {
  final List data;
  final int lengthRow;
  final String type;

  const TablePaymentReport(
      {Key? key,
      required this.data,
      required this.lengthRow,
      required this.type})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TablePaymentReportState createState() => _TablePaymentReportState();
}

class _TablePaymentReportState extends State<TablePaymentReport> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = widget.type == "This Week"
        ? 7
        : widget.type == "This Year"
            ? 12
            : 10;
  }

  @override
  void didUpdateWidget(covariant TablePaymentReport oldWidget) {
    _rowsPerPage = widget.type == "This Week"
        ? 7
        : widget.type == "This Year"
            ? 12
            : 10;
    super.didUpdateWidget(oldWidget);
  }

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
      final List<num> cashTotal =
          calculateTotalForDate("tunai", date, transactions);
      final List<num> ccBcaTotal =
          calculateTotalForDate("cc_bca", date, transactions);
      final List<num> ccMandiriTotal =
          calculateTotalForDate("cc_mandiri", date, transactions);
      final List<num> debitBcaTotal =
          calculateTotalForDate("debit_bca", date, transactions);
      final List<num> debitMandiriTotal =
          calculateTotalForDate("debit_mandiri", date, transactions);
      final List<num> goFoodTotal =
          calculateTotalForDate("go_food", date, transactions);
      final List<num> grabTotal =
          calculateTotalForDate("grab_food", date, transactions);
      final List<num> qrisBcaTotal =
          calculateTotalForDate("qris_bca", date, transactions);
      final List<num> qrisMandiriTotal =
          calculateTotalForDate("qris_mandiri", date, transactions);
      final List<num> paymentGateway =
          calculateTotalForDate("payment gateway", date, transactions);

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
                    ? DateFormat('MMMM yyyy').format(
                        DateTime.parse(transactions[0]['transaction_time']))
                    : widget.type == "This Week"
                        ? DateFormat('EEEE, d MMMM yyyy').format(
                            DateTime.parse(transactions[0]['transaction_time']))
                        : DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(
                            transactions[0]['transaction_time'])),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            ),
            const DataCell(
              Column(
                children: [
                  ContainerTable(title: "Tunai"),
                  ContainerTable(title: "CC BCA"),
                  ContainerTable(title: "CC Mandiri"),
                  ContainerTable(title: "Debit BCA"),
                  ContainerTable(title: "Debit Mandiri"),
                  ContainerTable(title: "GoFood"),
                  ContainerTable(title: "GrabFood"),
                  ContainerTable(title: "Qris BCA"),
                  ContainerTable(title: "Qris Mandiri"),
                  ContainerTable(title: "Payment Gateway"),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cashTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(ccBcaTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(ccMandiriTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(debitBcaTotal[0], 0)),
                  ContainerTable(
                      title:
                          CurrencyFormat.convertToIdr(debitMandiriTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(goFoodTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(grabTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(qrisBcaTotal[0], 0)),
                  ContainerTable(
                      title:
                          CurrencyFormat.convertToIdr(qrisMandiriTotal[0], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(paymentGateway[0], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cashTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(ccBcaTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(ccMandiriTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(debitBcaTotal[1], 0)),
                  ContainerTable(
                      title:
                          CurrencyFormat.convertToIdr(debitMandiriTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(goFoodTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(grabTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(qrisBcaTotal[1], 0)),
                  ContainerTable(
                      title:
                          CurrencyFormat.convertToIdr(qrisMandiriTotal[1], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(paymentGateway[1], 0)),
                ],
              ),
            ),
            DataCell(
              Column(
                children: [
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(cashTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(ccBcaTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(ccMandiriTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(debitBcaTotal[2], 0)),
                  ContainerTable(
                      title:
                          CurrencyFormat.convertToIdr(debitMandiriTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(goFoodTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(grabTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(qrisBcaTotal[2], 0)),
                  ContainerTable(
                      title:
                          CurrencyFormat.convertToIdr(qrisMandiriTotal[2], 0)),
                  ContainerTable(
                      title: CurrencyFormat.convertToIdr(paymentGateway[2], 0)),
                ],
              ),
            ),
          ],
        ),
      );
      index++;
    });

    return widget.data.isNotEmpty
        ? PaginatedDataTable(
            columnSpacing: 0,
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: [
              widget.type == "This Week"
                  ? 7
                  : widget.type == "This Year"
                      ? 12
                      : 10
            ],
            onRowsPerPageChanged: (int? value) {
              setState(() {
                _rowsPerPage = value!;
              });
            },
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.background),
            headingRowHeight: 50.h,
            dataRowMaxHeight: 480.h,
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
                  'Payment Type',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total Bill',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total Income',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Change',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
            ],
            source: PaginatedDataTableSource(rows: rows, context: context),
          )
        : Padding(
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
                    dataRowMaxHeight: 432.h,
                    dataRowMinHeight: 48.h,
                    dataTextStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                    headingTextStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                    columns: [
                      const DataColumn(
                        label: Text(
                          'No',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          widget.type != "This Year" ? 'Date' : 'Month',
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Payment Type',
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Total Bill',
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Total Income',
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Change',
                        ),
                      ),
                    ],
                    rows: const [],
                  ),
                ),
                const NoRecord(),
              ],
            ),
          );
  }

  List<num> calculateTotalForDate(String paymentType, String date,
      List<Map<String, dynamic>> transactions) {
    num totalBill = 0;
    num totalIncome = 0;
    num totalChange = 0;

    for (var transaction in transactions) {
      if (transaction["transaction_status"] == "sukses") {
        if (transaction['payment_type'] == paymentType) {
          totalBill += transaction['gross_amount'];

          if (transaction['cash_accept'] != null) {
            totalIncome += transaction['cash_accept'];
          } else {
            totalIncome += transaction['gross_amount'];
          }
          if (transaction['cash_accept'] != null) {
            totalChange +=
                (transaction['cash_accept'] - transaction['gross_amount']);
          }
        }
      }
    }

    return [totalBill, totalIncome, totalChange];
  }
}

class PaginatedDataTableSource extends DataTableSource {
  BuildContext context;
  List<DataRow> rows;
  PaginatedDataTableSource({required this.rows, required this.context});

  @override
  DataRow getRow(int index) {
    return rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}
