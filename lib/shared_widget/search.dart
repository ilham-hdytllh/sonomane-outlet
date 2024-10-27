import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class CustomSearch extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  const CustomSearch(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.keyboardType,
      required this.readOnly,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 53.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.r), bottomLeft: Radius.circular(5.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: TextFormField(
                controller: controller,
                onChanged: onChanged,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                cursorColor: SonomaneColor.primary,
                style: Theme.of(context).textTheme.titleMedium,
                readOnly: readOnly,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                  hintText: hintText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        bottomLeft: Radius.circular(5.r),
                        topRight: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.w),
                  ),
                  errorStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: SonomaneColor.primary),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        bottomLeft: Radius.circular(5.r),
                        topRight: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.w),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        bottomLeft: Radius.circular(5.r),
                        topRight: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r)),
                    borderSide: BorderSide(
                      width: 1.w,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        bottomLeft: Radius.circular(5.r),
                        topRight: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        bottomLeft: Radius.circular(5.r),
                        topRight: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r)),
                    borderSide: BorderSide(
                      width: 1.w,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: SonomaneColor.primary,
              border: Border.all(
                width: 5.w,
                color: SonomaneColor.primary,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.r),
                bottomRight: Radius.circular(5.r),
              ),
            ),
            height: 53.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Icon(
                Icons.search,
                size: 24.sp,
                color: SonomaneColor.textTitleDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
