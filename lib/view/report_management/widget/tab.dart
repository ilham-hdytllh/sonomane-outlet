import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTab extends StatelessWidget {
  const CustomTab(
      {super.key,
      required this.color,
      required this.title,
      required this.colorBorder});
  final Color color;
  final Color colorBorder;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: EdgeInsets.all(0.sp),
      height: 41.h,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
          border: Border.all(width: 0.1.w, color: colorBorder),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
