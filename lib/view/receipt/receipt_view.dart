import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/custom_button_icon.dart';
import 'package:sonomaneoutlet/shared_widget/formField_no_title.dart';
import 'package:sonomaneoutlet/view/receipt/print_paper.dart';

class ScreenInvoice extends StatefulWidget {
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
  const ScreenInvoice({
    super.key,
    required this.datetime,
    required this.customerName,
    required this.waiterName,
    required this.cashierName,
    required this.tableNumber,
    required this.pesanan,
    required this.transactionid,
    this.cashaccept,
    required this.refresh,
    required this.totalVoucher,
    required this.servCharge,
    required this.tax,
    required this.round,
    required this.totalBill,
    required this.subTotal,
    required this.grandTotal,
    required this.discountBill,
  });

  @override
  State<ScreenInvoice> createState() => _ScreenInvoiceState();
}

class _ScreenInvoiceState extends State<ScreenInvoice> {
  bool showFieldEmail = false;
  final GlobalKey _globalKey = GlobalKey();
  TextEditingController controllerEmailCustomer = TextEditingController();

  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  ApiBaseHelper api = ApiBaseHelper();

  Future<dynamic> sendEmail(BuildContext context) async {
    // Capture the RepaintBoundary widget as an image
    String pngBytes = await captureScreenshot();

    Map body = {
      "to": controllerEmailCustomer.text.toString().trim(),
      "subject": "Invoice Sonomane",
      "fileName": widget.transactionid,
      "text":
          "Terimakasih telah berkunjung di sonomane bar & restaurant, semoga hari mu menyenangkan.",
      "file": pngBytes,
    };

    try {
      final response =
          // ignore: use_build_context_synchronously
          await api.post("$baseUrl/send-email-smtp", body, context);

      return response;
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: use_build_context_synchronously
      CustomToast.errorToast(context, e.toString());
    }
  }

  Future<String> captureScreenshot() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();

    final boundaryWidth = ScreenUtil().setWidth(boundary.size.width);
    final boundaryHeight = ScreenUtil().setWidth(boundary.size.height);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageProvider = pw.MemoryImage(byteData!.buffer.asUint8List());

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(imageProvider);
        },
        pageFormat: PdfPageFormat(
          boundaryWidth,
          boundaryHeight,
          marginAll: 0,
        ),
      ),
    );

    // Simpan PDF ke dalam buffer
    final Uint8List pdfBytes = await pdf.save();

    // Konversi buffer PDF menjadi string base64
    final String base64String = base64Encode(pdfBytes);

    return base64String;
  }

  Future<String?> captureScreenshotUntukSave() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();

    final boundaryWidth = ScreenUtil().setWidth(boundary.size.width);
    final boundaryHeight = ScreenUtil().setWidth(boundary.size.height);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageProvider = pw.MemoryImage(byteData!.buffer.asUint8List());

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(imageProvider);
        },
        pageFormat: PdfPageFormat(
          boundaryWidth,
          boundaryHeight,
          marginAll: 0,
        ),
      ),
    );

    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      final directory = Directory(result);
      final path = '${directory.path}/${widget.transactionid}.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      // Lakukan sesuatu dengan file PDF, seperti membukanya atau menyimpannya ke galeri
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 15.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15.w),
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.refresh();
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 24.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Preview',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: Image.asset(
                            'assets/images/print.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        SizedBox(
                          width: 450.w,
                          child: Text(
                            "Tekan print jika ingin memakai invoice dalam bentuk fisik, atau tekan share jika ingin mengirimnya melalui email sehingga menghemat pemakaian kertas, tekan simpan jika ingin menyimpan bukti invoice.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50.h,
                              child: CustomButtonIcon(
                                  isLoading: false,
                                  icon: Icon(
                                    Icons.print,
                                    size: 30.sp,
                                    color: SonomaneColor.textTitleDark,
                                  ),
                                  title: "Print",
                                  onTap: () async {
                                    if ((await (_printer.isConnected))!) {
                                      final int contentLines = widget
                                              .pesanan.length *
                                          3; // 1 line for item, 1 line for addons, 1 line for discount (if applicable)
                                      const int emptyLines =
                                          10; // Adjust this number based on the spacing you want

                                      _printer.printNewLine();
                                      _printer.printCustom(
                                          "SONOMANE BAR & RESTO", 3, 1);
                                      _printer.printCustom(
                                          "Green Lake City\nRukan Sentra Niaga Blok A07",
                                          1,
                                          1);
                                      _printer.printCustom(
                                          "================================",
                                          1,
                                          1);
                                      _printer.printCustom(
                                          "Tanggal   : ${widget.datetime.substring(0, 10)}",
                                          1,
                                          0);
                                      _printer.printCustom(
                                          "Jam       : ${widget.datetime.substring(11, 19)}",
                                          1,
                                          0);
                                      _printer.printCustom(
                                          "Nama Tamu : ${widget.customerName}",
                                          1,
                                          0);
                                      _printer.printCustom(
                                          "Pelayan   : ${widget.waiterName}",
                                          1,
                                          0);
                                      _printer.printCustom(
                                          "No.Meja   : ${widget.tableNumber}",
                                          1,
                                          0);
                                      _printer.printCustom(
                                          "Kasir     : ${widget.cashierName}",
                                          1,
                                          0);
                                      _printer.printCustom(
                                          "================================",
                                          1,
                                          1);

                                      for (var a = 0;
                                          a < widget.pesanan.length;
                                          a++) {
                                        String truncatedName = truncateMenuName(
                                            widget.pesanan[a]["name"], 10);
                                        _printer.printLeftRight(
                                            "${widget.pesanan[a]["quantity"]}x $truncatedName",
                                            "${widget.pesanan[a]["price"].toStringAsFixed(0)}",
                                            1);
                                        for (var i = 0;
                                            i <
                                                widget.pesanan[a]["addons"]
                                                    .length;
                                            i++) {
                                          _printer.printLeftRight(
                                              "${widget.pesanan[a]["addons"][i]["quantity"]}x + ${widget.pesanan[a]["addons"][i]["name"]}",
                                              "${widget.pesanan[a]["addons"][i]["price"].toStringAsFixed(0)}",
                                              1);
                                        }

                                        if (widget.pesanan[a]["discount"] !=
                                            0) {
                                          _printer.printLeftRight(
                                              "   Discount${(widget.pesanan[a]["discount"] * 100).toStringAsFixed(0)}%",
                                              "-${(widget.pesanan[a]["price"] * widget.pesanan[a]["discount"]).toStringAsFixed(0)}",
                                              1);
                                        }
                                      }

                                      _printer.printCustom(
                                          "----------------", 2, 1);
                                      _printer.printCustom(
                                          "Discount Bill :    ${widget.discountBill.toStringAsFixed(0)}",
                                          1,
                                          2,
                                          charset: "windows-1250");
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
                                      _printer.printCustom(
                                          "----------------", 2, 1);
                                      _printer.printCustom(
                                          "Total Bill :   ${widget.totalBill.toStringAsFixed(0)}",
                                          1,
                                          2,
                                          charset: "windows-1250");
                                      _printer.printCustom(
                                          "Pembulatan :   ${widget.round.toStringAsFixed(0)}",
                                          1,
                                          2,
                                          charset: "windows-1250");
                                      _printer.printCustom(
                                          "Grand Total :    ${widget.grandTotal.toStringAsFixed(0)}",
                                          1,
                                          2,
                                          charset: "windows-1250");

                                      if (widget.cashaccept != null) {
                                        _printer.printCustom(
                                            "Cash Diterima :    ${widget.cashaccept!.toStringAsFixed(0)}",
                                            1,
                                            2,
                                            charset: "windows-1250");
                                        _printer.printCustom(
                                            "Kembalian :   ${(widget.cashaccept! - widget.grandTotal).toStringAsFixed(0)}",
                                            1,
                                            2,
                                            charset: "windows-1250");
                                      }

                                      _printer.printNewLine();
                                      _printer.printCustom("THANK YOU", 2, 1);
                                      _printer.printCustom(
                                          "IG @SonomaneJKT", 1, 1);
                                      _printer.printNewLine();
                                      _printer.printCustom(
                                          widget.transactionid, 1, 1);
                                      _printer.printNewLine();

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
                                  color: SonomaneColor.textTitleDark,
                                  bgColor: SonomaneColor.primary),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              height: 50.h,
                              child: CustomButtonIcon(
                                  isLoading: false,
                                  icon: Icon(
                                    Icons.share,
                                    size: 30.sp,
                                    color: SonomaneColor.primary,
                                  ),
                                  title: "Email",
                                  onTap: () async {
                                    setState(() {
                                      showFieldEmail = !showFieldEmail;
                                    });
                                  },
                                  color: SonomaneColor.primary,
                                  bgColor: SonomaneColor.containerLight),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              height: 50.h,
                              child: CustomButtonIcon(
                                  isLoading: false,
                                  icon: Icon(
                                    Icons.download,
                                    size: 30.sp,
                                    color: SonomaneColor.primary,
                                  ),
                                  title: "Simpan",
                                  onTap: () async {
                                    final status =
                                        await Permission.storage.status;
                                    if (status == PermissionStatus.granted) {
                                      String? directory =
                                          await captureScreenshotUntukSave();
                                      if (directory != null) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        // ignore: use_build_context_synchronously
                                        CustomToast.successToast(context,
                                            "Invoice berhasil disimpan");
                                      }
                                    } else {
                                      final result =
                                          await Permission.storage.request();
                                      if (result == PermissionStatus.granted) {
                                        String? directory =
                                            await captureScreenshotUntukSave();
                                        if (directory != null) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                          // ignore: use_build_context_synchronously
                                          CustomToast.successToast(context,
                                              "Invoice berhasil disimpan");
                                        } else {}
                                      }
                                    }
                                  },
                                  color: SonomaneColor.primary,
                                  bgColor: SonomaneColor.containerLight),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        showFieldEmail == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 300.w,
                                    height: 50.h,
                                    child: CustomFormFieldNoTitle(
                                      readOnly: false,
                                      hintText: 'Email Customer',
                                      textInputType: TextInputType.emailAddress,
                                      textEditingController:
                                          controllerEmailCustomer,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  SizedBox(
                                    height: 49.h,
                                    width: 90.w,
                                    child: CustomButton(
                                      isLoading: false,
                                      title: 'Share',
                                      onTap: () async {
                                        var response = await sendEmail(context);

                                        if (response["status_code"] == 200) {
                                          // ignore: use_build_context_synchronously
                                          CustomToast.successToast(context,
                                              "Invoice berhasil dikirim");
                                          setState(() {
                                            showFieldEmail = false;
                                            controllerEmailCustomer.clear();
                                          });
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          CustomToast.errorToast(
                                              context, "Invoice gagal dikirim");
                                          setState(() {
                                            showFieldEmail = false;
                                            controllerEmailCustomer.clear();
                                          });
                                        }
                                      },
                                      color: SonomaneColor.textTitleDark,
                                      bgColor: SonomaneColor.primary,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ScrollConfiguration(
              behavior: NoGloww(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: PrintPaperPreview(
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
                      discountBill: widget.discountBill,
                    ),
                  ),
                ),
              ),
            ),
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
