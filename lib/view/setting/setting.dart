import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/setting/pages/printer_setup/printer_setup.dart';

// ignore: must_be_immutable
class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  late TabController _controller;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: 2,
        initialIndex: 0,
        vsync: this,
        animationDuration: Duration.zero);
    _controller.addListener(() {
      setState(() {
        tabIndex = _controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            height: 32,
                            width: 32,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 24.sp,
                                  color: SonomaneColor.textTitleDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Image.asset(
                          'assets/images/banner.png',
                          fit: BoxFit.cover,
                          width: 26,
                          height: 26,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Settings',
                          style: Theme.of(context).textTheme.headlineLarge,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.r),
                              topRight: Radius.circular(8.r),
                            ),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          width: 350.w,
                          child: TabBar(
                            onTap: (index) {
                              setState(() {
                                tabIndex = index;
                              });
                            },
                            controller: _controller,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 0,
                            indicatorPadding: EdgeInsets.all(0.sp),
                            labelPadding: EdgeInsets.all(0.sp),
                            physics: const NeverScrollableScrollPhysics(),
                            labelColor: SonomaneColor.textTitleDark,
                            splashFactory: NoSplash.splashFactory,
                            padding: EdgeInsets.all(0.0.sp),
                            isScrollable: false,
                            unselectedLabelColor:
                                SonomaneColor.textParaghrapDark,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  topRight: Radius.circular(8.r),
                                ),
                                color: Colors.transparent),
                            tabs: [
                              Tab(
                                iconMargin: EdgeInsets.all(0.sp),
                                height: 41.h,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: tabIndex == 0
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 0
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Configure Printer',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                iconMargin: EdgeInsets.all(0.sp),
                                height: 41.h,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: tabIndex == 1
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 1
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Configure EDC',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.1.w,
                                  color: Theme.of(context).colorScheme.outline),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _controller,
                              children: const [
                                PrinterSetup(),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
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
      ),
    );
  }
}
