import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoRecord extends StatelessWidget {
  const NoRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      width: double.infinity,
      height: 100.h,
      child: Center(
        child: Text(
          "- No Record(s) -",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        ),
      ),
    );
  }
}
