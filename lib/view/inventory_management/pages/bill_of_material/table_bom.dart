import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/bill_of_material/update_bom.dart';

// ignore: must_be_immutable
class BOMTable extends StatefulWidget {
  List data;
  BOMTable({super.key, required this.data});

  @override
  State<BOMTable> createState() => _BOMTableState();
}

class _BOMTableState extends State<BOMTable> {
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
              'Code BOM',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Menu ID',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Menu Name',
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
              'Created At',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Last Updated At',
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
          data[index]['codeBOM'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['menuID'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['menuName'].toString().capitalize(),
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
          data[index]['createdAt'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['lastUpdate'],
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
                    Navigator.of(context).push(
                      (MaterialPageRoute(
                        builder: (context) => UpdateBOM(
                          codeBOM: data[index]['codeBOM'],
                          itemsBOM: data[index]['itemsBOM'],
                          menuID: data[index]['menuID'],
                          menuName: data[index]['menuName'],
                          place: data[index]['place'],
                        ),
                      )),
                    );
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
