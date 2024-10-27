import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/shared_widget/text_row_summary_repor.dart';

class SummaryReportOverall extends StatefulWidget {
  final List data;
  const SummaryReportOverall({super.key, required this.data});

  @override
  State<SummaryReportOverall> createState() => _SummaryReportOverallState();
}

class _SummaryReportOverallState extends State<SummaryReportOverall> {
  double totalMenuSales = 0;
  double totalMenuDiscount = 0;
  double totalMenuNetSales = 0;
  double totalVoucherDiscount = 0;
  double totalNetSales = 0;
  double totalServisCharge = 0;
  double totalTax = 0;
  double totalRound = 0;
  double grossSales = 0;
  int totalBill = 0;
  int totalBillDisc = 0;
  num totalGuest = 0;
  num totalUniqueDays = 0;
  num totalSalesWOSC = 0;
  num totalSalesWOTAX = 0;
  Set<String> uniqueTransactionDays = {};

  @override
  void initState() {
    super.initState();
    calculateTotals();
  }

  void calculateTotals() {
    for (var transaction in widget.data) {
      if (transaction["transaction_status"] == "sukses") {
        if (transaction["service_charge"] == 0) {
          totalSalesWOSC += transaction["gross_amount"];
        }
        if (transaction["tax"] == 0) {
          totalSalesWOTAX += transaction["gross_amount"];
        }
        totalBill = widget.data.length;
        if (transaction['totalVoucher'] != 0) {
          totalBillDisc++;
        }
        for (var pesanan in transaction['pesanan']) {
          // Hitung total menu
          totalMenuSales += pesanan['price'] * pesanan['quantity'];

          // Hitung total diskon
          totalMenuDiscount +=
              pesanan['discount'] * pesanan['price'] * pesanan['quantity'];

          totalMenuNetSales += pesanan['price'] * pesanan['quantity'] -
              (pesanan['discount'] * pesanan['price'] * pesanan['quantity']);
        }

        totalGuest += transaction["guest"];

        // Hitung total diskon voucher
        totalVoucherDiscount += transaction['totalVoucher'];

        totalNetSales = totalMenuNetSales - totalVoucherDiscount;

        // Hitung servis charge
        totalServisCharge += transaction['service_charge'];

        totalTax += transaction['tax'];

        totalRound += transaction['round'];

        grossSales = totalNetSales + totalServisCharge + totalTax + totalRound;

        // Ambil tanggal dari waktu transaksi
        DateTime transactionDate =
            DateTime.parse(transaction['transaction_time']);
        String day = DateFormat("yyyy-MM-dd").format(transactionDate);

        // Tambahkan hari ke set unik
        uniqueTransactionDays.add(day);
      }

      // Hitung total hari unik
      totalUniqueDays = uniqueTransactionDays.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
            width: 0.6.w, color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Theme.of(context).colorScheme.background),
            child: Center(
              child: Text(
                "Overall Summary",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18.sp,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          RowSummaryReport(
            title: "Menu Sales :",
            numberic: CurrencyFormat.convertToIdr(totalMenuSales, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Menu Discount :",
            numberic: CurrencyFormat.convertToIdr(totalMenuDiscount, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Menu Net Sales :",
            numberic: CurrencyFormat.convertToIdr(totalMenuNetSales, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(
            height: 26.h,
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Bill Discount:",
            numberic: CurrencyFormat.convertToIdr(totalVoucherDiscount, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Total Net Sales :",
            numberic: CurrencyFormat.convertToIdr(totalNetSales, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(
            height: 26.h,
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Serv. Charge:",
            numberic: CurrencyFormat.convertToIdr(totalServisCharge, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Tax :",
            numberic: CurrencyFormat.convertToIdr(totalTax, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Round Amount :",
            numberic: CurrencyFormat.convertToIdr(totalRound, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Gross Sales :",
            numberic: CurrencyFormat.convertToIdr(grossSales, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(
            height: 26.h,
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Total # of Bills Disc :",
            numberic: totalBillDisc.toString(),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Total # of Bills :",
            numberic: totalBill.toString(),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Sales per Bill :",
            numberic: totalBill != 0
                ? CurrencyFormat.convertToIdr(grossSales / totalBill, 0)
                : CurrencyFormat.convertToIdr(0, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Total # of Guests :",
            numberic: totalGuest.toString(),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Sales per Guest :",
            numberic: totalGuest != 0
                ? CurrencyFormat.convertToIdr(grossSales / totalGuest, 0)
                : CurrencyFormat.convertToIdr(0, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Average Daily Guests :",
            numberic: totalUniqueDays != 0
                ? (totalGuest / totalUniqueDays).toStringAsFixed(0)
                : CurrencyFormat.convertToIdr(0, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Average Daily Sales :",
            numberic: totalUniqueDays != 0
                ? CurrencyFormat.convertToIdr(grossSales / totalUniqueDays, 0)
                : CurrencyFormat.convertToIdr(0, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Sales w/o SC :",
            numberic: CurrencyFormat.convertToIdr(totalSalesWOSC, 0),
          ),
          Divider(
            thickness: 1.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          RowSummaryReport(
            title: "Sales w/o Tax :",
            numberic: CurrencyFormat.convertToIdr(totalSalesWOTAX, 0),
          ),
        ],
      ),
    );
  }
}
