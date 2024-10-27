import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/view_model/getServerTime.dart';

class TakenDialog extends StatefulWidget {
  final String docInventories;
  final String docPlace;
  final String batch;
  final String idDoc;
  final String dateCome;
  final String name;
  final num quantity;
  final String unit;
  const TakenDialog(
      {super.key,
      required this.docInventories,
      required this.docPlace,
      required this.batch,
      required this.idDoc,
      required this.dateCome,
      required this.name,
      required this.quantity,
      required this.unit});

  @override
  State<TakenDialog> createState() => _TakenDialogState();
}

class _TakenDialogState extends State<TakenDialog> {
  final TextEditingController _quantity = TextEditingController();
  int _number = 0;

  bool isLoading = false;

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
                    "Tulis quantity yang ingin diambil ? Max : ${widget.quantity}",
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
                      color: SonomaneColor.primary,
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
            onPressed: isLoading == false
                ? () async {
                    if (_number == widget.quantity) {
                      setState(() {
                        isLoading = true;
                      });
                      await Provider.of<GetServerTime>(context, listen: false)
                          .getServerTime();
                      DateTime? waktuServer =
                          // ignore: use_build_context_synchronously
                          Provider.of<GetServerTime>(context, listen: false)
                              .serverTime;
                      await FirebaseFirestore.instance
                          .collection("stocks")
                          .doc(widget.docPlace)
                          .update({
                        "quantity": FieldValue.increment(-_number),
                      });
                      await FirebaseFirestore.instance
                          .collection("inventories")
                          .doc(widget.docInventories)
                          .collection("place")
                          .doc(widget.docPlace)
                          .delete();
                      await FirebaseFirestore.instance
                          .collection("history_inventories")
                          .add({
                        "quantity": _number,
                        "type": "taken",
                        "user": FirebaseAuth.instance.currentUser!.email,
                        "datetime":
                            DateFormat('yyyy-MM-dd HH:ss').format(waktuServer!),
                        "batch": widget.batch,
                        "name": widget.name,
                      });
                      setState(() {
                        isLoading = false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection("stocks")
                          .doc(widget.docPlace)
                          .update({
                        "quantity": FieldValue.increment(-_number),
                      });
                      await FirebaseFirestore.instance
                          .collection("inventories")
                          .doc(widget.docInventories)
                          .collection("place")
                          .doc(widget.docPlace)
                          .update({
                        "quantity": FieldValue.increment(-_number),
                      });
                      await FirebaseFirestore.instance
                          .collection("history_inventories")
                          .add({
                        "quantity": _number,
                        "type": "taken",
                        "user": FirebaseAuth.instance.currentUser!.email,
                        "datetime": DateFormat('yyyy-MM-dd HH:ss').format(
                          DateTime.now(),
                        ),
                        "batch": widget.batch,
                        "name": widget.name,
                      });
                      setState(() {
                        isLoading = false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
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
                      keterangan: "Mengambil item",
                      user: FirebaseAuth.instance.currentUser!.email ?? "",
                      type: "update",
                    );

                    HistoryLogModelFunction historyLogFunction =
                        HistoryLogModelFunction(idDocHistory);

                    await historyLogFunction.addHistory(history, idDocHistory);
                  }
                : () {},
            child: Text(
              "Taken",
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
