import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerTable extends StatelessWidget {
  final String title;
  const ContainerTable({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
              width: 0.3.w, color: Theme.of(context).colorScheme.outline),
        ),
      ),
      child: Text(
        title,
        style:
            Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.sp),
      ),
    );
  }
}
