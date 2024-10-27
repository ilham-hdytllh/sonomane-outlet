import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/outline_custom_button.dart';

class BarCard extends StatefulWidget {
  final String datetime;
  final String nameuser;
  final String ordertype;
  final String orderid;
  final String tablenumber;
  final String tableOrderId;

  const BarCard({
    super.key,
    required this.datetime,
    required this.nameuser,
    required this.ordertype,
    required this.orderid,
    required this.tablenumber,
    required this.tableOrderId,
  });

  @override
  State<BarCard> createState() => _BarCardState();
}

class _BarCardState extends State<BarCard> {
  bool isLoading = false;
  Stream? barOrder;
  List idDocPesanan = [];

  late DateTime _startTime;
  late Timer _timer;

  void checkAll(List data) {
    if (idDocPesanan.length == data.length) {
      idDocPesanan.clear();
    } else {
      idDocPesanan = List.from(data.map((doc) => doc["idDoc"]));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    barOrder = FirebaseFirestore.instance
        .collection("tables")
        .doc(widget.tablenumber)
        .collection("orders")
        .doc(widget.tableOrderId)
        .collection("pesanan")
        .where("kitchen_or_bar", isEqualTo: "bar")
        .snapshots();
    _startTime = DateTime.parse(widget.datetime);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _startTime;
    _timer;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final duration = now.difference(_startTime);
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 70.h,
              decoration: BoxDecoration(color: SonomaneColor.primary),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Meja ${widget.tablenumber}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleDark),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            widget.tableOrderId,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 10.sp,
                                    color: SonomaneColor.textParaghrapDark),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            widget.nameuser.toString().capitalize(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleDark),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.datetime.substring(11, 16),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleDark),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            widget.datetime.substring(0, 11),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 10.sp,
                                    color: SonomaneColor.textParaghrapDark),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    color: SonomaneColor.textTitleDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream: barOrder,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error database",
                        style: Theme.of(context).textTheme.titleMedium);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: SonomaneColor.primary,
                      ),
                    );
                  }
                  List data = []; // Pindahkan ke sini
                  snapshot.data.docs.map((value) {
                    Map doc = value.data();
                    doc['idDoc'] = value.id;
                    data.add(doc);
                  }).toList();
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15.0.w, top: 15.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${data[index]["quantity"]} x',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 14.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                data[index]["name"]
                                                    .toString()
                                                    .capitalize(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      decoration: data[index]
                                                                  ["done"] ??
                                                              false == true
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                      fontSize: 14.sp,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 22.0.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 6.h,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: 1.w,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Addons :',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontSize: 12.sp,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              for (int i = 0;
                                                  i <
                                                      data[index]["addons"]
                                                          .length;
                                                  i++) ...{
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4.h),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${data[index]["addons"][i]['quantity']} x'
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontSize: 12.sp,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Text(
                                                        data[index]["addons"][i]
                                                            ['name'],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  decoration: data[index]
                                                                              [
                                                                              "done"] ??
                                                                          false ==
                                                                              true
                                                                      ? TextDecoration
                                                                          .lineThrough
                                                                      : null,
                                                                  fontSize:
                                                                      14.sp,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              },
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  data[index]["done"] != true
                                      ? Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            splashRadius: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3.r),
                                            ),
                                            activeColor: SonomaneColor.primary,
                                            checkColor:
                                                SonomaneColor.textTitleDark,
                                            value: idDocPesanan
                                                .contains(data[index]["idDoc"]),
                                            onChanged: (value) {
                                              if (idDocPesanan.contains(
                                                  data[index]["idDoc"])) {
                                                idDocPesanan.remove(
                                                    data[index]["idDoc"]);
                                              } else {
                                                idDocPesanan
                                                    .add(data[index]["idDoc"]);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.green,
                                            size: 32.sp,
                                          ),
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Catatan : ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 13.sp,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      data[index]["noted"] ?? "-",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: 13.sp,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                }),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: StreamBuilder(
                  stream: barOrder,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error database",
                          style: Theme.of(context).textTheme.titleMedium);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return OutlinedCustomButton(
                        isLoading: false,
                        title: "Check All",
                        onTap: () {},
                        color: SonomaneColor.primary,
                        bgColor: SonomaneColor.primary,
                      );
                    }
                    List data = [];
                    snapshot.data.docs.map((value) {
                      Map doc = value.data();
                      doc['idDoc'] = value.id;
                      data.add(doc);
                    }).toList();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedCustomButton(
                            isLoading: false,
                            title: "Check All",
                            onTap: () {
                              checkAll(data);
                            },
                            color: SonomaneColor.primary,
                            bgColor: SonomaneColor.primary,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  SonomaneColor.primary),
                              side: MaterialStateProperty.all(BorderSide(
                                  width: 1.w, color: SonomaneColor.primary))),
                          onPressed: () async {
                            for (int index = 0;
                                index < idDocPesanan.length;
                                index++) {
                              FirebaseFirestore.instance
                                  .collection("tables")
                                  .doc(widget.tablenumber)
                                  .collection("orders")
                                  .doc(widget.tableOrderId)
                                  .collection("pesanan")
                                  .doc(idDocPesanan[index])
                                  .update({"done": true});
                            }
                          },
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: SonomaneColor.textTitleDark),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
