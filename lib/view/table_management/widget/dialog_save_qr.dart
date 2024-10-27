import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';

// ignore: must_be_immutable
class SaveQRCode extends StatefulWidget {
  String tableNumber;
  SaveQRCode({super.key, required this.tableNumber});

  @override
  State<SaveQRCode> createState() => _SaveQRCodeState();
}

class _SaveQRCodeState extends State<SaveQRCode> {
  GlobalKey globalKey = GlobalKey();
  Future<String?> saveQrCodeAsImage() async {
    // Capture the rendering of the widget
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();

    // Convert the captured image to a ByteData
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    // Convert ByteData to Uint8List
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      final directory = Directory(result);
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(uint8List);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.32,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.close,
                  size: 22.sp,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            Text("Meja ${widget.tableNumber}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 22.sp, fontWeight: FontWeight.w700)),
            SizedBox(
              height: 30.h,
            ),
            RepaintBoundary(
              key: globalKey,
              child: PrettyQr(
                elementColor: Theme.of(context).colorScheme.tertiary,
                size: 220.sp,
                data: "https://foodmenu.innotia.co.id/#/${widget.tableNumber}",
                roundEdges: true,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            SizedBox(
              height: 50.h,
              width: 300.w,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15.w)),
                  elevation: const MaterialStatePropertyAll(0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(SonomaneColor.primary),
                ),
                onPressed: () async {
                  final status = await Permission.storage.status;
                  if (status == PermissionStatus.granted) {
                    String? directory = await saveQrCodeAsImage();
                    if (directory != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      // ignore: use_build_context_synchronously
                      CustomToast.successToast(
                          context, "Qrcode berhasil disimpan");
                    }
                  } else {
                    final result = await Permission.storage.request();
                    if (result == PermissionStatus.granted) {
                      String? directory = await saveQrCodeAsImage();
                      if (directory != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        // ignore: use_build_context_synchronously
                        CustomToast.successToast(
                            context, "Qrcode berhasil disimpan");
                      } else {}
                    }
                  }
                },
                icon: Icon(
                  Icons.save_rounded,
                  size: 22.sp,
                  color: SonomaneColor.textTitleDark,
                ),
                label: Text(
                  'Save Qr Code',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: SonomaneColor.textTitleDark,
                        fontSize: 14.sp,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
