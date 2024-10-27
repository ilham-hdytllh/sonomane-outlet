import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

// ignore: must_be_immutable
class AdjustStock extends StatefulWidget {
  List data;
  AdjustStock({super.key, required this.data});

  @override
  State<AdjustStock> createState() => _AdjustStockState();
}

class _AdjustStockState extends State<AdjustStock> {
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
          DataColumn(
            label: Text(
              'Status',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
          DataColumn(
            label: Text(
              'Type',
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
        DataCell(GestureDetector(
          onTap: data[index]['status'] == "input"
              ? () {
                  callback2() async {
                    DocumentSnapshot snapshot = await FirebaseFirestore.instance
                        .collection("stocks")
                        .doc(data[index]['itemCode'])
                        .get();

                    if (snapshot.exists) {
                      num quantity = snapshot['quantity'];
                      if (data[index]['type'] == "out") {
                        if (quantity > data[index]['quantity']) {
                          await FirebaseFirestore.instance
                              .collection("stocks")
                              .doc(data[index]['itemCode'])
                              .update({
                            "quantity":
                                FieldValue.increment(-data[index]['quantity'])
                          });

                          await FirebaseFirestore.instance
                              .collection("adjustmentStock")
                              .doc(data[index]['id'])
                              .update({"status": "confirm"});
                        } else {
                          // ignore: use_build_context_synchronously
                          // Navigator.of(context, rootNavigator: true).pop();
                          // ignore: use_build_context_synchronously
                          Notifikasi.erorAlert(context, "Stock tidak cukup");
                        }
                      } else {
                        await FirebaseFirestore.instance
                            .collection("stocks")
                            .doc(data[index]['itemCode'])
                            .update({
                          "quantity":
                              FieldValue.increment(data[index]['quantity'])
                        });
                        await FirebaseFirestore.instance
                            .collection("adjustmentStock")
                            .doc(data[index]['id'])
                            .update({"status": "confirm"});
                      }
                    } else {
                      if (data[index]['type'] == "out") {
                        // ignore: use_build_context_synchronously
                        // Navigator.of(context, rootNavigator: true).pop();
                        // ignore: use_build_context_synchronously
                        Notifikasi.erorAlert(
                            context, "Item tidak ada di stock");
                      } else {
                        await FirebaseFirestore.instance
                            .collection("stocks")
                            .doc(data[index]['itemCode'])
                            .set({
                          "id": data[index]['id'],
                          "itemName": data[index]['itemName'],
                          "itemCode": data[index]['itemCode'],
                          "unit": data[index]['unit'],
                          "quantity": data[index]["quantity"],
                          "status": "confirm",
                          "type": data[index]['type'],
                          "date": data[index]['date'],
                          "place": data[index]['place'],
                        });
                        await FirebaseFirestore.instance
                            .collection("adjustmentStock")
                            .doc(data[index]['id'])
                            .update({"status": "confirm"});
                      }
                    }
                  }

                  Notifikasi.warningAlertWithCallback(
                      context, "Confirm ?", callback2);
                }
              : () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: data[index]['status'] == "input"
                    ? SonomaneColor.orange
                    : Colors.green),
            height: 35.h,
            width: 100.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data[index]['status'].toString().capitalize(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 14.sp, color: SonomaneColor.textTitleDark),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Icon(
                  Icons.edit,
                  size: 22.sp,
                  color: SonomaneColor.textTitleDark,
                ),
              ],
            ),
          ),
        )),
        DataCell(Text(
          data[index]['type'].toString().capitalize(),
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
