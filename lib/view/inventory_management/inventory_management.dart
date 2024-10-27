import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/adjust_stock.dart/adjust_stock.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/bill_of_material/add_bom.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/bill_of_material/table_bom.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/item/add_item.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/item/table_item.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/spoile/add_spoile.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/spoile/table_spoile.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/stock/add_stock.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/stock/reduce_stock.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/stock/table_stock.dart';
// import 'package:sonomaneoutlet/view/inventory_management/pages/stock/add_stock.dart';
// import 'package:sonomaneoutlet/view/inventory_management/pages/history/table_history_inventories.dart';
// import 'package:sonomaneoutlet/view/inventory_management/pages/control_storage/inventori_management.dart';
// import 'package:sonomaneoutlet/view/inventory_management/pages/stock/table_stock.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/unit/add_unit.dart';
import 'package:sonomaneoutlet/view/inventory_management/pages/unit/table_unit.dart';

// ignore: must_be_immutable
class ScreenInventoryManagement extends StatefulWidget {
  const ScreenInventoryManagement({super.key});

  @override
  State<ScreenInventoryManagement> createState() =>
      _ScreenInventoryManagementState();
}

class _ScreenInventoryManagementState extends State<ScreenInventoryManagement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int tabIndex = 0;

  Stream? getAllItem;
  Stream? getAllUnit;
  Stream? getAllStok;
  Stream? billOfMaterial;
  Stream? adjustmentStock;
  Stream? spoile;

  @override
  void initState() {
    super.initState();
    spoile = FirebaseFirestore.instance
        .collection("spoile")
        .orderBy("date", descending: true)
        .snapshots();
    adjustmentStock = FirebaseFirestore.instance
        .collection("adjustmentStock")
        .orderBy("status", descending: true)
        .orderBy("date", descending: false)
        .snapshots();
    getAllItem = FirebaseFirestore.instance
        .collection("items")
        .orderBy("createdAt", descending: true)
        .snapshots();
    getAllItem = FirebaseFirestore.instance
        .collection("items")
        .orderBy("createdAt", descending: true)
        .snapshots();
    getAllUnit = FirebaseFirestore.instance
        .collection("units")
        .orderBy("createdAt", descending: true)
        .snapshots();

    getAllStok = FirebaseFirestore.instance
        .collection("stocks")
        .orderBy("itemName", descending: false)
        .snapshots();

    billOfMaterial = FirebaseFirestore.instance
        .collection("billOfMaterial")
        .orderBy("menuName", descending: false)
        .snapshots();

    _controller = TabController(
        length: 8,
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
      length: 8,
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
                          'assets/images/inventory.png',
                          fit: BoxFit.cover,
                          width: 26,
                          height: 26,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Inventory',
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
                          width: 580.w,
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
                                      'Unit',
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
                                      'Item',
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
                                  child: const Center(
                                    child: Text(
                                      'Item IN',
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
                                  child: const Center(
                                    child: Text(
                                      'Item OUT',
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
                                      'Stock',
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
                                    color: tabIndex == 5
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 5
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Set BOM',
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
                                    color: tabIndex == 6
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 6
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Adj Stock',
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
                                    color: tabIndex == 7
                                        ? SonomaneColor.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                        width: 0.1.w,
                                        color: tabIndex == 7
                                            ? SonomaneColor.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Spoile',
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
                                    stream: getAllUnit,
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
                                                  "List Unit",
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
                                                              const AddUnit(),
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
                                                      "Add Unit",
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
                                            child: UnitTable(data: data),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: getAllItem,
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
                                                  "List Item",
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
                                                              const AddItem(),
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
                                                      "Add Item",
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
                                            child: ItemTable(data: data),
                                          ),
                                        ],
                                      );
                                    }),
                                const AddStock(),
                                const ReduceStock(),
                                StreamBuilder(
                                    stream: getAllStok,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Database error",
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
                                                  "List Stock",
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
                                            child: StockTable(
                                              data: data,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                // StreamBuilder(
                                //     stream: getHistoryInventories,
                                //     builder: (context, AsyncSnapshot snapshot) {
                                //       if (snapshot.hasError) {
                                //         return Center(
                                //           child: Text(
                                //             "Database error",
                                //             style: Theme.of(context)
                                //                 .textTheme
                                //                 .titleMedium,
                                //           ),
                                //         );
                                //       } else if (snapshot.connectionState ==
                                //           ConnectionState.waiting) {
                                //         return Center(
                                //           child: SizedBox(
                                //             height: 45.h,
                                //             width: 45.h,
                                //             child: CircularProgressIndicator(
                                //                 color: SonomaneColor.primary),
                                //           ),
                                //         );
                                //       }
                                //       List data = [];

                                //       snapshot.data.docs.map((value) {
                                //         Map doc = value.data();
                                //         data.add(doc);
                                //       }).toList();

                                //       return Column(
                                //         children: [
                                //           SizedBox(
                                //             height: 20.h,
                                //           ),
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(
                                //                 horizontal: 10.0.w),
                                //             child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.start,
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.center,
                                //               children: [
                                //                 Text(
                                //                   "History",
                                //                   style: Theme.of(context)
                                //                       .textTheme
                                //                       .headlineLarge,
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             height: 10.h,
                                //           ),
                                //           Expanded(
                                //             child: HistoryInventories(
                                //               data: data,
                                //             ),
                                //           ),
                                //         ],
                                //       );
                                //     }),
                                StreamBuilder(
                                    stream: billOfMaterial,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Database error",
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
                                        data.add(doc);
                                      }).toList();

                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 20.h,
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
                                                  "Bill Of Material",
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
                                                              const AddBOM(),
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
                                                      "Add BOM",
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
                                            child: BOMTable(
                                              data: data,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: adjustmentStock,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Database error",
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
                                        data.add(doc);
                                      }).toList();

                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 20.h,
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
                                                  "Adjustment Stock",
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
                                            child: AdjustStock(data: data),
                                          ),
                                        ],
                                      );
                                    }),
                                StreamBuilder(
                                    stream: spoile,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Database error",
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
                                        data.add(doc);
                                      }).toList();

                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 20.h,
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
                                                  "List Spoile",
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
                                                              const AddSpoile(),
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
                                                      "Add Spoile",
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
                                            child: SpoileTable(data: data),
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
