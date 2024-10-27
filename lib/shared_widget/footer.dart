import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/view_model/getVersionNew.dart';

class SonomaneFooter extends StatelessWidget {
  const SonomaneFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 0.3.w, color: Theme.of(context).colorScheme.outline),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      width: double.infinity,
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(),
          Text(
            'Copyright @Sonomane 2023',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.0.w, top: 6.h, bottom: 6.h),
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const ScreenDetailChangelog()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: SonomaneColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: TextButton(
                  onPressed: null,
                  child: Consumer<GetNewVersionApp>(
                      builder: (context, newVersi, _) {
                    return Text(
                      'Software Version : ${newVersi.newVersion}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: SonomaneColor.primary,
                          ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
