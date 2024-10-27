import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/voucher/voucher.dart';
import 'package:sonomaneoutlet/view/voucher_management/pages/general_voucher/update_general_voucher.dart';

class TableGeneralVoucher extends StatefulWidget {
  final List data;
  const TableGeneralVoucher({super.key, required this.data});

  @override
  State<TableGeneralVoucher> createState() => _TableGeneralVoucherState();
}

class _TableGeneralVoucherState extends State<TableGeneralVoucher> {
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
      dataRowMaxHeight: 160.h,
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
            'Title Voucher',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Kode Voucher',
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
        DataColumn(
          label: Text(
            'Jumlah Qty',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Jenis Diskon',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Jenis Voucher',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Diskon Persen/Jumlah/Item',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Minimum Transaksi',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Maximum Diskon',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Tanggal Dibuat',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Tanggal Aktif',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Tanggal Kadaluwarsa',
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
          data[index]['voucherTitle'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['voucherCode'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          SizedBox(
            height: 150.h,
            width: 350.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                height: 150.h,
                imageUrl: data[index]['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        DataCell(Text(
          data[index]['limitQty'].toString(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['discountType'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['voucherType'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          Text(
            data[index]['discountType'] == 'amount'
                ? CurrencyFormat.convertToIdr(data[index]['discountAmount'], 0)
                : data[index]['discountType'] == 'percent'
                    ? "${data[index]['discountPercent'].toString()} %"
                    : "Item",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataCell(Text(
          CurrencyFormat.convertToIdr(data[index]['minimumPurchase'], 2),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['maximumDiscount'] != null
              ? CurrencyFormat.convertToIdr(data[index]['maximumDiscount'], 0)
              : "-",
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
          data[index]['startDate'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['expiredDate'],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateGeneralVoucher(
                        idDoc: data[index]['idDoc'],
                        image: data[index]['image'],
                        discountPercent: data[index]['discountPercent'],
                        expiredDate: data[index]['expiredDate'],
                        voucherQuantity: data[index]['limitQty'],
                        minimumPurchase: data[index]['minimumPurchase'],
                        maximumDiscount: data[index]['maximumDiscount'],
                        startDateTime: data[index]['startDate'],
                        discountType: data[index]['discountType'],
                        voucherCode: data[index]['voucherCode'],
                        voucherTitle: data[index]['voucherTitle'],
                        voucherType: data[index]['voucherType'],
                        syaratKetentuan: data[index]['syaratKetentuan'],
                        caraKerja: data[index]['caraKerja'],
                        createdAt: data[index]["createdAt"],
                        discountAmount: data[index]["discountAmount"],
                        used: data[index]["used"],
                        item: data[index]["item"],
                      ),
                    ),
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
                    await VoucherModel("general")
                        .deleteVoucher(data[index]['idDoc']);
                    await FirebaseStorage.instance
                        .refFromURL(data[index]['image'])
                        .delete();
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
                      keterangan: "Menghapus voucher general",
                      user: FirebaseAuth.instance.currentUser!.email ?? "",
                      type: "delete",
                    );

                    HistoryLogModelFunction historyLogFunction =
                        HistoryLogModelFunction(idDocHistory);
                    await historyLogFunction.addHistory(history, idDocHistory);
                  }

                  Notifikasi.warningAlertWithCallback(
                    context,
                    "Yakin ingin menghapus voucher ini ?",
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
