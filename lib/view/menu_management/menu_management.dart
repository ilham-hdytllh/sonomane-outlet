import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/menu/menu.dart';
import 'package:sonomaneoutlet/model/menu_addon/menu_addon.dart';
import 'package:sonomaneoutlet/model/menu_category/menu_category.dart';
import 'package:sonomaneoutlet/model/menu_subcategory/menu_subcategory.dart';
import 'package:sonomaneoutlet/model/menu_voucher/menu_subscription.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu/add_menu.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu/table_menu.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_addon/add_addon.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_addon/table_addon.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_category/add_category.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_category/table_category.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_subcategory/add_subcategory.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_subcategory/table_subcategory.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_voucher/add_menu_voucher.dart';
import 'package:sonomaneoutlet/view/menu_management/pages/menu_voucher/table_menu_voucher.dart';

// ignore: must_be_immutable
class ScreenMenuManagement extends StatefulWidget {
  const ScreenMenuManagement({super.key});

  @override
  State<ScreenMenuManagement> createState() => _ScreenMenuManagementState();
}

class _ScreenMenuManagementState extends State<ScreenMenuManagement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int tabIndex = 0;

  Stream? dataMenu;
  Stream? dataMenuVoucher;
  Stream? dataMenuAddon;
  Stream? dataMenuCategory;
  Stream? dataMenuSubCategory;

  @override
  void initState() {
    super.initState();
    dataMenu = MenuFunction().getAllMenu();
    dataMenuVoucher = MenuSubscriptionFunction().getAllMenuSubscription();
    dataMenuAddon = AddonFunction().getAllAddon();
    dataMenuCategory = CategoryFunction().getAllCategory();
    dataMenuSubCategory = SubCategoryFunction().getAllSubCategory();

    _controller = TabController(
        length: 5,
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
      length: 5,
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
                          'Menu',
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
                          width: 550.w,
                          child: TabBar(
                            onTap: (index) {
                              setState(() {
                                tabIndex = index;
                              });
                            },
                            controller: _controller,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 0,
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
                            indicatorPadding: EdgeInsets.all(0.sp),
                            labelPadding: EdgeInsets.all(0.sp),
                            physics: const NeverScrollableScrollPhysics(),
                            labelColor: SonomaneColor.textTitleDark,
                            splashFactory: NoSplash.splashFactory,
                            padding: EdgeInsets.all(0.0.sp),
                            isScrollable: false,
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
                                      'Menu',
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
                                      'Menu Voucher',
                                      textAlign: TextAlign.center,
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
                                    color: tabIndex == 2
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 2
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Addon',
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
                                    color: tabIndex == 3
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 3
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Category',
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
                                    color: tabIndex == 4
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 4
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sub Category',
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
                                    stream: dataMenu,
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
                                                  "List Menu",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                                SizedBox(
                                                  height: 45.h,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddMenu(),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(SonomaneColor
                                                                  .primary),
                                                    ),
                                                    label: Text(
                                                      "Add Menu",
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
                                                behavior: NoGlow(),
                                                child: SingleChildScrollView(
                                                  child: TableMenu(data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: dataMenuVoucher,
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
                                                  "List Menu Voucher",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                                SizedBox(
                                                  height: 45.h,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddMenuVoucher(),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(SonomaneColor
                                                                  .primary),
                                                    ),
                                                    label: Text(
                                                      "Add Menu",
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
                                                behavior: NoGlow(),
                                                child: SingleChildScrollView(
                                                  child: TableMenuVoucher(
                                                      data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: dataMenuAddon,
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
                                                  "List Addon",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                                SizedBox(
                                                  height: 45.h,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddAddon(),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(SonomaneColor
                                                                  .primary),
                                                    ),
                                                    label: Text(
                                                      "Add Addon",
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
                                                behavior: NoGlow(),
                                                child: SingleChildScrollView(
                                                  child: TableAddon(data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: dataMenuCategory,
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
                                                  "List Category",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                                SizedBox(
                                                  height: 45.h,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddCategory(),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(SonomaneColor
                                                                  .primary),
                                                    ),
                                                    label: Text(
                                                      "Add Category",
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
                                                behavior: NoGlow(),
                                                child: SingleChildScrollView(
                                                  child:
                                                      TableCategory(data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: dataMenuSubCategory,
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
                                                  "List Sub Category",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                                SizedBox(
                                                  height: 45.h,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddSubCategory(),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(SonomaneColor
                                                                  .primary),
                                                    ),
                                                    label: Text(
                                                      "Add Sub Category",
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
                                                behavior: NoGlow(),
                                                child: SingleChildScrollView(
                                                  child: TableSubCategory(
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
