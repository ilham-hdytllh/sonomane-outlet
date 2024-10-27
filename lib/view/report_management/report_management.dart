import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/custom_dropdown_notitle.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/report_management/pages/menu_cancel_report/table_menu_cancel_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/menu_sales_category_report/table_menu_sales_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/menu_sales_hour_report/menu_sales_hour_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/menu_sales_report/table_menu_sales_grand_total.dart';
import 'package:sonomaneoutlet/view/report_management/pages/menu_sales_report/table_menu_sales_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/payment_report/table_payment_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/payment_report/table_payment_report_today.dart';
import 'package:sonomaneoutlet/view/report_management/pages/payment_report/table_percentage_payment.dart';
import 'package:sonomaneoutlet/view/report_management/pages/stock_in/table_stock_in.dart';
import 'package:sonomaneoutlet/view/report_management/pages/stock_out/table_stock_out.dart';
import 'package:sonomaneoutlet/view/report_management/pages/stok_opname/table_stock_opname.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_bill_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_cancel_bill.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_cancel_menu.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_category_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_overall.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_paymnet_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_periode_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_promo_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_sales_by_type_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_subcategory_table.dart';
import 'package:sonomaneoutlet/view/report_management/pages/summary/summary_report_void_payment.dart';
import 'package:sonomaneoutlet/view/report_management/pages/sales_comparison_report/table_menu_sales_comparison.dart';
import 'package:sonomaneoutlet/view/report_management/pages/sales_report/table_sales_grand_total.dart';
import 'package:sonomaneoutlet/view/report_management/pages/sales_report/table_sales_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/sales_report/table_sales_report_today.dart';
import 'package:sonomaneoutlet/view/report_management/pages/waiter_report/table_waiter_cancel_report.dart';
import 'package:sonomaneoutlet/view/report_management/pages/waiter_report/table_waiter_order_report.dart';
import 'package:sonomaneoutlet/view/report_management/pemakaian_pos/table_pemakaian_pos.dart';
import 'package:sonomaneoutlet/view/report_management/widget/menu_cancel_report/menu_cancel_report_chart.dart';
import 'package:sonomaneoutlet/view/report_management/widget/menu_sales_category_report/menu_sales_category_chart_report.dart';
import 'package:sonomaneoutlet/view/report_management/widget/menu_sales_hour/menu_sales_hour_chart.dart';
import 'package:sonomaneoutlet/view/report_management/widget/menu_sales_report/menu_sales_chart.dart';
import 'package:sonomaneoutlet/view/report_management/pages/sales_comparison_report/table_sales_comparison_report.dart';
import 'package:sonomaneoutlet/view/report_management/widget/payment_report/payment_report_chart.dart';
import 'package:sonomaneoutlet/view/report_management/widget/sales_report/chart_week.dart';
import 'package:sonomaneoutlet/view/report_management/widget/sales_report_comparison/sales_report_comparison_chart.dart';
import 'package:sonomaneoutlet/view/report_management/widget/tab.dart';
import 'package:sonomaneoutlet/view/report_management/widget/waiter_report/waiter_report_chart.dart';

// ignore: must_be_immutable
class ScreenReportManagement extends StatefulWidget {
  const ScreenReportManagement({super.key});

  @override
  State<ScreenReportManagement> createState() => _ScreenReportManagementState();
}

class _ScreenReportManagementState extends State<ScreenReportManagement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int tabIndex = 0;
  int _lengthRow = 7;

  Stream? dataTransaction;
  String _selectedButton = "This Week";
  final List _selectedData = [
    "Today",
    "This Week",
    "This Month",
    "Last Month",
    "This Year",
  ];

  int selectedYear = DateTime.now().year;
  List<int> years = List.generate(10, (index) => DateTime.now().year - index);
  int selectedMonth = DateTime.now().month;
  List<Map<String, dynamic>> months = [
    {'value': 1, 'name': 'January'},
    {'value': 2, 'name': 'February'},
    {'value': 3, 'name': 'March'},
    {'value': 4, 'name': 'April'},
    {'value': 5, 'name': 'May'},
    {'value': 6, 'name': 'June'},
    {'value': 7, 'name': 'July'},
    {'value': 8, 'name': 'August'},
    {'value': 9, 'name': 'September'},
    {'value': 10, 'name': 'October'},
    {'value': 11, 'name': 'November'},
    {'value': 12, 'name': 'December'},
  ];

  final DateTime _currentDate = DateTime.now();
  final ApiBaseHelper api = ApiBaseHelper();

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? _startDateInv;
  DateTime? _endDateInv;

  int daysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError("Month must be in the range 1 to 12.");
    }
    final isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
    const List<int> daysInMonth = [
      0,
      31,
      28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return isLeapYear && month == DateTime.february ? 29 : daysInMonth[month];
  }

  void _updateDate(String type) {
    if (type == "This Week") {
      int weekday = _currentDate.weekday;
      _startDate = DateTime(
        _currentDate.year,
        _currentDate.month,
        _currentDate.day - weekday + 1,
        0,
        0,
        0,
        0,
      );

      // Memperbarui _endDate menjadi hari Minggu ini dengan jam 23:59:59.999
      _endDate = DateTime(
        _currentDate.year,
        _currentDate.month,
        _currentDate.day + (7 - weekday),
        23,
        59,
        59,
        999,
      );

      // Jika sudah hari Minggu, kita tidak perlu menambahkan 7 hari lagi
      if (weekday == 7) {
        _endDate = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
          23,
          59,
          59,
          999,
        );
      }
    } else if (type == "This Month") {
      _startDate = DateTime(_currentDate.year, _currentDate.month, 1);
      _endDate = DateTime(_currentDate.year, _currentDate.month + 1, 1)
          .subtract(const Duration(seconds: 1));
    } else if (type == "Last Month") {
      _startDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
      _endDate = DateTime(_currentDate.year, _currentDate.month, 1)
          .subtract(const Duration(seconds: 1));
    } else if (type == "This Year") {
      _startDate = DateTime(_currentDate.year, 1, 1);
      _endDate = DateTime(_currentDate.year, 12, 31, 23, 59, 59, 999);
    } else {
      _startDate =
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
      _endDate = DateTime(_currentDate.year, _currentDate.month,
          _currentDate.day, 23, 59, 59, 999);
    }
  }

  Future _fetchDataInventory(String type, bool? bom) async {
    // Memastikan _startDate dan _endDate tidak null
    if (_startDateInv == null || _endDateInv == null) {
      return;
    }

    String startOfDay =
        '${_startDateInv!.year}-${_startDateInv!.month.toString().padLeft(2, '0')}-${_startDateInv!.day.toString().padLeft(2, '0')} 00:00:00';
    String endOfDay =
        '${_endDateInv!.year}-${_endDateInv!.month.toString().padLeft(2, '0')}-${_endDateInv!.day.toString().padLeft(2, '0')} 23:59:59';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("adjustmentStock")
        .where("type", isEqualTo: type)
        .where("status", isEqualTo: "confirm")
        .where("bom", isEqualTo: bom)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .orderBy("date")
        .get();
    // List<DocumentSnapshot> documents = querySnapshot.docs;
    // for (var document in documents) {
    //   print(document['pesanan']);
    // }

    return querySnapshot;
  }

  Future _fetchData() async {
    // Memastikan _startDate dan _endDate tidak null
    if (_startDate == null || _endDate == null) {
      return;
    }

    String startOfDay =
        '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')} 00:00:00 +0700';
    String endOfDay =
        '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')} 23:59:59 +0700';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .where('transaction_time', isGreaterThanOrEqualTo: startOfDay)
        .where('transaction_time', isLessThanOrEqualTo: endOfDay)
        .get();
    // List<DocumentSnapshot> documents = querySnapshot.docs;
    // for (var document in documents) {
    //   print(document['pesanan']);
    // }

    return querySnapshot;
  }

  @override
  void initState() {
    super.initState();
    _updateDate("This Week");
    _startDateInv = DateTime(selectedYear, selectedMonth, 1);
    _endDateInv = DateTime(selectedYear, selectedMonth + 1, 0);

    _controller = TabController(
        length: 13,
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
      length: 13,
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
                          'assets/images/banner.png',
                          fit: BoxFit.cover,
                          width: 26,
                          height: 26,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Report',
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
                          width: double.infinity,
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
                              CustomTab(
                                  color: tabIndex == 0
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 0
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Sales'),
                              CustomTab(
                                  color: tabIndex == 1
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 1
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Sales'),
                              CustomTab(
                                  color: tabIndex == 2
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 2
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Menu Sales'),
                              CustomTab(
                                  color: tabIndex == 3
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 3
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Menu Sales Ctg'),
                              CustomTab(
                                  color: tabIndex == 4
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 4
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Menu Sales Hour'),
                              CustomTab(
                                  color: tabIndex == 5
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 5
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Payment'),
                              CustomTab(
                                  color: tabIndex == 6
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 6
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Menu Cancel'),
                              CustomTab(
                                  color: tabIndex == 7
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 7
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Waiter'),
                              CustomTab(
                                  color: tabIndex == 8
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 8
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Sales Comparison'),
                              CustomTab(
                                  color: tabIndex == 9
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 9
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'In Stock'),
                              CustomTab(
                                  color: tabIndex == 10
                                      ? SonomaneColor.primary
                                      : Colors.transparent,
                                  colorBorder: tabIndex == 10
                                      ? SonomaneColor.primary
                                      : Theme.of(context).colorScheme.outline,
                                  title: 'Out Stock'),
                              CustomTab(
                                color: tabIndex == 11
                                    ? SonomaneColor.primary
                                    : Colors.transparent,
                                colorBorder: tabIndex == 11
                                    ? SonomaneColor.primary
                                    : Theme.of(context).colorScheme.outline,
                                title: 'POS Report',
                              ),
                              CustomTab(
                                color: tabIndex == 12
                                    ? SonomaneColor.primary
                                    : Colors.transparent,
                                colorBorder: tabIndex == 12
                                    ? SonomaneColor.primary
                                    : Theme.of(context).colorScheme.outline,
                                title: 'Stock Opname',
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
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Summary Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SummaryReportOverall(
                                                        data: data,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SummaryReportCancelBill(
                                                        data: data,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          SummaryReportVoidPayment(
                                                            data: data,
                                                          ),
                                                          SizedBox(
                                                            height: 15.h,
                                                          ),
                                                          SummaryReportMenuCancel(
                                                            data: data,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Bill Summary",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportBillTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Sales By Type",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportSalesByTypeTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Sales By Category",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportCategoryTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Sales By Sub Category",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportSubCategoryTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Sales By Period",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportPeriodeTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Sales By Promo By Menu",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportPromoTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10.w),
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
                                                  border: Border.all(
                                                      width: 0.6.w,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60.h,
                                                      width: double.infinity,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      child: Center(
                                                        child: Text(
                                                          "Payment Type Summary",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    SummaryReportPaymentTable(
                                                        transaction: data),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Sales Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    _selectedButton == "Today"
                                                        ? 0
                                                        : data.isEmpty
                                                            ? 0
                                                            : 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: _selectedButton ==
                                                        "Today"
                                                    ? 0
                                                    : data.isEmpty
                                                        ? 0
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                child: SalesChart(
                                                  type: _selectedButton,
                                                  transactions: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: _selectedButton ==
                                                        "Today"
                                                    ? TableSalesReportToday(
                                                        data: data
                                                            .where((element) =>
                                                                element[
                                                                    "transaction_status"] ==
                                                                "sukses")
                                                            .toList(),
                                                      )
                                                    : TableSalesReport(
                                                        data: data,
                                                        lengthRow: _lengthRow,
                                                        type: _selectedButton,
                                                      ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TableSalesGrandTotal(
                                                  data: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Menu Sales Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    data.isNotEmpty ? 30.h : 0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: data.isNotEmpty
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3
                                                      : 0,
                                                  child: MenuSalesChart(
                                                    transactions: data,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TableMenuSalesReport(
                                                  data: data,
                                                  lengthRow: _lengthRow,
                                                  type: _selectedButton,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child:
                                                      TableMenuSalesGrandTotal(
                                                    data: data,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                // ScrollConfiguration(
                                //   behavior: NoGlow(),
                                //   child: SingleChildScrollView(
                                //     child: FutureBuilder(
                                //         future: _fetchData(),
                                //         builder:
                                //             (context, AsyncSnapshot snapshot) {
                                //           if (snapshot.hasError) {
                                //             return Center(
                                //               child: Text(
                                //                 "Error Database",
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .titleMedium,
                                //               ),
                                //             );
                                //           } else if (snapshot.connectionState ==
                                //               ConnectionState.waiting) {
                                //             return SizedBox(
                                //               height: 500.h,
                                //               child: Center(
                                //                 child: SizedBox(
                                //                   height: 45.h,
                                //                   width: 45.h,
                                //                   child:
                                //                       CircularProgressIndicator(
                                //                           color: SonomaneColor
                                //                               .primary),
                                //                 ),
                                //               ),
                                //             );
                                //           }
                                //           List<Map<String, dynamic>> data = [];

                                //           snapshot.data.docs.map((value) {
                                //             Map<String, dynamic> doc =
                                //                 value.data();
                                //             doc['idDoc'] = value.id;
                                //             data.add(doc);
                                //           }).toList();
                                //           return Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               SizedBox(
                                //                 height: 10.h,
                                //               ),
                                //               Padding(
                                //                 padding: EdgeInsets.symmetric(
                                //                     horizontal: 10.0.w),
                                //                 child: Align(
                                //                   alignment:
                                //                       Alignment.centerLeft,
                                //                   child: Text(
                                //                     "Menu Sales Daily Report Sonomane",
                                //                     style: Theme.of(context)
                                //                         .textTheme
                                //                         .headlineLarge,
                                //                   ),
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 10.h,
                                //               ),
                                //               Padding(
                                //                 padding: EdgeInsets.symmetric(
                                //                     horizontal: 10.0.w),
                                //                 child: Align(
                                //                   alignment:
                                //                       Alignment.centerLeft,
                                //                   child: Text(
                                //                     "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                //                     style: Theme.of(context)
                                //                         .textTheme
                                //                         .titleMedium,
                                //                   ),
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 10.h,
                                //               ),
                                //               Padding(
                                //                 padding: EdgeInsets.symmetric(
                                //                     horizontal: 10.0.w),
                                //                 child: Align(
                                //                   alignment:
                                //                       Alignment.centerLeft,
                                //                   child: _selectedButton ==
                                //                           "This Week"
                                //                       ? Text(
                                //                           "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                //                           style:
                                //                               Theme.of(context)
                                //                                   .textTheme
                                //                                   .titleMedium,
                                //                         )
                                //                       : _selectedButton ==
                                //                               "This Month"
                                //                           ? Text(
                                //                               "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                //                               style: Theme.of(
                                //                                       context)
                                //                                   .textTheme
                                //                                   .titleMedium,
                                //                             )
                                //                           : _selectedButton ==
                                //                                   "Last Month"
                                //                               ? Text(
                                //                                   "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                //                                   style: Theme.of(
                                //                                           context)
                                //                                       .textTheme
                                //                                       .titleMedium,
                                //                                 )
                                //                               : _selectedButton ==
                                //                                       "This Year"
                                //                                   ? Text(
                                //                                       "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                //                                       style: Theme.of(
                                //                                               context)
                                //                                           .textTheme
                                //                                           .titleMedium,
                                //                                     )
                                //                                   : Text(
                                //                                       "Periode : Today ",
                                //                                       style: Theme.of(
                                //                                               context)
                                //                                           .textTheme
                                //                                           .titleMedium,
                                //                                     ),
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 10.h,
                                //               ),
                                //               Padding(
                                //                 padding: EdgeInsets.symmetric(
                                //                     horizontal: 10.0.w),
                                //                 child: Row(
                                //                   children: [
                                //                     for (int a = 0;
                                //                         a <
                                //                             _selectedData
                                //                                 .length;
                                //                         a++) ...{
                                //                       Padding(
                                //                         padding:
                                //                             EdgeInsets.only(
                                //                                 right: 8.w),
                                //                         child: CustomButton(
                                //                             isLoading: false,
                                //                             title:
                                //                                 _selectedData[
                                //                                     a],
                                //                             onTap: () {
                                //                               setState(() {
                                //                                 _selectedButton =
                                //                                     _selectedData[
                                //                                         a];
                                //                                 if (_selectedData[
                                //                                         a] ==
                                //                                     "This Week") {
                                //                                   _lengthRow =
                                //                                       7;
                                //                                   _updateDate(
                                //                                       "This Week");
                                //                                 } else if (_selectedData[
                                //                                         a] ==
                                //                                     "This Month") {
                                //                                   _lengthRow =
                                //                                       30;
                                //                                   _updateDate(
                                //                                       "This Month");
                                //                                 } else if (_selectedData[
                                //                                         a] ==
                                //                                     "Last Month") {
                                //                                   _lengthRow =
                                //                                       30;
                                //                                   _updateDate(
                                //                                       "Last Month");
                                //                                 } else if (_selectedData[
                                //                                         a] ==
                                //                                     "This Year") {
                                //                                   _lengthRow =
                                //                                       12;
                                //                                   _updateDate(
                                //                                       "This Year");
                                //                                 } else {
                                //                                   _lengthRow =
                                //                                       10;
                                //                                   _updateDate(
                                //                                       "Today");
                                //                                 }
                                //                               });
                                //                             },
                                //                             color: _selectedButton ==
                                //                                     _selectedData[
                                //                                         a]
                                //                                 ? SonomaneColor
                                //                                     .textTitleDark
                                //                                 : SonomaneColor
                                //                                     .textTitleLight,
                                //                             bgColor: _selectedButton ==
                                //                                     _selectedData[
                                //                                         a]
                                //                                 ? SonomaneColor
                                //                                     .primary
                                //                                 : SonomaneColor
                                //                                     .textParaghrapDark),
                                //                       ),
                                //                     }
                                //                   ],
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 20.h,
                                //               ),
                                //               SizedBox(
                                //                 width: double.infinity,
                                //                 child: TableSalesDailyReport(
                                //                   transaction: data,
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 15.h,
                                //               ),
                                //             ],
                                //           );
                                //         }),
                                //   ),
                                // ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Menu Sales Category Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    data.isNotEmpty ? 30.h : 0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: data.isNotEmpty
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3
                                                      : 0,
                                                  child: MenuSalesCategoryChart(
                                                    transactions: data,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child:
                                                    TableMenuCategorySalesReport(
                                                  data: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Menu Sales Hour Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    data.isNotEmpty ? 30.h : 0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: data.isNotEmpty
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3
                                                      : 0,
                                                  child: MenuSalesHourChart(
                                                    transactions: data,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TableMenuSalesHourReport(
                                                  data: data,
                                                  lengthRow: _lengthRow,
                                                  type: _selectedButton,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Payment Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    _selectedButton == "Today"
                                                        ? 0
                                                        : data.isEmpty
                                                            ? 0
                                                            : 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: _selectedButton ==
                                                        "Today"
                                                    ? 0
                                                    : data.isEmpty
                                                        ? 0
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                child: PaymentChart(
                                                  type: _selectedButton,
                                                  transactions: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: _selectedButton ==
                                                        "Today"
                                                    ? TablePaymentReportToday(
                                                        data: data
                                                            .where((element) =>
                                                                element[
                                                                    "transaction_status"] ==
                                                                "gagal")
                                                            .toList())
                                                    : TablePaymentReport(
                                                        data: data
                                                            .where((element) =>
                                                                element[
                                                                    "transaction_status"] ==
                                                                "gagal")
                                                            .toList(),
                                                        lengthRow: _lengthRow,
                                                        type: _selectedButton,
                                                      ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: TablePercentagePayment(
                                                    data: data,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Menu Cancel Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: data
                                                        .where((element) =>
                                                            element[
                                                                "transaction_status"] ==
                                                            "gagal")
                                                        .toList()
                                                        .isNotEmpty
                                                    ? 30.h
                                                    : 0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: data
                                                          .where((element) =>
                                                              element[
                                                                  "transaction_status"] ==
                                                              "gagal")
                                                          .toList()
                                                          .isNotEmpty
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3
                                                      : 0,
                                                  child: MenuCancelSalesChart(
                                                    transactions: data
                                                        .where((element) =>
                                                            element[
                                                                "transaction_status"] ==
                                                            "gagal")
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: TableMenuCancelReport(
                                                    transaction: data
                                                        .where((element) =>
                                                            element[
                                                                "transaction_status"] ==
                                                            "gagal")
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
                                              ),
                                            );
                                          }
                                          List<Map<String, dynamic>> data = [];

                                          snapshot.data.docs.map((value) {
                                            Map<String, dynamic> doc =
                                                value.data();
                                            doc['idDoc'] = value.id;
                                            data.add(doc);
                                          }).toList();
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Waiter Report Sonomane",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    data.isNotEmpty ? 30.h : 0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: data.isNotEmpty
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3
                                                      : 0,
                                                  child: WaiterChart(
                                                    transactions: data,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),

                                              // SizedBox(
                                              //   height:
                                              //       data.isNotEmpty ? 30.h : 0,
                                              // ),
                                              // Padding(
                                              //   padding: EdgeInsets.only(
                                              //       left: 5.0.w),
                                              //   child: SizedBox(
                                              //     width: double.infinity,
                                              //     height: data.isNotEmpty
                                              //         ? MediaQuery.of(context)
                                              //                 .size
                                              //                 .height *
                                              //             0.3
                                              //         : 0,
                                              //     child:
                                              //         SalesReportComparisonChart(
                                              //       transactions: data,
                                              //       type: _selectedButton,
                                              //     ),
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   height: 30.h,
                                              // ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Waiter Order",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child:
                                                            TableWaiterOrderReport(
                                                          type: _selectedButton,
                                                          transaction: data,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                      Text(
                                                        "Waiter Cancel",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child:
                                                            TableWaiterCancelReport(
                                                          transaction: data,
                                                          type: _selectedButton,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchData(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Sales Comparision",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _selectedButton ==
                                                          "This Week"
                                                      ? Text(
                                                          "Periode : ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        )
                                                      : _selectedButton ==
                                                              "This Month"
                                                          ? Text(
                                                              "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            )
                                                          : _selectedButton ==
                                                                  "Last Month"
                                                              ? Text(
                                                                  "Periode : ${DateFormat('MMMM yyyy').format(_startDate!)} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                )
                                                              : _selectedButton ==
                                                                      "This Year"
                                                                  ? Text(
                                                                      "Periode : ${DateFormat('yyyy').format(_startDate!)} ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    )
                                                                  : Text(
                                                                      "Periode : Today ",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    for (int a = 0;
                                                        a <
                                                            _selectedData
                                                                .length;
                                                        a++) ...{
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: CustomButton(
                                                            isLoading: false,
                                                            title:
                                                                _selectedData[
                                                                    a],
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedButton =
                                                                    _selectedData[
                                                                        a];
                                                                if (_selectedData[
                                                                        a] ==
                                                                    "This Week") {
                                                                  _lengthRow =
                                                                      7;
                                                                  _updateDate(
                                                                      "This Week");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "This Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "Last Month") {
                                                                  _lengthRow =
                                                                      30;
                                                                  _updateDate(
                                                                      "Last Month");
                                                                } else if (_selectedData[
                                                                        a] ==
                                                                    "This Year") {
                                                                  _lengthRow =
                                                                      12;
                                                                  _updateDate(
                                                                      "This Year");
                                                                } else {
                                                                  _lengthRow =
                                                                      10;
                                                                  _updateDate(
                                                                      "Today");
                                                                }
                                                              });
                                                            },
                                                            color: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .textTitleDark
                                                                : SonomaneColor
                                                                    .textTitleLight,
                                                            bgColor: _selectedButton ==
                                                                    _selectedData[
                                                                        a]
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: data.isNotEmpty
                                                      ? 30.h
                                                      : 0),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: data.isNotEmpty
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3
                                                      : 0,
                                                  child:
                                                      SalesReportComparisonChart(
                                                    transactions: data,
                                                    type: _selectedButton,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Table : Sales",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child:
                                                            TableSalesComparisonReport(
                                                          type: _selectedButton,
                                                          transaction: data,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                      Text(
                                                        "Table : Menu Sales",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child:
                                                            TableMenuSalesComparisonReport(
                                                          transaction: data,
                                                          type: _selectedButton,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                //add
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: _fetchDataInventory("in", null),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Stock IN",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    SizedBox(
                                                      width: 360.w,
                                                      height: 51.h,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                DropdownButtonFormField<
                                                                    int>(
                                                              value:
                                                                  selectedMonth,
                                                              dropdownColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .background,
                                                              iconEnabledColor:
                                                                  SonomaneColor
                                                                      .primary,
                                                              icon: Icon(
                                                                Icons
                                                                    .expand_circle_down_rounded,
                                                                size: 28.sp,
                                                              ),
                                                              items: months
                                                                  .map((month) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: month[
                                                                      'value'],
                                                                  child: Text(
                                                                      month[
                                                                          'name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (int?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedMonth =
                                                                      newValue!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomDropdownNoTitle(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedYear =
                                                                    int.parse(
                                                                        value);
                                                              });
                                                            },
                                                            hintText:
                                                                selectedYear
                                                                    .toString(),
                                                            data: years,
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomButton(
                                                              isLoading: false,
                                                              title: "Generate",
                                                              onTap: () {
                                                                _startDateInv =
                                                                    DateTime(
                                                                        selectedYear,
                                                                        selectedMonth,
                                                                        1);

                                                                _endDateInv = DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0);
                                                                setState(() {});
                                                              },
                                                              color: SonomaneColor
                                                                  .textTitleDark,
                                                              bgColor:
                                                                  SonomaneColor
                                                                      .primary)
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    ExcelButton(
                                                      onTap: () async {
                                                        int lastDayOfMonth =
                                                            DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0)
                                                                .day;
                                                        final status =
                                                            await Permission
                                                                .storage.status;
                                                        if (status ==
                                                            PermissionStatus
                                                                .granted) {
                                                          ApiBaseHelper api =
                                                              ApiBaseHelper();
                                                          const url =
                                                              '$baseUrl/in-item';
                                                          Map data = {
                                                            "firstFilter":
                                                                "$selectedYear-$selectedMonth-01",
                                                            "lastFilter":
                                                                "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                          };
                                                          final response =
                                                              // ignore: use_build_context_synchronously
                                                              await api.post(
                                                                  url,
                                                                  data,
                                                                  context);
                                                          List<int> bytes =
                                                              response
                                                                  .bodyBytes;

                                                          final result =
                                                              await FilePicker
                                                                  .platform
                                                                  .getDirectoryPath();
                                                          if (result != null) {
                                                            final directory =
                                                                Directory(
                                                                    result);
                                                            final path =
                                                                '${directory.path}/StokMasuk${DateTime.now().millisecondsSinceEpoch}.xlsx';

                                                            final file =
                                                                File(path);
                                                            await file
                                                                .writeAsBytes(
                                                                    bytes);
                                                            // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                          }
                                                          // ignore: use_build_context_synchronously
                                                          CustomToast.successToast(
                                                              context,
                                                              "Report berhasil disimpan");
                                                        } else {
                                                          final result =
                                                              await Permission
                                                                  .storage
                                                                  .request();
                                                          if (result ==
                                                              PermissionStatus
                                                                  .granted) {
                                                            ApiBaseHelper api =
                                                                ApiBaseHelper();
                                                            const url =
                                                                '$baseUrl/in-item';
                                                            Map data = {
                                                              "firstFilter":
                                                                  "$selectedYear-$selectedMonth-01",
                                                              "lastFilter":
                                                                  "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                            };
                                                            final response =
                                                                // ignore: use_build_context_synchronously
                                                                await api.post(
                                                                    url,
                                                                    data,
                                                                    context);
                                                            List<int> bytes =
                                                                response
                                                                    .bodyBytes;

                                                            final result =
                                                                await FilePicker
                                                                    .platform
                                                                    .getDirectoryPath();
                                                            if (result !=
                                                                null) {
                                                              final directory =
                                                                  Directory(
                                                                      result);
                                                              final path =
                                                                  '${directory.path}/StokMasuk${DateTime.now().millisecondsSinceEpoch}.xlsx';
                                                              final file =
                                                                  File(path);
                                                              await file
                                                                  .writeAsBytes(
                                                                      bytes);
                                                              // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                            }
                                                            // ignore: use_build_context_synchronously
                                                            CustomToast
                                                                .successToast(
                                                                    context,
                                                                    "Report berhasil disimpan");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 30.h),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TableStockIN(
                                                  data: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future:
                                            _fetchDataInventory("out", null),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Stock OUT",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    SizedBox(
                                                      width: 360.w,
                                                      height: 51.h,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                DropdownButtonFormField<
                                                                    int>(
                                                              value:
                                                                  selectedMonth,
                                                              dropdownColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .background,
                                                              iconEnabledColor:
                                                                  SonomaneColor
                                                                      .primary,
                                                              icon: Icon(
                                                                Icons
                                                                    .expand_circle_down_rounded,
                                                                size: 28.sp,
                                                              ),
                                                              items: months
                                                                  .map((month) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: month[
                                                                      'value'],
                                                                  child: Text(
                                                                      month[
                                                                          'name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (int?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedMonth =
                                                                      newValue!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomDropdownNoTitle(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedYear =
                                                                    int.parse(
                                                                        value);
                                                              });
                                                            },
                                                            hintText:
                                                                selectedYear
                                                                    .toString(),
                                                            data: years,
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomButton(
                                                              isLoading: false,
                                                              title: "Generate",
                                                              onTap: () {
                                                                _startDateInv =
                                                                    DateTime(
                                                                        selectedYear,
                                                                        selectedMonth,
                                                                        1);

                                                                _endDateInv = DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0);
                                                                setState(() {});
                                                              },
                                                              color: SonomaneColor
                                                                  .textTitleDark,
                                                              bgColor:
                                                                  SonomaneColor
                                                                      .primary)
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    ExcelButton(
                                                      onTap: () async {
                                                        int lastDayOfMonth =
                                                            DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0)
                                                                .day;
                                                        final status =
                                                            await Permission
                                                                .storage.status;
                                                        if (status ==
                                                            PermissionStatus
                                                                .granted) {
                                                          ApiBaseHelper api =
                                                              ApiBaseHelper();
                                                          const url =
                                                              '$baseUrl/out-item';
                                                          Map data = {
                                                            "firstFilter":
                                                                "$selectedYear-$selectedMonth-01",
                                                            "lastFilter":
                                                                "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                          };
                                                          final response =
                                                              // ignore: use_build_context_synchronously
                                                              await api.post(
                                                                  url,
                                                                  data,
                                                                  context);
                                                          List<int> bytes =
                                                              response
                                                                  .bodyBytes;

                                                          final result =
                                                              await FilePicker
                                                                  .platform
                                                                  .getDirectoryPath();
                                                          if (result != null) {
                                                            final directory =
                                                                Directory(
                                                                    result);
                                                            final path =
                                                                '${directory.path}/StokKeluar${DateTime.now().millisecondsSinceEpoch}.xlsx';

                                                            final file =
                                                                File(path);
                                                            await file
                                                                .writeAsBytes(
                                                                    bytes);
                                                            // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                          }
                                                          // ignore: use_build_context_synchronously
                                                          CustomToast.successToast(
                                                              context,
                                                              "Report berhasil disimpan");
                                                        } else {
                                                          final result =
                                                              await Permission
                                                                  .storage
                                                                  .request();
                                                          if (result ==
                                                              PermissionStatus
                                                                  .granted) {
                                                            ApiBaseHelper api =
                                                                ApiBaseHelper();
                                                            const url =
                                                                '$baseUrl/out-item';
                                                            Map data = {
                                                              "firstFilter":
                                                                  "$selectedYear-$selectedMonth-01",
                                                              "lastFilter":
                                                                  "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                            };
                                                            final response =
                                                                // ignore: use_build_context_synchronously
                                                                await api.post(
                                                                    url,
                                                                    data,
                                                                    context);
                                                            List<int> bytes =
                                                                response
                                                                    .bodyBytes;

                                                            final result =
                                                                await FilePicker
                                                                    .platform
                                                                    .getDirectoryPath();
                                                            if (result !=
                                                                null) {
                                                              final directory =
                                                                  Directory(
                                                                      result);
                                                              final path =
                                                                  '${directory.path}/StokKeluar${DateTime.now().millisecondsSinceEpoch}.xlsx';
                                                              final file =
                                                                  File(path);
                                                              await file
                                                                  .writeAsBytes(
                                                                      bytes);
                                                              // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                            }
                                                            // ignore: use_build_context_synchronously
                                                            CustomToast
                                                                .successToast(
                                                                    context,
                                                                    "Report berhasil disimpan");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 30.h),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TableStockOUT(
                                                  data: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future:
                                            _fetchDataInventory("out", true),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Pemakaian POS",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    SizedBox(
                                                      width: 360.w,
                                                      height: 51.h,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                DropdownButtonFormField<
                                                                    int>(
                                                              value:
                                                                  selectedMonth,
                                                              dropdownColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .background,
                                                              iconEnabledColor:
                                                                  SonomaneColor
                                                                      .primary,
                                                              icon: Icon(
                                                                Icons
                                                                    .expand_circle_down_rounded,
                                                                size: 28.sp,
                                                              ),
                                                              items: months
                                                                  .map((month) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: month[
                                                                      'value'],
                                                                  child: Text(
                                                                      month[
                                                                          'name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (int?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedMonth =
                                                                      newValue!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomDropdownNoTitle(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedYear =
                                                                    int.parse(
                                                                        value);
                                                              });
                                                            },
                                                            hintText:
                                                                selectedYear
                                                                    .toString(),
                                                            data: years,
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomButton(
                                                              isLoading: false,
                                                              title: "Generate",
                                                              onTap: () {
                                                                _startDateInv =
                                                                    DateTime(
                                                                        selectedYear,
                                                                        selectedMonth,
                                                                        1);

                                                                _endDateInv = DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0);
                                                                setState(() {});
                                                              },
                                                              color: SonomaneColor
                                                                  .textTitleDark,
                                                              bgColor:
                                                                  SonomaneColor
                                                                      .primary)
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    ExcelButton(
                                                      onTap: () async {
                                                        int lastDayOfMonth =
                                                            DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0)
                                                                .day;
                                                        final status =
                                                            await Permission
                                                                .storage.status;
                                                        if (status ==
                                                            PermissionStatus
                                                                .granted) {
                                                          ApiBaseHelper api =
                                                              ApiBaseHelper();
                                                          const url =
                                                              '$baseUrl/laporan-pos';
                                                          Map data = {
                                                            "firstFilter":
                                                                "$selectedYear-$selectedMonth-01",
                                                            "lastFilter":
                                                                "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                          };
                                                          final response =
                                                              // ignore: use_build_context_synchronously
                                                              await api.post(
                                                                  url,
                                                                  data,
                                                                  context);
                                                          List<int> bytes =
                                                              response
                                                                  .bodyBytes;

                                                          final result =
                                                              await FilePicker
                                                                  .platform
                                                                  .getDirectoryPath();
                                                          if (result != null) {
                                                            final directory =
                                                                Directory(
                                                                    result);
                                                            final path =
                                                                '${directory.path}/PemakaianPOS${DateTime.now().millisecondsSinceEpoch}.xlsx';

                                                            final file =
                                                                File(path);
                                                            await file
                                                                .writeAsBytes(
                                                                    bytes);
                                                            // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                          }
                                                          // ignore: use_build_context_synchronously
                                                          CustomToast.successToast(
                                                              context,
                                                              "Report berhasil disimpan");
                                                        } else {
                                                          final result =
                                                              await Permission
                                                                  .storage
                                                                  .request();
                                                          if (result ==
                                                              PermissionStatus
                                                                  .granted) {
                                                            ApiBaseHelper api =
                                                                ApiBaseHelper();
                                                            const url =
                                                                '$baseUrl/laporan-pos';
                                                            Map data = {
                                                              "firstFilter":
                                                                  "$selectedYear-$selectedMonth-01",
                                                              "lastFilter":
                                                                  "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                            };
                                                            final response =
                                                                // ignore: use_build_context_synchronously
                                                                await api.post(
                                                                    url,
                                                                    data,
                                                                    context);
                                                            List<int> bytes =
                                                                response
                                                                    .bodyBytes;

                                                            final result =
                                                                await FilePicker
                                                                    .platform
                                                                    .getDirectoryPath();
                                                            if (result !=
                                                                null) {
                                                              final directory =
                                                                  Directory(
                                                                      result);
                                                              final path =
                                                                  '${directory.path}/PemakaianPOS${DateTime.now().millisecondsSinceEpoch}.xlsx';
                                                              final file =
                                                                  File(path);
                                                              await file
                                                                  .writeAsBytes(
                                                                      bytes);
                                                              // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                            }
                                                            // ignore: use_build_context_synchronously
                                                            CustomToast
                                                                .successToast(
                                                                    context,
                                                                    "Report berhasil disimpan");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 30.h),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TablePemakaianPos(
                                                  data: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                                ScrollConfiguration(
                                  behavior: NoGlow(),
                                  child: SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("stocks")
                                            .orderBy("itemName",
                                                descending: false)
                                            .get(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
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
                                            return SizedBox(
                                              height: 500.h,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: SonomaneColor
                                                              .primary),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Text(
                                                  "Stock",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Generate date : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w),
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    SizedBox(
                                                      width: 360.w,
                                                      height: 51.h,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                DropdownButtonFormField<
                                                                    int>(
                                                              value:
                                                                  selectedMonth,
                                                              dropdownColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .background,
                                                              iconEnabledColor:
                                                                  SonomaneColor
                                                                      .primary,
                                                              icon: Icon(
                                                                Icons
                                                                    .expand_circle_down_rounded,
                                                                size: 28.sp,
                                                              ),
                                                              items: months
                                                                  .map((month) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: month[
                                                                      'value'],
                                                                  child: Text(
                                                                      month[
                                                                          'name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (int?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedMonth =
                                                                      newValue!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomDropdownNoTitle(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedYear =
                                                                    int.parse(
                                                                        value);
                                                              });
                                                            },
                                                            hintText:
                                                                selectedYear
                                                                    .toString(),
                                                            data: years,
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          CustomButton(
                                                              isLoading: false,
                                                              title: "Generate",
                                                              onTap: () {
                                                                _startDateInv =
                                                                    DateTime(
                                                                        selectedYear,
                                                                        selectedMonth,
                                                                        1);

                                                                _endDateInv = DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0);
                                                                setState(() {});
                                                              },
                                                              color: SonomaneColor
                                                                  .textTitleDark,
                                                              bgColor:
                                                                  SonomaneColor
                                                                      .primary)
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    ExcelButton(
                                                      onTap: () async {
                                                        int lastDayOfMonth =
                                                            DateTime(
                                                                    selectedYear,
                                                                    selectedMonth +
                                                                        1,
                                                                    0)
                                                                .day;
                                                        final status =
                                                            await Permission
                                                                .storage.status;
                                                        if (status ==
                                                            PermissionStatus
                                                                .granted) {
                                                          ApiBaseHelper api =
                                                              ApiBaseHelper();
                                                          const url =
                                                              '$baseUrl/stock-opname';
                                                          Map data = {
                                                            "firstFilter":
                                                                "$selectedYear-$selectedMonth-01",
                                                            "lastFilter":
                                                                "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                          };
                                                          final response =
                                                              // ignore: use_build_context_synchronously
                                                              await api.post(
                                                                  url,
                                                                  data,
                                                                  context);
                                                          List<int> bytes =
                                                              response
                                                                  .bodyBytes;

                                                          final result =
                                                              await FilePicker
                                                                  .platform
                                                                  .getDirectoryPath();
                                                          if (result != null) {
                                                            final directory =
                                                                Directory(
                                                                    result);
                                                            final path =
                                                                '${directory.path}/StokOpname${DateTime.now().millisecondsSinceEpoch}.xlsx';

                                                            final file =
                                                                File(path);
                                                            await file
                                                                .writeAsBytes(
                                                                    bytes);
                                                            // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                          }
                                                          // ignore: use_build_context_synchronously
                                                          CustomToast.successToast(
                                                              context,
                                                              "Report berhasil disimpan");
                                                        } else {
                                                          final result =
                                                              await Permission
                                                                  .storage
                                                                  .request();
                                                          if (result ==
                                                              PermissionStatus
                                                                  .granted) {
                                                            ApiBaseHelper api =
                                                                ApiBaseHelper();
                                                            const url =
                                                                '$baseUrl/stock-opname';
                                                            Map data = {
                                                              "firstFilter":
                                                                  "$selectedYear-$selectedMonth-01",
                                                              "lastFilter":
                                                                  "$selectedYear-$selectedMonth-$lastDayOfMonth",
                                                            };
                                                            final response =
                                                                // ignore: use_build_context_synchronously
                                                                await api.post(
                                                                    url,
                                                                    data,
                                                                    context);
                                                            List<int> bytes =
                                                                response
                                                                    .bodyBytes;

                                                            final result =
                                                                await FilePicker
                                                                    .platform
                                                                    .getDirectoryPath();
                                                            if (result !=
                                                                null) {
                                                              final directory =
                                                                  Directory(
                                                                      result);
                                                              final path =
                                                                  '${directory.path}/StokOpname${DateTime.now().millisecondsSinceEpoch}.xlsx';
                                                              final file =
                                                                  File(path);
                                                              await file
                                                                  .writeAsBytes(
                                                                      bytes);
                                                              // Lakukan sesuatu dengan file Excel, seperti membukanya atau menyimpannya ke galeri
                                                            }
                                                            // ignore: use_build_context_synchronously
                                                            CustomToast
                                                                .successToast(
                                                                    context,
                                                                    "Report berhasil disimpan");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 30.h),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TableStockOpname(
                                                  data: data,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
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

// ignore: must_be_immutable
class ExcelButton extends StatelessWidget {
  void Function()? onTap;
  ExcelButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 51.h,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: SonomaneColor.primary),
            borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          children: [
            Text(
              "Excel",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
            SizedBox(width: 10.w),
            Image.network(
                width: 28.w,
                "https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Microsoft_Office_Excel_%282019%E2%80%93present%29.svg/768px-Microsoft_Office_Excel_%282019%E2%80%93present%29.svg.png"),
          ],
        ),
      ),
    );
  }
}
