import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';

class TableMenuSalesReport extends StatefulWidget {
  final List data;
  final int lengthRow;
  final String type;

  const TableMenuSalesReport({
    Key? key,
    required this.data,
    required this.lengthRow,
    required this.type,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TableMenuSalesReportState createState() => _TableMenuSalesReportState();
}

class _TableMenuSalesReportState extends State<TableMenuSalesReport> {
  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> groupedData = {};
    List<DataRow> rows = [];
    int index = 0;

    for (var order in widget.data) {
      if (order["transaction_status"] == "sukses") {
        for (var pesananItem in order['pesanan']) {
          final String menuName = pesananItem['name'];
          final int quantity = pesananItem['quantity'];
          final num hargaAsli = pesananItem['price'];
          final num diskon = pesananItem['discount'];
          final String cat = pesananItem['category'];
          final String subcat = pesananItem['subcategory'];

          num totalAdditional = 0;

          for (var addon in pesananItem["addons"]) {
            final int quantityAddon = addon['quantity'];
            final num priceAddon = addon['price'];
            totalAdditional += quantityAddon * priceAddon;
          }

          if (groupedData.containsKey(menuName)) {
            groupedData[menuName]!['quantity'] += quantity;
            groupedData[menuName]!['hargaTotal'] += hargaAsli;
            groupedData[menuName]!['grandTotal'] +=
                (hargaAsli + totalAdditional) - (hargaAsli * diskon);
            groupedData[menuName]!['diskon'] += hargaAsli * diskon;
            groupedData[menuName]!['additional'] += totalAdditional;
          } else {
            groupedData[menuName] = {
              'quantity': quantity,
              'hargaTotal': hargaAsli,
              'cat': cat,
              'subcat': subcat,
              'grandTotal':
                  (hargaAsli + totalAdditional) - (hargaAsli * diskon),
              'diskon': (hargaAsli * diskon),
              'additional': totalAdditional,
            };
          }
        }
      }
    }

    // Sort data based on 'Grand Total'
    List<MapEntry<String, Map<String, dynamic>>> sortedData = groupedData
        .entries
        .toList()
      ..sort((a, b) => b.value['grandTotal'].compareTo(a.value['grandTotal']));

    // Clear the rows to rebuild them
    rows.clear();

    for (var entry in sortedData) {
      String menuName = entry.key;
      Map<String, dynamic> data = entry.value;
      rows.add(
        DataRow.byIndex(
          index: index,
          cells: [
            DataCell(SizedBox(
              child: Text(
                (index + 1).toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                menuName.capitalizeSingle(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                data['cat'].toString().capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                data['subcat'].toString().capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                data["quantity"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                CurrencyFormat.convertToIdr(data["hargaTotal"], 0),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                CurrencyFormat.convertToIdr(data["additional"], 0),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                CurrencyFormat.convertToIdr(data['diskon'], 0),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp, color: SonomaneColor.primary),
              ),
            )),
            DataCell(SizedBox(
              child: Text(
                CurrencyFormat.convertToIdr(data["grandTotal"], 0),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            )),
          ],
        ),
      );
      index++;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: 0,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.background),
              headingRowHeight: 50.h,
              dataRowMaxHeight: 50.h,
              dataRowMinHeight: 50.h,
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
                    "Menu",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cat',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sub Cat',
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
                    'Sub Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Additional Price',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Diskon',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Grand Total',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
              rows: rows,
            ),
          ),
          widget.data.isEmpty ? const NoRecord() : const SizedBox(),
        ],
      ),
    );
  }
}
