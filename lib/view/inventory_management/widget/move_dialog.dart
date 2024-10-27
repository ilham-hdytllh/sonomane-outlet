import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';

class MoveDialog extends StatefulWidget {
  final String docInventoriesFirst;
  final String docPlaceFirst;
  final String docInventoriesLast;
  final String docPlaceLast;
  final String batch;
  final String idDoc;
  final String dateCome;
  final String name;
  final num quantity;
  final String unit;
  const MoveDialog({
    super.key,
    required this.docInventoriesFirst,
    required this.docPlaceFirst,
    required this.docInventoriesLast,
    required this.docPlaceLast,
    required this.batch,
    required this.idDoc,
    required this.dateCome,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  @override
  State<MoveDialog> createState() => _MoveDialogState();
}

class _MoveDialogState extends State<MoveDialog> {
  final TextEditingController _quantity = TextEditingController();
  int _number = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      title: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close_rounded,
            size: 22.sp,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      content: Container(
        width: 360.w,
        height: 185.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: SonomaneColor.primary.withOpacity(0.2)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(
                    Icons.warning_rounded,
                    size: 26.sp,
                    color: SonomaneColor.primary,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Tulis quantity yang ingin dipindah ? Max : ${widget.quantity}",
                    style: TextStyle(
                        color: SonomaneColor.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Quantity",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          num.parse(value) == 0) {
                        return 'Tidak boleh kosong';
                      } else if (num.parse(value) > widget.quantity) {
                        return 'Quantity tidak cukup';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _number = int.parse(value);
                        });
                      }
                    },
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    cursorColor: SonomaneColor.primary,
                    style: Theme.of(context).textTheme.titleMedium,
                    controller: _quantity,
                    readOnly: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                      hintText: "Max : ${widget.quantity}",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.5.w),
                      ),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              color: SonomaneColor.primary, fontSize: 14.sp),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.5.w),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.5.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    if (_number <= 1) {
                      _number--;
                      _quantity.clear();
                    } else {
                      setState(() {
                        _number--;
                        _quantity.text = _number.toString();
                      });
                    }
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: _number < 1
                          ? Colors.grey.shade600
                          : SonomaneColor.primary,
                    ),
                    child: Icon(
                      Icons.remove_circle_rounded,
                      size: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _number++;
                      _quantity.text = _number.toString();
                    });
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: SonomaneColor.primary,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          height: 50.h,
          width: 100.w,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(SonomaneColor.primary),
            ),
            onPressed: () async {
              final CollectionReference collection = FirebaseFirestore.instance
                  .collection('inventories')
                  .doc(widget.docInventoriesLast)
                  .collection("place");
              final DocumentReference document =
                  collection.doc(widget.docPlaceLast);
              final DocumentSnapshot snapshot = await document.get();
              if (snapshot.exists) {
                if (widget.docInventoriesFirst == "") {
                  FirebaseFirestore.instance
                      .collection("stocks")
                      .doc(widget.docPlaceFirst)
                      .update({
                    "placement": true,
                  });
                  FirebaseFirestore.instance
                      .collection("inventories")
                      .doc(widget.docInventoriesLast)
                      .collection("place")
                      .doc(widget.docPlaceLast)
                      .update({
                    "quantity": FieldValue.increment(widget.quantity),
                  });

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  if (_number != 0 && _number == widget.quantity) {
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesFirst)
                        .collection("place")
                        .doc(widget.docPlaceFirst)
                        .delete();
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesLast)
                        .collection("place")
                        .doc(widget.docPlaceLast)
                        .update({
                      "quantity": FieldValue.increment(widget.quantity),
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else if (_number != 0 && _number < widget.quantity) {
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesFirst)
                        .collection("place")
                        .doc(widget.docPlaceFirst)
                        .update({
                      "quantity": FieldValue.increment(-_number),
                    });
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesLast)
                        .collection("place")
                        .doc(widget.docPlaceLast)
                        .set({
                      "batch": widget.batch,
                      "idDoc": widget.idDoc,
                      "dateCome": widget.dateCome,
                      "name": widget.name,
                      "quantity": _number,
                      "unit": widget.unit,
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    null;
                  }
                }
              } else {
                // Jika dokumen tidak ada, buat dokumen baru
                if (widget.docInventoriesFirst == "") {
                  FirebaseFirestore.instance
                      .collection("stocks")
                      .doc(widget.docPlaceFirst)
                      .update({
                    "placement": true,
                  });
                  FirebaseFirestore.instance
                      .collection("inventories")
                      .doc(widget.docInventoriesLast)
                      .collection("place")
                      .doc(widget.docPlaceLast)
                      .set({
                    "batch": widget.batch,
                    "idDoc": widget.idDoc,
                    "dateCome": widget.dateCome,
                    "name": widget.name,
                    "quantity": widget.quantity,
                    "unit": widget.unit,
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  if (_number != 0 && _number == widget.quantity) {
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesFirst)
                        .collection("place")
                        .doc(widget.docPlaceFirst)
                        .delete();
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesLast)
                        .collection("place")
                        .doc(widget.docPlaceLast)
                        .set({
                      "batch": widget.batch,
                      "idDoc": widget.idDoc,
                      "dateCome": widget.dateCome,
                      "name": widget.name,
                      "quantity": widget.quantity,
                      "unit": widget.unit,
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else if (_number != 0 && _number < widget.quantity) {
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesFirst)
                        .collection("place")
                        .doc(widget.docPlaceFirst)
                        .update({
                      "quantity": FieldValue.increment(-_number),
                    });
                    FirebaseFirestore.instance
                        .collection("inventories")
                        .doc(widget.docInventoriesLast)
                        .collection("place")
                        .doc(widget.docPlaceLast)
                        .set({
                      "batch": widget.batch,
                      "idDoc": widget.idDoc,
                      "dateCome": widget.dateCome,
                      "name": widget.name,
                      "quantity": _number,
                      "unit": widget.unit,
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    null;
                  }
                }
              }
              DateTime dateTime = DateTime.now();
              String idDocHistory =
                  "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

              HistoryLogModel history = HistoryLogModel(
                idDoc: idDocHistory,
                date: dateTime.day,
                month: dateTime.month,
                year: dateTime.year,
                dateTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                keterangan: "Memindahkan item",
                user: FirebaseAuth.instance.currentUser!.email ?? "",
                type: "update",
              );

              HistoryLogModelFunction historyLogFunction =
                  HistoryLogModelFunction(idDocHistory);

              await historyLogFunction.addHistory(history, idDocHistory);
            },
            child: Text(
              "Move",
              style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
