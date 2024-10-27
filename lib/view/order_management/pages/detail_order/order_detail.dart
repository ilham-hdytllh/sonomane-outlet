import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/view/order_management/pages/detail_order/order_detail_header.dart';
import 'package:sonomaneoutlet/view/order_management/pages/detail_order/order_detail_header_right.dart';

class OrderDetail extends StatefulWidget {
  final String iddoc;
  final String id;
  final String datetime;
  final String namauser;
  final List pesanan;
  final String urlPayment;
  final String paymentstatus;
  final num? cashaccept;
  final num totalVoucher;
  final String tableNumber;
  final String orderid;
  final String transactionstatus;
  final String metodepayment;
  const OrderDetail(
      {super.key,
      required this.iddoc,
      required this.id,
      required this.datetime,
      required this.namauser,
      required this.pesanan,
      required this.urlPayment,
      required this.paymentstatus,
      this.cashaccept,
      required this.totalVoucher,
      required this.tableNumber,
      required this.orderid,
      required this.transactionstatus,
      required this.metodepayment});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String? selectedKategori;
  double sum = 0;
  double discount = 0;
  double totalAddons = 0;

  perhitungan() {
    for (var i = 0; i < widget.pesanan.length; i++) {
      sum += widget.pesanan[i]['price'] * widget.pesanan[i]['quantity'];
      num cekNull() {
        if (widget.pesanan[i]['discount'] == null) {
          return 0;
        } else {
          return widget.pesanan[i]['discount'];
        }
      }

      discount += widget.pesanan[i]['price'] *
          widget.pesanan[i]['quantity'] *
          cekNull();

      for (var a = 0; a < widget.pesanan[i]['addons'].length; a++) {
        totalAddons += widget.pesanan[i]['addons'][a]['price'] *
            widget.pesanan[i]['quantity'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    perhitungan();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              flex: 2,
              child: OrderDetailHeader(
                orderid: widget.orderid,
                paymentstatus: widget.paymentstatus,
                pesanan: widget.pesanan,
                transactionid: widget.id,
                datetime: widget.datetime,
                urlPayment: widget.urlPayment,
                tableNumber: widget.tableNumber,
              ),
            ),
            Expanded(
              flex: 2,
              child: OrderDetailHeaderRight(
                metodepayment: widget.metodepayment,
                transactionstatus: widget.transactionstatus,
                paymentstatus: widget.paymentstatus,
                totalVoucher: widget.totalVoucher,
                iddoc: widget.iddoc,
                orderid: widget.orderid,
                transactionid: widget.id,
                cashaccept: widget.cashaccept,
                datetime: widget.datetime,
                pesanan: widget.pesanan,
                nameuser: widget.namauser,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        SizedBox(
          width: double.infinity,
          child: DataTable(
            showBottomBorder: true,
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
                  'Detail Menu',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Harga',
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
                  'Diskon',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp),
                ),
              ),
            ],
            rows: [
              for (var i = 0; i < widget.pesanan.length; i++) ...[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(
                        (i + 1).toString(),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(
                          right: 6.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                width: 48.h,
                                height: 48.h,
                                imageUrl: widget.pesanan[i]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                widget.pesanan[i]['name']
                                    .toString()
                                    .capitalize(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        CurrencyFormat.convertToIdr(
                            widget.pesanan[i]['price'], 2),
                      ),
                    ),
                    DataCell(Text(
                      widget.pesanan[i]['quantity'].toString(),
                    )),
                    DataCell(
                      Text(
                        CurrencyFormat.convertToIdr(
                            ((widget.pesanan[i]['discount'] *
                                    widget.pesanan[i]['price']) *
                                widget.pesanan[i]['quantity']),
                            2),
                      ),
                    ),
                    DataCell(
                      Text(
                        CurrencyFormat.convertToIdr(
                            widget.pesanan[i]['price'] -
                                ((widget.pesanan[i]['discount'] *
                                        widget.pesanan[i]['price']) *
                                    widget.pesanan[i]['quantity']),
                            2),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width * 0.40).w,
              child: SummaryTotal(
                discount: discount,
                ppn: (((sum + totalAddons) - discount) - widget.totalVoucher) *
                    0.1,
                subTotal: sum + totalAddons,
                totalAddons: totalAddons,
                totalAfterDiscount:
                    ((sum + totalAddons) - discount) - widget.totalVoucher,
                totalAkhir: (((sum + totalAddons) - discount) -
                        widget.totalVoucher) +
                    ((((sum + totalAddons) - discount) - widget.totalVoucher) *
                        0.1),
                totalItem: sum,
                totalVoucher: widget.totalVoucher,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SummaryTotal extends StatelessWidget {
  double totalItem;
  double totalAddons;
  double subTotal;
  double discount;
  double totalAfterDiscount;
  double ppn;
  double totalAkhir;
  num totalVoucher;

  SummaryTotal({
    super.key,
    required this.totalItem,
    required this.totalAddons,
    required this.subTotal,
    required this.discount,
    required this.totalAfterDiscount,
    required this.ppn,
    required this.totalAkhir,
    required this.totalVoucher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Item : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(totalItem, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Addons : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(totalAddons, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sub Total : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(subTotal, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Diskon Item : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(-discount, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Voucher : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(-totalVoucher, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total S/ Diskon : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(totalAfterDiscount, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PPN : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            Text(
              CurrencyFormat.convertToIdr(ppn, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Divider(
          thickness: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total : ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              CurrencyFormat.convertToIdr(totalAkhir, 2),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
