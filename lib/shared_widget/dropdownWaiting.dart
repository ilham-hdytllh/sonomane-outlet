import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

// ignore: must_be_immutable
class DropdownWaiting extends StatelessWidget {
  String hintText;
  DropdownWaiting({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Tidak boleh kosong';
          }
          return null;
        },
        decoration: InputDecoration(
          errorStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: SonomaneColor.primary),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline, width: 1.w),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline, width: 1.w),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        onChanged: null,
        dropdownColor: Theme.of(context).colorScheme.primaryContainer,
        icon: Icon(
          Icons.expand_circle_down_rounded,
          size: 28.sp,
        ),
        iconEnabledColor: SonomaneColor.primary,
        iconDisabledColor: SonomaneColor.primary,
        isExpanded: true,
        hint: Text(
          hintText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        items: [
          DropdownMenuItem(
            value: hintText,
            child: Text(
              hintText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
