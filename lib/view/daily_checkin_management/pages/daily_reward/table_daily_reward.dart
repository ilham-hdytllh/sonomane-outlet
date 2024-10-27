import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/daily_checkin/daily_reward.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_reward/update_reward_point.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_reward/update_reward_voucher.dart';

class TableDailyReward extends StatefulWidget {
  final List data;
  const TableDailyReward({super.key, required this.data});

  @override
  State<TableDailyReward> createState() => _TableDailyRewardState();
}

class _TableDailyRewardState extends State<TableDailyReward> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.background),
      headingRowHeight: 50.h,
      dataRowMaxHeight: 50.h,
      dataRowMinHeight: 50.h,
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
            'Days to',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Reward Type',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Total Reward',
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
                widget.data[a]['day'].toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              )),
              DataCell(Text(
                widget.data[a]['jenis'].toString().capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              )),
              widget.data[a]['jenis'] == "point"
                  ? DataCell(Text(
                      widget.data[a]['point'].toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 14.sp),
                    ))
                  : DataCell(Text(
                      widget.data[a]['voucherTitle'],
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
                        if (widget.data[a]['jenis'] == "point") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateRewardPoint(
                                image: widget.data[a]['image'],
                                jenis: widget.data[a]['jenis'],
                                idDoc: widget.data[a]['idDoc'],
                                day: widget.data[a]['day'],
                                point: widget.data[a]['point'],
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateRewardVoucher(
                                idDoc: widget.data[a]['idDoc'],
                                image: widget.data[a]['image'],
                                discountPercent: widget.data[a]
                                    ['discountPercent'],
                                expiredDate: widget.data[a]['expiredDate'],
                                day: widget.data[a]['day'],
                                minimumPurchase: widget.data[a]
                                    ['minimumPurchase'],
                                maximumDiscount: widget.data[a]
                                    ['maximumDiscount'],
                                startDateTime: widget.data[a]['startDate'],
                                discountType: widget.data[a]['discountType'],
                                voucherCode: widget.data[a]['voucherCode'],
                                voucherTitle: widget.data[a]['voucherTitle'],
                                voucherType: widget.data[a]['voucherType'],
                                syaratKetentuan: widget.data[a]
                                    ['syaratKetentuan'],
                                caraKerja: widget.data[a]['caraKerja'],
                                createdAt: widget.data[a]["createdAt"],
                                discountAmount: widget.data[a]
                                    ["discountAmount"],
                                used: widget.data[a]["used"],
                                item: widget.data[a]["item"],
                              ),
                            ),
                          );
                        }
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
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        callback() async {
                          await DailyRewardFunction(
                                  dailyRewardModel: "", jenis: "")
                              .deleteDailyReward(widget.data[a]['idDoc']);

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
                            keterangan: "Menghapus daily reward",
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
                          "Yakin ingin menghapus reward ini ?",
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
