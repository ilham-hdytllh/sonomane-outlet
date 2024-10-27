import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

// ignore: must_be_immutable
class CustomDropdownMap extends StatelessWidget {
  final String codeORname;
  final void Function(Map<String, dynamic>?) onChanged;
  final void Function(String code, String name)? onItemSelected;
  Map<String, dynamic>? mapNow;
  String title;
  String hintText;
  List<Map<String, dynamic>> data;

  CustomDropdownMap({
    Key? key,
    required this.onChanged,
    this.onItemSelected,
    this.mapNow,
    required this.title,
    required this.hintText,
    required this.data,
    required this.codeORname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<Map<String, dynamic>>(
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
          iconDisabledColor: SonomaneColor.primary,
          isExpanded: true,
          elevation: 0,
          hint: Text(
            hintText,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          value: mapNow,
          items: data.map((Map<String, dynamic> value) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: value,
              child: Text(
                codeORname == "code"
                    ? value["itemCode"]
                    : value['itemName'] ?? "",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }).toList(),
          onChanged: (value) {
            onChanged(value);
            if (onItemSelected != null) {
              onItemSelected!(value!['itemCode'], value['itemName']);
            }
          },
        ),
      ),
    );
  }
}
