import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/loyalty/loyalty.dart';
import 'package:sonomaneoutlet/model/remove_image_storage/remove_image_storage.dart';
import 'package:sonomaneoutlet/view/loyalty_management/pages/update_loyalty_level.dart';

class TableLoyaltyLevel extends StatefulWidget {
  final List data;
  const TableLoyaltyLevel({super.key, required this.data});

  @override
  State<TableLoyaltyLevel> createState() => _TableLoyaltyLevelState();
}

class _TableLoyaltyLevelState extends State<TableLoyaltyLevel> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.background),
      headingRowHeight: 50.h,
      dataRowMaxHeight: 80.h,
      dataRowMinHeight: 65.h,
      dataTextStyle:
          Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.sp),
      headingTextStyle:
          Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.sp),
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
            'Level',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Image',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Point',
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
      rows: [
        for (int a = 0; a < widget.data.length; a++) ...{
          DataRow(
            cells: [
              DataCell(
                SizedBox(
                  child: Text(
                    (a + 1).toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
              ),
              DataCell(Text(
                widget.data[a]['jenis'],
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              )),
              DataCell(
                Image.network(
                  widget.data[a]['image'],
                  fit: BoxFit.contain,
                ),
              ),
              DataCell(Text(
                widget.data[a]['point'].toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              )),
              DataCell(
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpdateLoyaltyLevel(
                                idDoc: widget.data[a]['idDoc'],
                                level: widget.data[a]['jenis'],
                                point: widget.data[a]['point'],
                                image: widget.data[a]['image']),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: SonomaneColor.orange),
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.edit,
                          color: SonomaneColor.textTitleDark,
                          size: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        callback() async {
                          await RemoveImageStorage()
                              .removeImageFromStorage(widget.data[a]['image']);

                          await LoyaltyFunction()
                              .deleteLoyaltyLevel(widget.data[a]['idDoc']);

                          DateTime dateTime = DateTime.now();

                          String idDocHistory =
                              "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                          HistoryLogModel history = HistoryLogModel(
                            idDoc: idDocHistory,
                            date: dateTime.day,
                            month: dateTime.month,
                            year: dateTime.year,
                            dateTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(dateTime),
                            keterangan: "Menghapus level loyalty",
                            user:
                                FirebaseAuth.instance.currentUser!.email ?? "",
                            type: "delete",
                          );

                          HistoryLogModelFunction historyLogFunction =
                              HistoryLogModelFunction(idDocHistory);
                          await historyLogFunction.addHistory(
                              history, idDocHistory);
                        }

                        Notifikasi.warningAlertWithCallback(
                          context,
                          "Yakin ingin menghapus level ini ?",
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
          ),
        }
      ],
    );
  }
}
