import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class ItemFormField extends StatelessWidget {
  final List items;
  final Function(int) onDelete;
  final Function onTap;
  final String title;

  const ItemFormField(
      {super.key,
      required this.items,
      required this.onDelete,
      required this.title,
      required this.onTap});

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
            child: GestureDetector(
              onTap: () {
                onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                      width: 2.w, color: Theme.of(context).colorScheme.outline),
                ),
                height: 53.h,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: ScrollConfiguration(
                          behavior: NoGloww(),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0; i < items.length; i++) ...{
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 5.w,
                                  ),
                                  child: Chip(
                                    deleteIconColor:
                                        SonomaneColor.textTitleDark,
                                    onDeleted: () {
                                      onDelete(i);
                                    },
                                    backgroundColor: SonomaneColor.primary,
                                    label: Text(
                                      items[i]['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                              }
                            ],
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.menu_book_rounded,
                      color: Theme.of(context).colorScheme.outline,
                      size: 24.sp,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
