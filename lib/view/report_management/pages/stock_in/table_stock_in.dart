import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';

class TableStockIN extends StatefulWidget {
  final List data;
  const TableStockIN({super.key, required this.data});

  @override
  State<TableStockIN> createState() => _TableStockINState();
}

class _TableStockINState extends State<TableStockIN> {
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
                    'Place',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Qty',
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
              ],
              rows: _buildRows(),
            ),
          ),
          widget.data.isEmpty ? const NoRecord() : const SizedBox(),
        ],
      ),
    );
  }

  List<DataRow> _buildRows() {
    Map<String, num> totalQtyMap =
        {}; // Map untuk menyimpan total quantity berdasarkan itemCode

    for (var data in widget.data) {
      String itemCode = data['itemCode'].toString();
      num qty = data['quantity'];

      // Menghitung total quantity untuk setiap itemCode
      if (totalQtyMap.containsKey(itemCode)) {
        totalQtyMap[itemCode] = totalQtyMap[itemCode]! +
            qty; // Menambahkan qty ke totalQtyMap[itemCode]
      } else {
        totalQtyMap[itemCode] =
            qty; // Inisialisasi totalQtyMap[itemCode] jika belum ada
      }
    }

    // Membangun baris DataRow berdasarkan totalQtyMap
    List<DataRow> rows = [];
    int index = 0;

    totalQtyMap.forEach((itemCode, totalQty) {
      rows.add(DataRow(cells: [
        DataCell(
          SizedBox(
            child: Text(
              (index + 1).toString(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
            ),
          ),
        ),
        DataCell(Text(
          itemCode,
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
        )),
        DataCell(Text(
          widget.data
              .firstWhere((data) => data['itemCode'] == itemCode)['itemName']
              .toString()
              .capitalize(),
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
        )),
        DataCell(Text(
          widget.data
              .firstWhere((data) => data['itemCode'] == itemCode)['place']
              .toString()
              .capitalize(),
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
        )),
        DataCell(Text(
          totalQty.toString(), // Menggunakan total quantity
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
        )),
        DataCell(Text(
          widget.data
              .firstWhere((data) => data['itemCode'] == itemCode)['unit']
              .toString()
              .capitalize(),
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
        )),
      ]));
      index++;
    });

    return rows;
  }
}
