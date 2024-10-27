import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class ListFormField extends StatefulWidget {
  final List<TextEditingController> controller;
  final String title;
  const ListFormField(
      {super.key, required this.controller, required this.title});

  @override
  State<ListFormField> createState() => _ListFormFieldState();
}

class _ListFormFieldState extends State<ListFormField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.w, color: Theme.of(context).colorScheme.outline),
              ),
              height: 222.h,
              child: ScrollConfiguration(
                behavior: NoGlow(),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5.h),
                  shrinkWrap: true,
                  itemCount: widget.controller.length,
                  itemBuilder: (context, index) {
                    return buildFormField(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFormField(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: SonomaneColor.primary,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 12.sp),
              controller: widget.controller[index],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 12.sp),
                hintText: 'Tulis Cara Pakai Voucher',
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
          if (index == (widget.controller.length - 1)) ...[
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.add(TextEditingController());
                });
              },
              child: Icon(
                Icons.add_box_rounded,
                color: SonomaneColor.orange,
                size: 45.sp,
              ),
            ),
          ],
          if (index != (widget.controller.length - 1)) ...[
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller[index].clear();
                  widget.controller[index].dispose();
                  widget.controller.removeAt(index);
                });
              },
              child: Icon(
                Icons.delete,
                color: SonomaneColor.primary,
                size: 45.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
