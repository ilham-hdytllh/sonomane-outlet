import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/table/table_model.dart';
import 'package:sonomaneoutlet/view/table_management/pages/table/update_table.dart';
import 'package:sonomaneoutlet/view/table_management/widget/dialog_save_qr.dart';

// ignore: must_be_immutable
class ListTable extends StatefulWidget {
  List data;
  ListTable({super.key, required this.data});

  @override
  State<ListTable> createState() => _ListTableState();
}

class _ListTableState extends State<ListTable> {
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
      dataRowMaxHeight: 48.h,
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
            'Nomor Meja',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Lokasi Meja',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Kapasitas',
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
            'Qr Code',
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
          data[index]['tablenumber'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['tablelocation'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['maximumcapacity'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['status'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SaveQRCode(
                      tableNumber: data[index]['tablenumber'],
                    );
                  });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.background,
              ),
              width: 35,
              height: 35,
              child: Icon(
                Icons.qr_code_rounded,
                color: Theme.of(context).colorScheme.tertiary,
                size: 15,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateTable(
                        ketersediaan: data[index]["ketersediaan"],
                        maximumCapacity: data[index]["maximumcapacity"],
                        status: data[index]["status"],
                        tableLocation: data[index]["tablelocation"],
                        tableNumber: data[index]["tablenumber"],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: SonomaneColor.orange,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.create,
                    color: SonomaneColor.textTitleDark,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  callback() async {
                    await TableModelFunction()
                        .deleteTable(data[index]['idDoc']);
                    DateTime dateTime = DateTime.now();

                    String idDocHistory =
                        "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                    HistoryLogModel history = HistoryLogModel(
                      idDoc: idDocHistory,
                      date: dateTime.day,
                      month: dateTime.month,
                      year: dateTime.year,
                      dateTime:
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                      keterangan: "Menghapus table",
                      user: FirebaseAuth.instance.currentUser!.email ?? "",
                      type: "delete",
                    );

                    HistoryLogModelFunction historyLogFunction =
                        HistoryLogModelFunction(idDocHistory);
                    await historyLogFunction.addHistory(history, idDocHistory);
                  }

                  Notifikasi.warningAlertWithCallback(
                    context,
                    "Yakin ingin menghapus table ini ?",
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
            ],
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
