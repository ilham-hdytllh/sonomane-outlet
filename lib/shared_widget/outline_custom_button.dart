import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

// ignore: must_be_immutable
class OutlinedCustomButton extends StatelessWidget {
  bool? isLoading;
  bool? isLoading2;
  String title;
  Function onTap;
  Color color;
  Color bgColor;
  OutlinedCustomButton({
    super.key,
    this.isLoading,
    this.isLoading2,
    required this.title,
    required this.onTap,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(width: 1.w, color: bgColor),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0.r),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        onTap();
      },
      child: Center(
        child: isLoading == false
            ? Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: color),
              )
            : isLoading2 == false
                ? Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: color),
                  )
                : SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: SonomaneColor.containerLight,
                    ),
                  ),
      ),
    );
  }
}
