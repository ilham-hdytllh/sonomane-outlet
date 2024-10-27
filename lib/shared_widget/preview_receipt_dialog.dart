import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/view/receipt/receipt_preview_not_invoice.dart';

class PreviewReceiptDialog extends StatefulWidget {
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
  const PreviewReceiptDialog({
    super.key,
    required this.datetime,
    required this.customerName,
    required this.waiterName,
    required this.cashierName,
    required this.tableNumber,
    required this.transactionid,
    required this.pesanan,
    required this.refresh,
    this.cashaccept,
    required this.totalVoucher,
    required this.servCharge,
    required this.tax,
    required this.round,
    required this.totalBill,
    required this.subTotal,
    required this.grandTotal,
  });

  @override
  State<PreviewReceiptDialog> createState() => _PreviewReceiptDialogState();
}

class _PreviewReceiptDialogState extends State<PreviewReceiptDialog> {
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: SizedBox(
        width: (MediaQuery.of(context).size.width * 0.335).w,
        child: Stack(
          children: [
            PrintPaperPreviewNotInvoice(
              totalVoucher: widget.totalVoucher,
              datetime: widget.datetime,
              customerName: widget.customerName,
              pesanan: widget.pesanan,
              transactionid: widget.transactionid,
              cashaccept: widget.cashaccept,
              waiterName: widget.waiterName,
              cashierName: widget.cashierName,
              tableNumber: widget.tableNumber,
              refresh: widget.refresh,
              servCharge: widget.servCharge,
              tax: widget.tax,
              round: widget.round,
              totalBill: widget.totalBill,
              subTotal: widget.subTotal,
              grandTotal: widget.grandTotal,
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
                  GestureDetector(
                    onTap: () async {
                      if ((await (_printer.isConnected))!) {
                        final int contentLines = widget.pesanan.length *
                            3; // 1 line for item, 1 line for addons, 1 line for discount (if applicable)
                        const int emptyLines =
                            10; // Adjust this number based on the spacing you want

                        _printer.printNewLine();
                        _printer.printCustom("SONOMANE BAR & RESTO", 3, 1);
                        _printer.printCustom(
                            "Green Lake City\nRukan Sentra Niaga Blok A07",
                            1,
                            1);
                        _printer.printCustom(
                            "================================", 1, 1);
                        _printer.printCustom(
                            "Tanggal   : ${widget.datetime.substring(0, 10)}",
                            1,
                            0);
                        _printer.printCustom(
                            "Jam       : ${widget.datetime.substring(11, 19)}",
                            1,
                            0);
                        _printer.printCustom(
                            "Nama Tamu : ${widget.customerName}", 1, 0);
                        _printer.printCustom(
                            "Pelayan   : ${widget.waiterName}", 1, 0);
                        _printer.printCustom(
                            "No.Meja   : ${widget.tableNumber}", 1, 0);
                        _printer.printCustom(
                            "Kasir     : ${widget.cashierName}", 1, 0);
                        _printer.printCustom(
                            "================================", 1, 1);

                        for (var a = 0; a < widget.pesanan.length; a++) {
                          String truncatedName =
                              truncateMenuName(widget.pesanan[a]["name"], 10);
                          _printer.printLeftRight(
                              "${widget.pesanan[a]["quantity"]}x $truncatedName",
                              "${widget.pesanan[a]["price"].toStringAsFixed(0)}",
                              80);
                          for (var i = 0;
                              i < widget.pesanan[a]["addons"].length;
                              i++) {
                            _printer.printLeftRight(
                                "${widget.pesanan[a]["addons"][i]["quantity"]}x + ${widget.pesanan[a]["addons"][i]["name"]}",
                                "${widget.pesanan[a]["addons"][i]["price"].toStringAsFixed(0)}",
                                80);
                          }

                          if (widget.pesanan[a]["discount"] != 0) {
                            _printer.printLeftRight(
                                "   Discount${(widget.pesanan[a]["discount"] * 100).toStringAsFixed(0)}%",
                                "-${(widget.pesanan[a]["price"] * widget.pesanan[a]["discount"]).toStringAsFixed(0)}",
                                80);
                          }
                        }

                        _printer.printCustom("----------------", 2, 1);
                        _printer.printCustom(
                            "Sub Total :    ${widget.subTotal.toStringAsFixed(0)}",
                            1,
                            2,
                            charset: "windows-1250");
                        _printer.printCustom(
                            "Serv. Charge 5% :    ${widget.servCharge.toStringAsFixed(0)}",
                            1,
                            2,
                            charset: "windows-1250");
                        _printer.printCustom(
                            "Tax 10% :    ${widget.tax.toStringAsFixed(0)}",
                            1,
                            2,
                            charset: "windows-1250");
                        _printer.printCustom("----------------", 2, 1);
                        _printer.printCustom(
                            "Total Bill :   ${widget.totalBill.toStringAsFixed(0)}",
                            1,
                            2,
                            charset: "windows-1250");
                        _printer.printCustom("----------------", 2, 1);
                        _printer.printCustom(
                            "Grand Total :    ${widget.grandTotal.toStringAsFixed(0)}",
                            2,
                            1,
                            charset: "windows-1250");
                        _printer.printCustom("----------------", 2, 1);

                        _printer.printNewLine();
                        _printer.printCustom("THANK YOU", 2, 1);
                        _printer.printCustom("IG @SonomaneJKT", 1, 1);
                        _printer.printNewLine();
                        _printer.printCustom(widget.transactionid, 1, 1);
                        _printer.printNewLine();

                        _printer.printCustom(
                            "Noted : Hanya untuk penagihan bukan bukti bayar.",
                            1,
                            0);

                        // Add empty lines to center content
                        for (int i = 0;
                            i < emptyLines / 2 - contentLines / 2;
                            i++) {
                          _printer.printNewLine();
                        }
                      } else {
                        debugPrint("g konek");
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: Icon(
                        Icons.print_rounded,
                        size: 35.sp,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String truncateMenuName(String menuName, int maxLength) {
    if (menuName.length <= maxLength) {
      return menuName;
    } else {
      // Truncate the menu name and append "..."
      return "${menuName.substring(0, maxLength - 3)}...";
    }
  }
}
