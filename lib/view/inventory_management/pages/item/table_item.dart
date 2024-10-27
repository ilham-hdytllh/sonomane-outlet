import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/inventory/item_inventory.dart';
// import 'package:sonomaneoutlet/view_model/getServerTime.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/item/update_item.dart';

// ignore: must_be_immutable
class ItemTable extends StatefulWidget {
  List data;
  ItemTable({super.key, required this.data});

  @override
  State<ItemTable> createState() => _ItemTableState();
}

class _ItemTableState extends State<ItemTable> {
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
          // DataColumn(
          //   label: Text(
          //     'Status',
          //     style: Theme.of(context)
          //         .textTheme
          //         .titleMedium!
          //         .copyWith(fontSize: 14.sp),
          //   ),
          // ),
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
          data[index]['itemCode'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['itemName'].toString().capitalize(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['unit'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['place'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        // DataCell(
        //   Switch(
        //     activeColor: SonomaneColor.blue,
        //     value: data[index]['status'],
        //     onChanged: (value) async {
        //       await Provider.of<GetServerTime>(context, listen: false)
        //           .getServerTime();
        //       DateTime? waktuServer =
        //           // ignore: use_build_context_synchronously
        //           Provider.of<GetServerTime>(context, listen: false).serverTime;
        //       ItemModel(
        //               place: data[index]["place"],
        //               idDoc: data[index]['idDoc'],
        //               itemCode: data[index]['idDoc'],
        //               itemName: data[index]['itemName'],
        //               unit: data[index]['unit'],
        //               status: value,
        //               updatedAt:
        //                   DateFormat('yyyy-MM-dd HH:mm').format(waktuServer!),
        //               createdAt: '')
        //           .updateItemStatus();
        //     },
        //   ),
        // ),
        DataCell(Text(
          data[index]['createdAt'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['updateAt'],
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
                        builder: (context) => UpdateItem(
                          idDoc: data[index]['idDoc'],
                          itemName: data[index]['itemName'],
                          satuan: data[index]['unit'],
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
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    DateTime dateTime = DateTime.now();
                    String idDocHistory =
                        "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";
                    ItemModel deleteAdd = ItemModel(
                      place: "",
                      idDoc: data[index]['idDoc'],
                      itemCode: "",
                      itemName: "",
                      unit: "",
                      status: true,
                      createdAt: "",
                      updatedAt: "",
                    );

                    HistoryLogModel history = HistoryLogModel(
                      idDoc: idDocHistory,
                      date: dateTime.day,
                      month: dateTime.month,
                      year: dateTime.year,
                      dateTime:
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                      keterangan: "Menghapus item",
                      user: FirebaseAuth.instance.currentUser!.email ?? "",
                      type: "delete",
                    );

                    HistoryLogModelFunction historyLogFunction =
                        HistoryLogModelFunction(idDocHistory);

                    delete() async {
                      try {
                        await deleteAdd.deleteItem();
                        await historyLogFunction.addHistory(
                            history, idDocHistory);
                        // ignore: use_build_context_synchronously
                        CustomToast.successToast(
                            context, "Berhasil  menghapus item");
                      } on FirebaseException catch (_) {
                        // ignore: use_build_context_synchronously
                        CustomToast.errorToast(
                            context, "Gagal  menghapus item");
                      }
                    }

                    // ignore: use_build_context_synchronously
                    Notifikasi.warningAlertWithCallback(
                        context, "Anda yakin menghapus ?", delete);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: SonomaneColor.primary),
                    width: 35.w,
                    height: 35.w,
                    child: Icon(
                      Icons.delete,
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
