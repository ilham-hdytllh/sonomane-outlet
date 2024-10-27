import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sonomaneoutlet/common/colors.dart';

// ignore: must_be_immutable
class DropdownWithSearchNoValidator extends StatelessWidget {
  TextEditingController controller;
  List<String> data;
  String hintText;
  FocusNode focusNode;
  DropdownWithSearchNoValidator(
      {super.key,
      required this.controller,
      required this.data,
      required this.hintText,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return SearchField(
      suggestions: data
          .map((e) => SearchFieldListItem(e,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Text(
                    e,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )))
          .toList(),
      suggestionState: Suggestion.expand,
      textInputAction: TextInputAction.next,
      maxSuggestionsInViewPort: 3,
      hint: hintText,
      controller: controller,
      suggestionsDecoration: SuggestionDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          left: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.w),
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.w),
          right: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.w),
        ),
      ),
      suggestionDirection: SuggestionDirection.down,
      suggestionStyle: Theme.of(context).textTheme.titleMedium,
      searchStyle: Theme.of(context).textTheme.titleMedium,
      searchInputDecoration: InputDecoration(
        suffixIcon: Icon(
          Icons.expand_circle_down_rounded,
          size: 28.sp,
        ),
        hintStyle: Theme.of(context).textTheme.titleMedium,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
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
      focusNode: focusNode,
      itemHeight: 50,
    );
  }
}
