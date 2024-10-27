import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/version/version.dart';

class TableVersionCustomer extends StatefulWidget {
  final List data;
  const TableVersionCustomer({super.key, required this.data});

  @override
  State<TableVersionCustomer> createState() => _TableVersionCustomerState();
}

class _TableVersionCustomerState extends State<TableVersionCustomer> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
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
      dataRowMaxHeight: 100.h,
      dataRowMinHeight: 65.h,
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
            'No Version',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Datetime',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Keterangan',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Aksi',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
      ],
      source: Paginated(data: widget.data, context: context),
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
          data[index]['version'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['createdAt'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          SizedBox(
            height: 100.h,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int a = 0;
                        a < data[index]['descriptionVersion'].length;
                        a++) ...{
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle_rounded,
                            size: 12.sp,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            data[index]['descriptionVersion'][a],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    }
                  ],
                ),
              ),
            ),
          ),
        ),
        DataCell(
          GestureDetector(
            onTap: () {
              callback() async {
                await VersionFunction()
                    .deleteVersionCustomer(data[index]['idDoc']);
                DateTime dateTime = DateTime.now();

                String idDocHistory =
                    "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                HistoryLogModel history = HistoryLogModel(
                  idDoc: idDocHistory,
                  date: dateTime.day,
                  month: dateTime.month,
                  year: dateTime.year,
                  dateTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                  keterangan: "Menghapus versi app outlet",
                  user: FirebaseAuth.instance.currentUser!.email ?? "",
                  type: "delete",
                );

                HistoryLogModelFunction historyLogFunction =
                    HistoryLogModelFunction(idDocHistory);
                await historyLogFunction.addHistory(history, idDocHistory);
              }

              Notifikasi.warningAlertWithCallback(
                context,
                "Yakin ingin menghapus versi ini ?",
                callback,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: SonomaneColor.primary),
              width: 35,
              height: 35,
              child: Icon(
                Icons.delete,
                color: SonomaneColor.textTitleDark,
                size: 15.sp,
              ),
            ),
          ),
        ),
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
