import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class ListCustomer extends StatefulWidget {
  final List data;
  const ListCustomer({super.key, required this.data});

  @override
  State<ListCustomer> createState() => _ListCustomerState();
}

class _ListCustomerState extends State<ListCustomer> {
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
            'Nama',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Phone',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Email',
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
      source: Paginated(
        data: widget.data,
        context: context,
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
          data[index]['nama'].toString().capitalize(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['phoneNumber'].toString().isNotEmpty
              ? "0${data[index]['phoneNumber'].toString()}"
              : "-",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['email'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['point'].toString(),
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
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => UpdateEmploye(
                  //       name: data[index]["name"],
                  //       email: data[index]["email"],
                  //       role: data[index]["role"],
                  //       idDoc: data[index]["idDoc"],
                  //       createdAt: data[index]["createdAt"],
                  //     ),
                  //   ),
                  // );
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
