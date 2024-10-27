import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

// ignore: must_be_immutable
class CustomDropdownNoTitle extends StatelessWidget {
  final void Function(dynamic) onChanged;
  String? textNow;
  String hintText;
  List<dynamic> data;

  CustomDropdownNoTitle(
      {super.key,
      required this.onChanged,
      this.textNow,
      required this.hintText,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0.w),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            menuMaxHeight: 230.h,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tidak boleh kosong';
              }
              return null;
            },
            dropdownColor: Theme.of(context).colorScheme.background,
            icon: Icon(
              Icons.expand_circle_down_rounded,
              size: 28.sp,
            ),
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
            iconEnabledColor: SonomaneColor.primary,
            // iconDisabledColor: SonomaneColor.primary,
            isExpanded: true,
            elevation: 0,
            value: textNow,
            hint: Text(
              hintText,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            items: data.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
