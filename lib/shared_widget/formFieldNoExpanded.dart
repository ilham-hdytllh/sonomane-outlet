import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class CustomFormFieldNoExpanded extends StatelessWidget {
  final String title;
  final TextEditingController? textEditingController;
  final String hintText;
  final bool readOnly;
  final TextInputType textInputType;
  final IconData? suffixIcon;
  final Function? onTap;
  final Function? onTapSuffixIcon;
  final bool? obscureText;
  const CustomFormFieldNoExpanded({
    super.key,
    required this.title,
    required this.readOnly,
    this.textEditingController,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.onTap,
    this.onTapSuffixIcon,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.0.w),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: TextFormField(
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
            obscureText: obscureText ?? false,
            readOnly: readOnly,
            keyboardType: textInputType,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTap: () {
                    onTapSuffixIcon != null ? onTapSuffixIcon!() : null;
                  },
                  child: Icon(suffixIcon)),
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
          ),
        ),
      ],
    );
  }
}
