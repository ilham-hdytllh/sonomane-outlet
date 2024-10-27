import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class TableCard extends StatefulWidget {
  final String max;
  final String number;
  final bool ketersediaan;
  final bool isSelected;
  const TableCard({
    super.key,
    required this.max,
    required this.number,
    required this.ketersediaan,
    required this.isSelected,
  });

  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> {
  List order = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('tables')
        .doc(widget.number)
        .collection('orders')
        .snapshots()
        .listen((value) {
      value.docs.map((data) {
        Map a = data.data();
        order.add(a);
        if (mounted) {
          setState(() {});
        }
      }).toList();
    });
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
              color: widget.isSelected == true
                  ? SonomaneColor.primary
                  : order.isNotEmpty
                      ? SonomaneColor.textTitleLight.withOpacity(0.6)
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
                  color: widget.isSelected == true
                      ? SonomaneColor.primary
                      : order.isNotEmpty
                          ? SonomaneColor.textTitleLight.withOpacity(0.6)
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
                  color: widget.isSelected == true
                      ? SonomaneColor.primary
                      : order.isNotEmpty
                          ? SonomaneColor.textTitleLight.withOpacity(0.6)
                          : SonomaneColor.textParaghrapDark,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.number,
                      style: TextStyle(
                          color: widget.isSelected == true
                              ? SonomaneColor.textParaghrapDark
                              : order.isNotEmpty
                                  ? SonomaneColor.textParaghrapDark
                                  : SonomaneColor.textTitleLight
                                      .withOpacity(0.8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      'Max :  ${widget.max}',
                      style: TextStyle(
                          color: widget.isSelected == true
                              ? SonomaneColor.textParaghrapDark
                              : order.isNotEmpty
                                  ? SonomaneColor.textParaghrapDark
                                  : SonomaneColor.textTitleLight
                                      .withOpacity(0.8),
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
                  color: widget.isSelected == true
                      ? SonomaneColor.primary
                      : order.isNotEmpty
                          ? SonomaneColor.textTitleLight.withOpacity(0.6)
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
              color: widget.isSelected == true
                  ? SonomaneColor.primary
                  : order.isNotEmpty
                      ? SonomaneColor.textTitleLight.withOpacity(0.6)
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

    // Container(
    //   width: 180,
    //   height: 120,
    //   decoration: BoxDecoration(
    //     color: order.isEmpty
    //         ? Theme.of(context).colorScheme.background
    //         : SonomaneColor.primary,
    //     borderRadius: BorderRadius.circular(10.r),
    //   ),
    //   padding: EdgeInsets.all(16.w),
    //   child: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           'Meja',
    //           style: Theme.of(context).textTheme.headlineSmall!.copyWith(
    //                 fontWeight: FontWeight.bold,
    //                 color: order.isEmpty
    //                     ? Theme.of(context).colorScheme.tertiary
    //                     : SonomaneColor.textTitleDark,
    //               ),
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Text(
    //           widget.number,
    //           style: Theme.of(context).textTheme.headlineSmall!.copyWith(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 14.sp,
    //                 color: order.isEmpty
    //                     ? Theme.of(context).colorScheme.tertiary
    //                     : SonomaneColor.textTitleDark,
    //               ),
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Text(
    //           'Kapasitas : ${widget.max}',
    //           style: Theme.of(context).textTheme.headlineSmall!.copyWith(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 14.sp,
    //                 color: order.isEmpty
    //                     ? Theme.of(context).colorScheme.tertiary
    //                     : SonomaneColor.textTitleDark,
    //               ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
