import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/kitchen_management/pages/bar/bar_order.dart';
import 'package:sonomaneoutlet/view/kitchen_management/pages/kitchen/kitchen_order.dart';

class ScreenKitchenManagement extends StatelessWidget {
  const ScreenKitchenManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/kitchen.png',
                        fit: BoxFit.cover,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        'Kitchen Order & Bar Order',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 20.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const KitchenOrder()));
                            },
                            child: Container(
                              margin: EdgeInsets.all(40.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/sonomane_place_kitchen.jpg'),
                                    fit: BoxFit.cover),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'Restaurant',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 45.sp,
                                          fontWeight: FontWeight.w700,
                                          color: SonomaneColor.textTitleDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const BarOrder()));
                            },
                            child: Container(
                              margin: EdgeInsets.all(40.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/sonomane_place_bar.jpg'),
                                    fit: BoxFit.cover),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'BAR',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 45.sp,
                                          fontWeight: FontWeight.w700,
                                          color: SonomaneColor.textTitleDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              const SonomaneFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
