import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

// ignore: must_be_immutable
class StockTable extends StatefulWidget {
  List data;
  StockTable({super.key, required this.data});

  @override
  State<StockTable> createState() => _StockTableState();
}

class _StockTableState extends State<StockTable> {
  int _rowsPerPage = 9;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
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
              'Item Name',
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
              'Unit',
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
              'Place',
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
          data[index]['itemName'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['itemCode'],
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
          data[index]['quantity'].toString(),
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
