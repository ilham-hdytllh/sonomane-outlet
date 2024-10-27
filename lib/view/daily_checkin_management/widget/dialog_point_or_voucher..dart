import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_reward/add_reward_point.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_reward/add_reward_voucher.dart';

// ignore: must_be_immutable
class DialogPointORVoucher extends StatefulWidget {
  const DialogPointORVoucher({super.key});

  @override
  State<DialogPointORVoucher> createState() => _DialogPointORVoucherState();
}

class _DialogPointORVoucherState extends State<DialogPointORVoucher> {
  String _jenis = "point";
  @override
  Widget build(BuildContext contextParent) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      title: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
            size: 18.sp,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      content: SizedBox(
        width: 300.h,
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _jenis = "point";
                        });
                      },
                      child: Container(
                        height: 65.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _jenis == "point"
                              ? SonomaneColor.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            width: 1.w,
                            color: _jenis == "point"
                                ? SonomaneColor.primary
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 24.sp,
                              color: _jenis == "point"
                                  ? SonomaneColor.primary
                                  : Theme.of(context).colorScheme.tertiary,
                            ),
                            Text(
                              "Point",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: _jenis == "point"
                                        ? SonomaneColor.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _jenis = "voucher";
                        });
                      },
                      child: Container(
                        height: 65.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _jenis == "voucher"
                              ? SonomaneColor.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            width: 1.w,
                            color: _jenis == "voucher"
                                ? SonomaneColor.primary
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.redeem,
                              size: 24.sp,
                              color: _jenis == "voucher"
                                  ? SonomaneColor.primary
                                  : Theme.of(context).colorScheme.tertiary,
                            ),
                            Text(
                              "Voucher",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: _jenis == "voucher"
                                        ? SonomaneColor.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: 50.h,
                width: 150.w,
                child: CustomButton(
                    title: "Next",
                    onTap: () {
                      if (_jenis == "point") {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddRewardPoint()));
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddRewardVoucher()));
                      }
                    },
                    isLoading: false,
                    color: SonomaneColor.textTitleDark,
                    bgColor: SonomaneColor.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
