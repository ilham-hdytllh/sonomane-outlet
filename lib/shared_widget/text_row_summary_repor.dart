import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowSummaryReport extends StatelessWidget {
  final String numberic;
  final String title;
  const RowSummaryReport(
      {super.key, required this.numberic, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          numberic,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
