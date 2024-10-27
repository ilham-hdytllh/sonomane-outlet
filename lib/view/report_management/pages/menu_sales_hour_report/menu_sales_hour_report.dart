import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';

class TableMenuSalesHourReport extends StatefulWidget {
  final List data;
  final int lengthRow;
  final String type;

  const TableMenuSalesHourReport({
    Key? key,
    required this.data,
    required this.lengthRow,
    required this.type,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TableMenuSalesHourReportState createState() =>
      _TableMenuSalesHourReportState();
}

class _TableMenuSalesHourReportState extends State<TableMenuSalesHourReport> {
  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];
    int index = 0;
    Map<String, Map<String, dynamic>> groupedData = {};

    for (var order in widget.data) {
      String transactionTime = order['transaction_time'];

      if (order['transaction_status'] == "sukses") {
        for (var pesananItem in order['pesanan']) {
          final String menuName = pesananItem['name'];
          final int quantity = pesananItem['quantity'];
          final num hargaAsli = pesananItem['price'];

          if (!groupedData.containsKey(menuName)) {
            groupedData[menuName] = {};
          }

          String hour = _takeHour(transactionTime);
          if (groupedData[menuName]!.containsKey(hour)) {
            groupedData[menuName]![hour]['quantity'] += quantity;
            groupedData[menuName]![hour]['hargaTotal'] += hargaAsli;
          } else {
            groupedData[menuName]![hour] = {
              'quantity': quantity,
              'hargaTotal': hargaAsli * quantity,
            };
          }
        }
      }
    }

    groupedData.forEach((menuName, timeData) {
      List<DataCell> cells = [
        DataCell(SizedBox(
          child: Text(
            (index + 1).toString(),
          ),
        )),
        DataCell(SizedBox(
          child: Text(
            menuName.capitalizeSingle(),
          ),
        )),
      ];

      for (int hour = 0; hour < 24; hour++) {
        String hourString = hour.toString().padLeft(2, '0');
        cells.add(
          DataCell(SizedBox(
            child: Text(
              timeData.containsKey(hourString)
                  ? "${CurrencyFormat.convertToIdr(timeData[hourString]['hargaTotal'], 0)} (${timeData[hourString]['quantity']})"
                  : "",
            ),
          )),
        );
      }

      rows.add(DataRow(cells: cells));
      index++;
    });

    // Sort rows based on menuName in ascending order
    rows.sort((row1, row2) {
      String name1 = (row1.cells[1].child as SizedBox).child!.toString();
      String name2 = (row2.cells[1].child as SizedBox).child!.toString();

      // Use toLowerCase() for case-insensitive comparison
      return name1.toLowerCase().compareTo(name2.toLowerCase());
    });

// Update the "No" column after sorting
    for (int i = 0; i < rows.length; i++) {
      rows[i].cells[0] = DataCell(SizedBox(
        child: Text(
          (i + 1).toString(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ScrollConfiguration(
              behavior: NoGloww(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 22.w,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Theme.of(context).colorScheme.background),
                  headingRowHeight: 50.h,
                  dataRowMaxHeight: 50.h,
                  dataRowMinHeight: 50.h,
                  headingTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                  dataTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                  columns: [
                    const DataColumn(
                      label: Text(
                        'No',
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        "Menu",
                      ),
                    ),
                    for (int hour = 0; hour < 24; hour++)
                      DataColumn(
                        label: Text(
                          hour < 10 ? '0$hour:00' : '$hour:00',
                        ),
                      ),
                  ],
                  rows: rows,
                ),
              ),
            ),
          ),
          widget.data.isEmpty ? const NoRecord() : const SizedBox(),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

String _takeHour(String transactionTime) {
  String timestampString = transactionTime;

  // Mengambil jam dari timestamp
  int jam = int.parse(timestampString.split(' ')[1].split(':')[0]);

  // Memastikan bahwa jam selalu memiliki dua digit
  String jamFormatted = jam.toString().padLeft(2, '0');

  return jamFormatted;
}
