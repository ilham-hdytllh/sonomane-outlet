import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class DropdownSearchMap extends StatelessWidget {
  final String title;
  final String parameter;
  final String hintText;
  final TextEditingController controller;
  final List data;
  final Function(Map<String, dynamic>) onItemSelected;
  const DropdownSearchMap(
      {super.key,
      required this.title,
      required this.controller,
      required this.data,
      required this.onItemSelected,
      required this.parameter,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 15.h,
        ),
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            style: Theme.of(context).textTheme.titleMedium,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.only(left: 10.w),
              suffixIcon: Icon(
                Icons.expand_circle_down_rounded,
                size: 28.sp,
              ),
              hintStyle: Theme.of(context).textTheme.titleMedium,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 1.w),
              ),
              errorStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: SonomaneColor.primary),
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            return data.where((item) =>
                item[parameter].toLowerCase().contains(pattern.toLowerCase()));
          },
          keepSuggestionsOnLoading: false,
          noItemsFoundBuilder: (context) {
            return SizedBox(
              height: 100.h,
              child: Center(
                child: Text(
                  "No item found",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          },
          itemBuilder: (context, suggestion) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 8.w, right: 8.w, bottom: 10.h, top: 10.h),
              child: Text(
                suggestion[parameter],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            onItemSelected(suggestion);
          },
        ),
      ],
    );
  }
}
