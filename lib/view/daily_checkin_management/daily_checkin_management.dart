import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/daily_checkin/daily_point.dart';
import 'package:sonomaneoutlet/model/daily_checkin/daily_reward.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_point/table_daily_point.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/pages/daily_reward/table_daily_reward.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/widget/dialog_point_or_voucher..dart';

class DailyCheckinManagement extends StatefulWidget {
  const DailyCheckinManagement({super.key});

  @override
  State<DailyCheckinManagement> createState() => _DailyCheckinManagementState();
}

class _DailyCheckinManagementState extends State<DailyCheckinManagement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int tabIndex = 0;

  Stream? _dailyPoints;
  Stream? _dailyReward;

  @override
  void initState() {
    super.initState();
    _dailyPoints = DailyPointFunction().getDailyPoint();

    _dailyReward =
        DailyRewardFunction(dailyRewardModel: "", jenis: "").getDailyReward();

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
                        Image.asset(
                          'assets/images/menufood.png',
                          fit: BoxFit.cover,
                          width: 26,
                          height: 26,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Daily Checkin',
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
                          width: 300.w,
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
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: SonomaneColor.textTitleDark),
                            unselectedLabelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                            unselectedLabelColor:
                                Theme.of(context).colorScheme.tertiary,
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
                                  child: const Center(
                                    child: Text(
                                      'Daily Checkin Coint',
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
                                  child: const Center(
                                    child: Text(
                                      'Daily Checkin Reward',
                                      textAlign: TextAlign.center,
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
                              children: [
                                StreamBuilder(
                                    stream: _dailyPoints,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Error Database",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: SizedBox(
                                            height: 45.h,
                                            width: 45.h,
                                            child: CircularProgressIndicator(
                                                color: SonomaneColor.primary),
                                          ),
                                        );
                                      }
                                      List data = [];

                                      snapshot.data.docs.map((value) {
                                        Map doc = value.data();
                                        doc['idDoc'] = value.id;
                                        data.add(doc);
                                      }).toList();
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Daily Checkin Coint",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ScrollConfiguration(
                                                behavior: NoGloww(),
                                                child: SingleChildScrollView(
                                                  child: TableDailyPoint(
                                                      data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: _dailyReward,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Error Database",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: SizedBox(
                                            height: 45.h,
                                            width: 45.h,
                                            child: CircularProgressIndicator(
                                                color: SonomaneColor.primary),
                                          ),
                                        );
                                      }
                                      List data = [];

                                      snapshot.data.docs.map((value) {
                                        Map doc = value.data();
                                        doc['idDoc'] = value.id;
                                        data.add(doc);
                                      }).toList();
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Daily Checkin Reward",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                                SizedBox(
                                                  height: 45.h,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return const DialogPointORVoucher();
                                                          });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(SonomaneColor
                                                                  .primary),
                                                    ),
                                                    label: Text(
                                                      "Add Reward",
                                                      style: TextStyle(
                                                        color: SonomaneColor
                                                            .containerLight,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 22.sp,
                                                      color: SonomaneColor
                                                          .containerLight,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ScrollConfiguration(
                                                behavior: NoGloww(),
                                                child: SingleChildScrollView(
                                                  child: TableDailyReward(
                                                      data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
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
