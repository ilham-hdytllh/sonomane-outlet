import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/no_record.dart';

class TableMenuCancelReport extends StatefulWidget {
  final List transaction;

  const TableMenuCancelReport({super.key, required this.transaction});

  @override
  State<TableMenuCancelReport> createState() => _TableMenuCancelReportState();
}

class _TableMenuCancelReportState extends State<TableMenuCancelReport> {
  int totalCancelQty = 0;
  double totalCancelValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: DataTable(
            showBottomBorder: true,
            headingRowColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.background,
            ),
            columnSpacing: 20,
            headingRowHeight: 50,
            dataRowMaxHeight: 50,
            dataRowMinHeight: 50,
            dataTextStyle:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
            headingTextStyle:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Menu (Trans Code)')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Cancel Price')),
              DataColumn(label: Text('Table')),
              DataColumn(label: Text('Guest')),
              DataColumn(label: Text('Waiter By')),
              DataColumn(label: Text('Order By')),
              DataColumn(label: Text('Cancel By')),
            ],
            rows: _buildRows(),
          ),
        ),
        widget.transaction.isEmpty ? const NoRecord() : const SizedBox(),
        SizedBox(
          height: 15.h,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 110.h,
            width: 400.w,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Total Cancel Qty : ",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Total Cancel Value : ",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          totalCancelQty.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(totalCancelValue, 0),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
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

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];
    int index = 1;

    for (var transaction in widget.transaction) {
      if (transaction['transaction_status'] == 'gagal') {
        String date = DateFormat("yyyy-MM-dd").format(
          DateTime.parse(transaction['transaction_time']),
        );
        String transCode = transaction['transaction_id'].toString();
        String table = transaction['table_number'].toString();
        String guest = '1'; // Ambil informasi tamu jika ada
        String waiterBy = transaction['waiter'].toString();
        String orderBy = transaction['customer_name'].toString();
        String cancelBy = transaction['cashier'];

        for (var pesanan in transaction['pesanan']) {
          String menuName = pesanan['name'].toString();
          int qty = pesanan['quantity'];
          num cancelPrice =
              (pesanan['price'] - (pesanan['price'] * pesanan['discount'])) *
                  qty;

          // Menghitung totalCancelQty dan totalCancelValue
          totalCancelQty += qty;
          totalCancelValue += cancelPrice.toDouble();

          rows.add(DataRow(cells: [
            DataCell(Text(index.toString())),
            DataCell(Text(date)),
            DataCell(Text('${menuName.capitalizeSingle()} ($transCode)')),
            DataCell(Text(qty.toString())),
            DataCell(Text(cancelPrice.toString())),
            DataCell(Text(table)),
            DataCell(Text(guest)),
            DataCell(Text(waiterBy.capitalize())),
            DataCell(Text(orderBy.capitalize())),
            DataCell(Text(cancelBy.capitalize())),
          ]));

          index++;
        }
      }
    }

    return rows;
  }
}
