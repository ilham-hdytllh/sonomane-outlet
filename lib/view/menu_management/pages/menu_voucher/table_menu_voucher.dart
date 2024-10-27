import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/menu_voucher/menu_subscription.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_voucher/update_menu_vouhcer.dart';

class TableMenuVoucher extends StatefulWidget {
  final List data;
  const TableMenuVoucher({super.key, required this.data});

  @override
  State<TableMenuVoucher> createState() => _TableMenuVoucherState();
}

class _TableMenuVoucherState extends State<TableMenuVoucher> {
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
      dataRowMaxHeight: 65.h,
      dataRowMinHeight: 65.h,
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
            'Name',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Price',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Gambar',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'Discount',
        //     style: Theme.of(context)
        //         .textTheme
        //         .titleMedium!
        //         .copyWith(fontSize: 14.sp),
        //   ),
        // ),
        DataColumn(
          label: Text(
            'Category',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Sub Category',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'Addon',
        //     style: Theme.of(context)
        //         .textTheme
        //         .titleMedium!
        //         .copyWith(fontSize: 14.sp),
        //   ),
        // ),
        // DataColumn(
        //   label: Text(
        //     'Recommend Chef',
        //     style: Theme.of(context)
        //         .textTheme
        //         .titleMedium!
        //         .copyWith(fontSize: 14.sp),
        //   ),
        // ),
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
          data[index]['name'].toString().capitalize(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          CurrencyFormat.convertToIdr(data[index]['price'], 0),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          SizedBox(
            height: 50.h,
            width: 210.w,
            child: ScrollConfiguration(
              behavior: NoGloww(),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data[index]['images'].length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 6.w,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 48.h,
                          height: 48.h,
                          imageUrl: data[index]['images'][i],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
        // DataCell(Text(
        //   data[index]['discount'] == 0
        //       ? "-"
        //       : "${data[index]['discount'] * 100} %",
        //   style: Theme.of(context)
        //       .textTheme
        //       .titleMedium!
        //       .copyWith(fontSize: 14.sp),
        // )),
        DataCell(Text(
          data[index]['category'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['subcategory'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        // DataCell(
        //   SizedBox(
        //     height: 50.h,
        //     width: 220.w,
        //     child: ListView.builder(
        //       itemCount: data[index]['addons'].length,
        //       scrollDirection: Axis.horizontal,
        //       itemBuilder: (context, i) {
        //         return Padding(
        //           padding: EdgeInsets.only(
        //             right: 6.w,
        //           ),
        //           child: Chip(
        //             backgroundColor: SonomaneColor.primary,
        //             label: Text(data[index]['addons'][i]["name"],
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleSmall!
        //                     .copyWith(color: SonomaneColor.textTitleDark)),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        // DataCell(
        //   Text(
        //     data[index]['recommended'],
        //     style: Theme.of(context)
        //         .textTheme
        //         .titleMedium!
        //         .copyWith(fontSize: 14.sp),
        //   ),
        // ),
        DataCell(Text(
          data[index]["description"],
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
                  Navigator.of(context).push(
                    (MaterialPageRoute(
                      builder: (context) => UpdateMenuVoucher(
                        idDoc: data[index]["idDoc"],
                        name: data[index]["name"],
                        description: data[index]["description"],
                        price: data[index]["price"],
                        category: data[index]["category"],
                        subcategory: data[index]["subcategory"],
                        images: data[index]["images"],
                      ),
                    )),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: SonomaneColor.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 35,
                  height: 35,
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
                  callback() async {
                    await MenuSubscriptionFunction()
                        .deleteMenuSubscription(data[index]['idDoc'])
                        .then((_) async {
                      for (int i = 0; i < data[index]['images'].length; i++) {
                        FirebaseStorage.instance
                            .refFromURL(data[index]['images'][i])
                            .delete();
                      }
                    });
                    DateTime dateTime = DateTime.now();

                    String idDocHistory =
                        "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                    HistoryLogModel history = HistoryLogModel(
                      idDoc: idDocHistory,
                      date: dateTime.day,
                      month: dateTime.month,
                      year: dateTime.year,
                      dateTime:
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                      keterangan: "Menghapus menu voucher",
                      user: FirebaseAuth.instance.currentUser!.email ?? "",
                      type: "delete",
                    );

                    HistoryLogModelFunction historyLogFunction =
                        HistoryLogModelFunction(idDocHistory);
                    await historyLogFunction.addHistory(history, idDocHistory);
                  }

                  Notifikasi.warningAlertWithCallback(
                    context,
                    "Yakin ingin menghapus menu ini ?",
                    callback,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: SonomaneColor.primary),
                  width: 35,
                  height: 35,
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
