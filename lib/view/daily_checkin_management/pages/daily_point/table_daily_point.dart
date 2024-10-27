import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_point/update_daily_point.dart';

class TableDailyPoint extends StatefulWidget {
  final List data;
  const TableDailyPoint({super.key, required this.data});

  @override
  State<TableDailyPoint> createState() => _TableDailyPointState();
}

class _TableDailyPointState extends State<TableDailyPoint> {
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
            'Day',
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
                widget.data[a]['day'],
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              )),
              DataCell(Text(
                widget.data[a]['points'].toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              )),
              DataCell(
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateDailyPoint(
                          idDoc: widget.data[a]['idDoc'],
                          day: widget.data[a]['day'],
                          point: widget.data[a]['points'],
                        ),
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
              ),
            ],
          ),
        }
      ],
    );
  }
}
