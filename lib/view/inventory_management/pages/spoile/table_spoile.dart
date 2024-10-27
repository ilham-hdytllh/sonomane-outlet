import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

// ignore: must_be_immutable
class SpoileTable extends StatefulWidget {
  List data;
  SpoileTable({super.key, required this.data});

  @override
  State<SpoileTable> createState() => _SpoileTableState();
}

class _SpoileTableState extends State<SpoileTable> {
  int _rowsPerPage = 9;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: PaginatedDataTable(
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: const [9],
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
              'Item Code',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Item Name',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Quantity',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Unit',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Place',
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
              'Description',
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
          data[index]['itemCode'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['itemName'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['quantity'].toString(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['unit'].toString().capitalize(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['place'].toString().capitalize(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['date'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['description'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          SizedBox(
            width: 90.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: SonomaneColor.orange,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    width: 35.w,
                    height: 35.w,
                    child: Icon(
                      Icons.create,
                      color: SonomaneColor.textTitleDark,
                      size: 15.sp,
                    ),
                  ),
                ),
              ],
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
