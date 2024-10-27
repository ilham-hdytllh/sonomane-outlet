import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class CustomGenerateCode extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final String hintText;
  final bool readOnly;
  final TextInputType textInputType;
  final Function onTap;
  const CustomGenerateCode({
    super.key,
    required this.title,
    required this.readOnly,
    required this.textEditingController,
    required this.hintText,
    required this.textInputType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 53.h,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.r),
                            bottomLeft: Radius.circular(5.r),
                          ),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(SonomaneColor.primary),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
                      ),
                    ),
                    onPressed: null,
                    child: Text(
                      "SNM-",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: SonomaneColor.textTitleDark),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                      hintText: hintText,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.w),
                      ),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: SonomaneColor.primary),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.w),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.w),
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
                SizedBox(
                  width: 5.w,
                ),
                SizedBox(
                  height: 53.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: SonomaneColor.primary,
                            width: 1.w,
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(SonomaneColor.primary),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
                        ),
                      ),
                      onPressed: () {
                        onTap();
                      },
                      child: Text(
                        "Generate",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: SonomaneColor.textTitleDark),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
