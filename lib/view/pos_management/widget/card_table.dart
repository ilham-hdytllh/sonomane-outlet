import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class CustomCardTable extends StatefulWidget {
  final String tableNumber;
  final List selectedIndex;
  final int index;
  final String tableMax;
  const CustomCardTable(
      {super.key,
      required this.tableNumber,
      required this.selectedIndex,
      required this.index,
      required this.tableMax});

  @override
  State<CustomCardTable> createState() => _CustomCardTableState();
}

class _CustomCardTableState extends State<CustomCardTable> {
  List order = [];
  Future<void> getOrder() async {
    await FirebaseFirestore.instance
        .collection('tables')
        .doc(widget.tableNumber)
        .collection('orders')
        .get()
        .then((value) {
      value.docs.map((data) {
        Map a = data.data();
        order.add(a);
        setState(() {});
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      width: 105,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 15.h,
            width: 35.w,
            decoration: BoxDecoration(
              color: order.isNotEmpty
                  ? SonomaneColor.textTitleLight.withOpacity(0.6)
                  : widget.selectedIndex.contains(widget.index)
                      ? SonomaneColor.primary
                      : SonomaneColor.textParaghrapDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.r),
                topRight: Radius.circular(5.r),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 35.h,
                width: 15.w,
                decoration: BoxDecoration(
                  color: order.isNotEmpty
                      ? SonomaneColor.textTitleLight.withOpacity(0.6)
                      : widget.selectedIndex.contains(widget.index)
                          ? SonomaneColor.primary
                          : SonomaneColor.textParaghrapDark,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    bottomLeft: Radius.circular(5.r),
                  ),
                ),
              ),
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.w, color: SonomaneColor.textTitleDark),
                    borderRadius: BorderRadius.circular(5.r),
                    color: order.isNotEmpty
                        ? SonomaneColor.textTitleLight.withOpacity(0.6)
                        : widget.selectedIndex.contains(widget.index)
                            ? SonomaneColor.primary
                            : SonomaneColor.textParaghrapDark),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.tableNumber,
                      style: TextStyle(
                          color: order.isNotEmpty
                              ? SonomaneColor.textTitleDark
                              : widget.selectedIndex.contains(widget.index)
                                  ? SonomaneColor.textTitleDark
                                  : SonomaneColor.textTitleLight,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      'Max :  ${widget.tableMax}',
                      style: TextStyle(
                          color: order.isNotEmpty
                              ? SonomaneColor.textTitleDark
                              : widget.selectedIndex.contains(widget.index)
                                  ? SonomaneColor.textTitleDark
                                  : SonomaneColor.textTitleLight,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35.h,
                width: 15.w,
                decoration: BoxDecoration(
                  color: order.isNotEmpty
                      ? SonomaneColor.textTitleLight.withOpacity(0.6)
                      : widget.selectedIndex.contains(widget.index)
                          ? SonomaneColor.primary
                          : SonomaneColor.textParaghrapDark,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    bottomRight: Radius.circular(5.r),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 15.h,
            width: 35.w,
            decoration: BoxDecoration(
              color: order.isNotEmpty
                  ? SonomaneColor.textTitleLight.withOpacity(0.6)
                  : widget.selectedIndex.contains(widget.index)
                      ? SonomaneColor.primary
                      : SonomaneColor.textParaghrapDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.r),
                bottomRight: Radius.circular(5.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
