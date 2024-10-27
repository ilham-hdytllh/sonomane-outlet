import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:google_fonts/google_fonts.dart';

class PrintPaperPreview extends StatefulWidget {
  final String datetime;
  final String customerName;
  final String waiterName;
  final String cashierName;
  final String tableNumber;
  final String transactionid;
  final List pesanan;
  final VoidCallback refresh;
  final num? cashaccept;
  final num totalVoucher;
  final num servCharge;
  final num tax;
  final num round;
  final num totalBill;
  final num subTotal;
  final num grandTotal;
  final num discountBill;
  const PrintPaperPreview({
    super.key,
    required this.datetime,
    required this.pesanan,
    required this.transactionid,
    this.cashaccept,
    required this.totalVoucher,
    required this.customerName,
    required this.waiterName,
    required this.cashierName,
    required this.tableNumber,
    required this.refresh,
    required this.servCharge,
    required this.tax,
    required this.round,
    required this.totalBill,
    required this.subTotal,
    required this.grandTotal,
    required this.discountBill,
  });

  @override
  State<PrintPaperPreview> createState() => _PrintPaperPreviewState();
}

class _PrintPaperPreviewState extends State<PrintPaperPreview> {
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
    return SizedBox(
      width: MediaQuery.of(context).size.width < 800
          ? (MediaQuery.of(context).size.width * 0.6).w
          : (MediaQuery.of(context).size.width * 0.3).w,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: SonomaneColor.textTitleDark,
          border: Border.symmetric(
            vertical: BorderSide(
              width: 0.6.w,
              color: SonomaneColor.scaffoldColorDark,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                'SONOMANE BAR & RESTO',
                style: GoogleFonts.robotoMono(
                    fontSize: 22.sp,
                    color: SonomaneColor.scaffoldColorDark,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Green Lake City\nRukan Sentra Niaga Blok A07',
                style: GoogleFonts.robotoMono(
                    fontSize: 18.sp,
                    color: SonomaneColor.scaffoldColorDark,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              const DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 2.0,
                dashLength: 6.0,
                dashColor: Colors.black,
                dashRadius: 0.0,
                dashGapLength: 2.0,
                dashGapColor: Colors.transparent,
                dashGapRadius: 0.0,
              ),
              SizedBox(
                height: 4.h,
              ),
              const DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 2.0,
                dashLength: 6.0,
                dashColor: Colors.black,
                dashRadius: 0.0,
                dashGapLength: 2.0,
                dashGapColor: Colors.transparent,
                dashGapRadius: 0.0,
              ),
              SizedBox(
                height: 10.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 135.w,
                        child: Row(
                          children: [
                            Text(
                              'Tanggal',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Text(
                              ':',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Text(
                            widget.datetime.substring(0, 10),
                            style: GoogleFonts.robotoMono(
                                color: SonomaneColor.scaffoldColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 135.w,
                        child: Row(
                          children: [
                            Text(
                              'Jam',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Text(
                              ':',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Text(
                            widget.datetime.substring(11, 19),
                            style: GoogleFonts.robotoMono(
                                color: SonomaneColor.scaffoldColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 135.w,
                        child: Row(
                          children: [
                            Text(
                              'Nama Tamu',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Text(
                              ':',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Text(
                            widget.customerName,
                            style: GoogleFonts.robotoMono(
                                color: SonomaneColor.scaffoldColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 135.w,
                        child: Row(
                          children: [
                            Text(
                              'Pelayan',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Text(
                              ':',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Text(
                            widget.waiterName,
                            style: GoogleFonts.robotoMono(
                                color: SonomaneColor.scaffoldColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 135.w,
                        child: Row(
                          children: [
                            Text(
                              'No.Meja',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Text(
                              ':',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Text(
                            widget.tableNumber,
                            style: GoogleFonts.robotoMono(
                                color: SonomaneColor.scaffoldColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 135.w,
                        child: Row(
                          children: [
                            Text(
                              'Kasir',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Text(
                              ':',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Text(
                            widget.cashierName,
                            style: GoogleFonts.robotoMono(
                                color: SonomaneColor.scaffoldColorDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 2,
                    dashLength: 6.0,
                    dashColor: Colors.black,
                    dashRadius: 0.0,
                    dashGapLength: 2.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  const DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 2.0,
                    dashLength: 6.0,
                    dashColor: Colors.black,
                    dashRadius: 0.0,
                    dashGapLength: 2.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  for (int i = 0; i < widget.pesanan.length; i++) ...{
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 42.w,
                              child: Text(
                                '${widget.pesanan[i]['quantity']} x',
                                style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.scaffoldColorDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.pesanan[i]['name']
                                    .toString()
                                    .capitalize(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                            ),
                            SizedBox(
                              width: 165.w,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  CurrencyFormat.convertToIdr(
                                      widget.pesanan[i]['price'], 2),
                                  style: GoogleFonts.robotoMono(
                                      color: SonomaneColor.scaffoldColorDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int a = 0;
                            a < widget.pesanan[i]['addons'].length;
                            a++) ...{
                          SizedBox(
                            height: 5.h,
                          ),
                          widget.pesanan[i]['addons'].length != 0
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 42.w,
                                      child: Text(
                                        '${widget.pesanan[i]['addons'][a]['quantity'].toString()} x ',
                                        style: GoogleFonts.robotoMono(
                                            color:
                                                SonomaneColor.scaffoldColorDark,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "+ ${widget.pesanan[i]['addons'][a]['name']}"
                                            .toString()
                                            .capitalize(),
                                        style: GoogleFonts.robotoMono(
                                            color:
                                                SonomaneColor.scaffoldColorDark,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 165.w,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                              widget.pesanan[i]['addons'][a]
                                                  ['price'],
                                              2),
                                          style: GoogleFonts.robotoMono(
                                              color: SonomaneColor
                                                  .scaffoldColorDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        },
                        SizedBox(
                          height: 5.h,
                        ),
                        widget.pesanan[i]['discount'] != 0
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 42.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Discount ${widget.pesanan[i]['discount'].toString()}%',
                                      style: GoogleFonts.robotoMono(
                                          color:
                                              SonomaneColor.scaffoldColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 165.w,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        CurrencyFormat.convertToIdr(
                                            -widget.pesanan[i]['price'] *
                                                widget.pesanan[i]['discount'],
                                            2),
                                        style: GoogleFonts.robotoMono(
                                            color:
                                                SonomaneColor.scaffoldColorDark,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  },
                  SizedBox(
                    height: 10.h,
                  ),
                  const DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 2,
                    dashLength: 6.0,
                    dashColor: Colors.black,
                    dashRadius: 0.0,
                    dashGapLength: 2.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Discount Bill  :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Sub Total  :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Serv. Charge 5%   :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Pajak 10%   :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              const DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 2,
                                dashLength: 6.0,
                                dashColor: Colors.black,
                                dashRadius: 0.0,
                                dashGapLength: 2.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'Total Bill  :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                'Pembulatan  :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Grand Total  :  ',
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              widget.cashaccept != null
                                  ? Text(
                                      "Cash Diterima  :  ",
                                      style: GoogleFonts.robotoMono(
                                          color:
                                              SonomaneColor.scaffoldColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    )
                                  : const SizedBox(),
                              widget.cashaccept != null
                                  ? SizedBox(
                                      height: 5.h,
                                    )
                                  : const SizedBox(),
                              widget.cashaccept != null
                                  ? Text(
                                      "Kembalian  :  ",
                                      style: GoogleFonts.robotoMono(
                                          color:
                                              SonomaneColor.scaffoldColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                    -widget.discountBill, 2),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                    (widget.subTotal + widget.discountBill), 2),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                    widget.servCharge, 2),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(widget.tax, 2),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              const DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 2,
                                dashLength: 6.0,
                                dashColor: Colors.black,
                                dashRadius: 0.0,
                                dashGapLength: 2.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                    widget.totalBill, 2),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr((widget.round), 2)
                                    .toString(),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                        widget.grandTotal, 2)
                                    .toString(),
                                style: GoogleFonts.robotoMono(
                                    color: SonomaneColor.scaffoldColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              widget.cashaccept != null
                                  ? Text(
                                      CurrencyFormat.convertToIdr(
                                              (widget.cashaccept), 2)
                                          .toString(),
                                      style: GoogleFonts.robotoMono(
                                          color:
                                              SonomaneColor.scaffoldColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    )
                                  : const SizedBox(),
                              widget.cashaccept != null
                                  ? SizedBox(
                                      height: 5.h,
                                    )
                                  : const SizedBox(),
                              widget.cashaccept != null
                                  ? Text(
                                      CurrencyFormat.convertToIdr(
                                              (widget.cashaccept! -
                                                  widget.grandTotal),
                                              2)
                                          .toString(),
                                      style: GoogleFonts.robotoMono(
                                          color:
                                              SonomaneColor.scaffoldColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Thank You',
                        style: GoogleFonts.robotoMono(
                            color: SonomaneColor.scaffoldColorDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'IG @SonomaneJKT',
                        style: GoogleFonts.robotoMono(
                            color: SonomaneColor.scaffoldColorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.transactionid,
                        style: GoogleFonts.robotoMono(
                            color: SonomaneColor.scaffoldColorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
