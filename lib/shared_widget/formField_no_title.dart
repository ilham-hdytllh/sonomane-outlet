import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class CustomFormFieldNoTitle extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String hintText;
  final bool readOnly;
  final TextInputType textInputType;
  final IconData? suffixIcon;
  final Function? onTap;
  const CustomFormFieldNoTitle({
    super.key,
    required this.readOnly,
    this.textEditingController,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        onTap != null ? onTap!() : null;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tidak boleh kosong';
        }
        return null;
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      cursorColor: SonomaneColor.primary,
      style: Theme.of(context).textTheme.titleMedium,
      controller: textEditingController,
      readOnly: readOnly,
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: Icon(suffixIcon),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        hintStyle: Theme.of(context).textTheme.titleMedium,
        hintText: hintText,
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
    );
  }
}
