import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

// ignore: must_be_immutable
class CustomButtonIcon extends StatelessWidget {
  bool? isLoading;
  bool? isLoading2;
  String title;
  Function onTap;
  Color color;
  Color bgColor;
  Icon icon;
  CustomButtonIcon({
    super.key,
    this.isLoading,
    this.isLoading2,
    required this.title,
    required this.onTap,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0.r),
          ),
        ),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(bgColor),
      ),
      onPressed: () {
        onTap();
      },
      icon: icon,
      label: Center(
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
