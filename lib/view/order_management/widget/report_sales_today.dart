import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/view_model/closeMarket.dart';

class ReportSalesToday extends StatefulWidget {
  final List transaksi;
  final String waktuLogin;
  const ReportSalesToday(
      {super.key, required this.transaksi, required this.waktuLogin});

  @override
  State<ReportSalesToday> createState() => _ReportSalesTodayState();
}

class _ReportSalesTodayState extends State<ReportSalesToday> {
  List pesananUntukUI = [];
  num grossAmount = 0;
  num totalVoucher = 0;
  num totalMenu = 0;
  num totalAddon = 0;
  num totalServiceCharge = 0;
  num totalTax = 0;
  num totalDiscountMenu = 0;
  num totalCashAccept = 0;
  num cashSales = 0;
  num paymentGateway = 0;
  num totalRound = 0;

  void perhitungan() {
    for (var transaction in widget.transaksi) {
      pesananUntukUI.addAll(transaction['pesanan']);
      List pesanan = transaction['pesanan'];
      grossAmount += transaction['gross_amount'];
      totalVoucher += transaction['totalVoucher'];
      totalMenu += transaction['totalVoucher'];
      totalMenu += transaction['total_addon'];
      totalServiceCharge += transaction['service_charge'];
      totalTax += transaction['tax'];
      totalDiscountMenu += transaction['total_diskon_menu'];
      totalRound += transaction['round'];
      if (transaction['cash_accept'] != null) {
        totalCashAccept += transaction['cash_accept'];
      }
      for (var item in pesanan) {
        num price = item['price'];
        int quantity = item['quantity'];
        totalMenu += price * quantity;
      }

      if (transaction['payment_type'] == 'tunai') {
        cashSales += transaction['gross_amount'];
      } else if (transaction['payment_type'] == 'payment gateway') {
        paymentGateway += transaction['gross_amount'];
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
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.335).w,
        child: Stack(
          children: [
            SizedBox(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.h,
                        ),
                        Center(
                          child: Text(
                            "Laporan Penjualan Harian",
                            style: GoogleFonts.robotoMono(
                                fontSize: 22.sp,
                                color: SonomaneColor.textTitleLight,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: Text(
                            'SONOMANE BAR & RESTO',
                            style: GoogleFonts.robotoMono(
                                fontSize: 18.sp,
                                color: SonomaneColor.textTitleLight,
                                fontWeight: FontWeight.w600),
                          ),
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
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Tanggal",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                widget.waktuLogin.substring(0, 10),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Waktu Mulai",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                widget.waktuLogin,
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Waktu Berakhir",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(DateTime.now()),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Nama Petugas",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                FirebaseAuth.instance.currentUser!.email
                                    .toString(),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
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
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Modal Awal",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                "Rp. 100.000,00",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Grand Total Menu",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(totalMenu, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Grand Total Addons",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(totalAddon, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "S/ Charge",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(
                                    totalServiceCharge, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "PPN",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(totalTax, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Diskon",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(
                                    -totalDiscountMenu, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Voucher",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(-totalVoucher, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Rounding",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(-totalRound, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Cash",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(cashSales, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: Text(
                                "Payment Gateway",
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.robotoMono(
                                  fontSize: 14.sp,
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                CurrencyFormat.convertToIdr(paymentGateway, 2),
                                style: GoogleFonts.robotoMono(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleLight,
                                    fontWeight: FontWeight.w600),
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
                          lineThickness: 2.0,
                          dashLength: 6.0,
                          dashColor: Colors.black,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'IG @SonomaneJKT',
                              style: GoogleFonts.robotoMono(
                                  color: SonomaneColor.textTitleLight,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp),
                            ),
                          ],
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
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 35.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: Icon(
                        Icons.close_rounded,
                        size: 35.sp,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Consumer<CloseMarket>(builder: (context, consumer, _) {
                    return GestureDetector(
                      onTap: () {
                        if (consumer.marketIsClosing != false) {
                        } else {
                          Notifikasi.erorAlert(
                              context, "Silahkan close market dahulu");
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        child: Icon(
                          Icons.print_rounded,
                          size: 35.sp,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
