import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/view/order_management/pages/detail_order/detail_order.dart';
import 'package:sonomaneoutlet/view/receipt/receipt_view.dart';

// ignore: must_be_immutable
class TableOrder extends StatefulWidget {
  List data;
  TableOrder({super.key, required this.data});

  @override
  State<TableOrder> createState() => _TableOrderState();
}

class _TableOrderState extends State<TableOrder> {
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
            'ID Transaksi',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Waktu Transaksi',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Pelanggan',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Total Harga',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Status Pembayaran',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Status Transaksi',
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

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

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
          data[index]['transaction_id'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data[index]['transaction_time'].toString().substring(0, 10),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                data[index]['transaction_time'].toString().substring(11, 16),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            data[index]['customer_name'],
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataCell(
          Text(
            CurrencyFormat.convertToIdr(data[index]['gross_amount'], 2),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataCell(
          Container(
            height: 33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: data[index]['payment_status'] == 'telah dibayar'
                  ? SonomaneColor.blue.withOpacity(0.1)
                  : SonomaneColor.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                data[index]['payment_status'].toString().capitalize(),
                style: TextStyle(
                    color: data[index]['payment_status'] == 'telah dibayar'
                        ? SonomaneColor.blue
                        : SonomaneColor.primary),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            height: 33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: data[index]['transaction_status'] == 'sukses'
                  ? SonomaneColor.blue.withOpacity(0.1)
                  : SonomaneColor.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                data[index]['transaction_status'].toString().capitalize(),
                style: TextStyle(
                    color: data[index]['transaction_status'] == 'sukses'
                        ? SonomaneColor.blue
                        : SonomaneColor.primary),
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailOrderView(
                          urlPayment:
                              data[index]['transactionRedirectUrl'] ?? "",
                          iddoc: data[index]['idDoc'],
                          id: data[index]['transaction_id'],
                          orderid: data[index]['tableOrder_id'],
                          datetime: data[index]['transaction_time'].toString(),
                          namauser: data[index]['customer_name'],
                          totalprice: data[index]['gross_amount'].toString(),
                          metodepayment: data[index]['payment_type'],
                          paymentstatus: data[index]['payment_status'],
                          transactionstatus: data[index]['transaction_status'],
                          cashaccept: data[index]['cash_accept'],
                          pesanan: data[index]['pesanan'],
                          totalVoucher: data[index]['totalVoucher'],
                          tableNumber: data[index]['table_number'],
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.w,
                        color: Colors.amberAccent,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                      color: SonomaneColor.textTitleDark),
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.remove_red_eye,
                    color: Colors.amberAccent,
                    size: 15.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              data[index]['payment_status'] == 'telah dibayar'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenInvoice(
                                datetime: data[index]['transaction_time'],
                                customerName: data[index]['customer_name'],
                                waiterName: data[index]['waiter'],
                                tableNumber: data[index]['table_number'],
                                cashierName: data[index]['cashier'],
                                pesanan: data[index]['pesanan'],
                                servCharge: data[index]["service_charge"],
                                tax: data[index]["tax"],
                                round: data[index]["round"] ?? 0,
                                totalBill: data[index]["gross_amount"] -
                                    (data[index]["round"] ?? 0),
                                grandTotal: data[index]["gross_amount"],
                                subTotal: data[index]["gross_amount"] -
                                    (data[index]["round"] ?? 0) -
                                    data[index]["tax"] -
                                    data[index]["service_charge"],
                                refresh: () {},
                                transactionid: data[index]['transaction_id'],
                                cashaccept: data[index]['cash_accept'],
                                totalVoucher: data[index]['totalVoucher'],
                                discountBill: data[index]['discountBill'],
                              ),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.w, color: Colors.green),
                            borderRadius: BorderRadius.circular(5),
                            color: SonomaneColor.textTitleDark),
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.print,
                          color: Colors.green,
                          size: 15.sp,
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: 5.w,
              ),
              data[index]['transaction_status'] == "pending"
                  ? GestureDetector(
                      onTap: () {
                        callback() async {
                          // ignore: use_build_context_synchronously
                          final response = await apiBaseHelper.post(
                            "$baseUrl/cancel-transaction",
                            {
                              "order_id": data[index]['transaction_id'],
                              "tokenFCM": data[index]['tokenFCM'].isNotEmpty
                                  ? data[index]['tokenFCM'][0]
                                  : "",
                            },
                            context,
                          );
                          if (response["status_code"] == 200) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // ignore: use_build_context_synchronously
                            CustomToast.successToast(
                                context, "Transaksi berhasil dibatalkan");
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // ignore: use_build_context_synchronously
                            CustomToast.errorToast(context, "Something wrong");
                          }
                        }

                        Notifikasi.warningAlertWithCallback(
                            context, "Yakin membatalkan transaksi ?", callback);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.w, color: SonomaneColor.primary),
                            borderRadius: BorderRadius.circular(5.r),
                            color: SonomaneColor.textTitleDark),
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.cancel,
                          color: SonomaneColor.primary,
                          size: 15.sp,
                        ),
                      ),
                    )
                  : const SizedBox(),
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
