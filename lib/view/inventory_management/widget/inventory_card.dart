import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/view/inventory_management/widget/taken_dialog.dart';

// ignore: must_be_immutable
class InventoryCard extends StatefulWidget {
  String namaDoc;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;
  final VoidCallback onDraggableCanceled;
  InventoryCard(
      {super.key,
      required this.namaDoc,
      required this.onDragStarted,
      required this.onDragEnd,
      required this.onDraggableCanceled});

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  Stream? place;
  @override
  void initState() {
    super.initState();
    place = FirebaseFirestore.instance
        .collection("inventories")
        .doc(widget.namaDoc)
        .collection("place")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: place,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error database",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          var data = snapshot.data.docs;
          return ScrollConfiguration(
            behavior: NoGloww(),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 5.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Draggable(
                    feedback: SizedBox(
                      width: 250.w,
                      height: 60.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0.w, vertical: 2.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                width: 0.1.w, color: Colors.grey.shade500),
                          ),
                          width: double.infinity,
                          height: 60.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 5.w,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: data[index]['quantity'] < 10
                                      ? SonomaneColor.primary
                                      : SonomaneColor.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    bottomLeft: Radius.circular(5.r),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data[index]['batch'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${data[index]['quantity'].toString()}/${data[index]['unit']}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: data[index]['quantity'] < 10
                                            ? SonomaneColor.primary
                                            : Colors.green),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0.w, vertical: 2.h),
                      child: DottedBorder(
                          strokeWidth: 1,
                          dashPattern: const [10, 6],
                          radius: Radius.circular(5.r),
                          color: Colors.grey.shade500,
                          child: SizedBox(
                            width: double.infinity,
                            height: 60.h,
                          )),
                    ), // Tambahkan ini jika perlu
                    data: {
                      "nameDoc": widget.namaDoc,
                      "batch": data[index]['batch'],
                      "idDoc": data[index]['idDoc'],
                      "dateCome": data[index]['dateCome'],
                      "name": data[index]['name'],
                      "quantity": data[index]['quantity'],
                      "unit": data[index]['unit'],
                    }, // Data yang akan dikirim saat item di-drop
                    feedbackOffset:
                        const Offset(0, 0), // Sesuaikan jika diperlukan
                    onDragStarted: () {
                      widget.onDragStarted.call();
                    },

                    onDragEnd: (details) {
                      widget.onDragEnd.call();
                    },
                    onDraggableCanceled: (velocity, offset) {
                      widget.onDraggableCanceled.call();
                    },
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => TakenDialog(
                            docInventories: widget.namaDoc,
                            docPlace: data[index]['idDoc'],
                            batch: data[index]['batch'],
                            idDoc: data[index]['idDoc'],
                            dateCome: data[index]['dateCome'],
                            name: data[index]['name'],
                            quantity: data[index]['quantity'],
                            unit: data[index]['unit'],
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0.w, vertical: 2.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                width: 0.1.w, color: Colors.grey.shade500),
                          ),
                          width: double.infinity,
                          height: 60.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 5.w,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: data[index]['quantity'] < 10
                                      ? SonomaneColor.primary
                                      : SonomaneColor.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    bottomLeft: Radius.circular(5.r),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data[index]['batch'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${data[index]['quantity'].toString()}/${data[index]['unit']}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: data[index]['quantity'] < 10
                                          ? SonomaneColor.primary
                                          : Colors.green,
                                    ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
