import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/common/extension_dateformat.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';

class TableSalesReportToday extends StatefulWidget {
  final List data;
  const TableSalesReportToday({super.key, required this.data});

  @override
  State<TableSalesReportToday> createState() => _TableSalesReportTodayState();
}

class _TableSalesReportTodayState extends State<TableSalesReportToday> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.background),
              headingRowHeight: 50.h,
              dataRowMaxHeight: 50.h,
              dataRowMinHeight: 50.h,
              columnSpacing: 10.w,
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
              rows: [
                for (int index = 0; index < widget.data.length; index++) ...{
                  DataRow(
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
                        DateFormat("yyyy-MM-dd HH:mm:ss").format(
                          DateTime.parse(
                            widget.data[index]['transaction_time']
                                .toString()
                                .removeTimeZoneOffset(),
                          ),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        widget.data[index]['transaction_id'],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        widget.data[index]['customer_name']
                            .toString()
                            .capitalize(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(
                            widget.data[index]['sub_total'] +
                                widget.data[index]['total_addon'],
                            0),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(
                            widget.data[index]['service_charge'], 0),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(
                            widget.data[index]['tax'], 0),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(
                            widget.data[index]['total_diskon_menu'], 0),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(0, 0),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(
                            widget.data[index]['gross_amount'], 0),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )),
                    ],
                  ),
                }
              ],
            ),
          ),
          widget.data.isEmpty ? const NoRecord() : const SizedBox(),
        ],
      ),
    );
  }
}
