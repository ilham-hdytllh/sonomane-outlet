import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';

class TablePaymentReportToday extends StatefulWidget {
  final List data;
  const TablePaymentReportToday({super.key, required this.data});

  @override
  State<TablePaymentReportToday> createState() =>
      _TablePaymentReportTodayState();
}

class _TablePaymentReportTodayState extends State<TablePaymentReportToday> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? PaginatedDataTable(
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const [10],
            onRowsPerPageChanged: (int? value) {
              setState(() {
                _rowsPerPage = value!;
              });
            },
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.background),
            headingRowHeight: 50.h,
            dataRowMaxHeight: 50.h,
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
                  'Date',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Time',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Payment',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Code Trans',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Customer',
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
            source: Paginated(data: widget.data, context: context),
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
                    columns: const [
                      DataColumn(
                        label: Text(
                          'No',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Date',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Time',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Payment',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Code Trans',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Customer',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total Bill',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total Income',
                        ),
                      ),
                      DataColumn(
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
}

class Paginated extends DataTableSource {
  BuildContext context;
  List data;
  Paginated({required this.data, required this.context});

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
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
        DataCell(Text(
          DateFormat("yyyy-MM-dd").format(
            DateTime.parse(data[index]['transaction_time']),
          ),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          DateFormat("HH:mm:ss").format(
            DateTime.parse(data[index]['transaction_time']),
          ),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['payment_type'].toString().capitalizeSingle(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['transaction_id'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['customer_name'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          CurrencyFormat.convertToIdr(data[index]['gross_amount'], 0),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['cash_accept'] != null
              ? CurrencyFormat.convertToIdr(data[index]['cash_accept'], 0)
              : CurrencyFormat.convertToIdr(data[index]['gross_amount'], 0),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['cash_accept'] != null
              ? CurrencyFormat.convertToIdr(
                  data[index]['cash_accept'] - data[index]['gross_amount'], 0)
              : CurrencyFormat.convertToIdr(0, 0),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
