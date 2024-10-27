import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardOrder extends StatelessWidget {
  final String assetImage;
  final String type;
  final num total;
  final Function onTap;
  final Color color;
  const CardOrder(
      {super.key,
      required this.assetImage,
      required this.type,
      required this.total,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Theme.of(context).colorScheme.background,
          ),
          width: double.infinity,
          height: 90.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        assetImage,
                        fit: BoxFit.cover,
                        width: 22,
                        height: 22,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        type,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14.sp),
                      )
                    ],
                  ),
                ),
                Text(
                  total.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18.sp,
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
