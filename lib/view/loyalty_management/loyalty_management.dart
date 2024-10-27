import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/loyalty/loyalty.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';
import 'package:sonomaneoutlet/view/loyalty_management/pages/add_loyalty_level.dart';
import 'package:sonomaneoutlet/view/loyalty_management/pages/table_level_loyalty.dart';

class LoyaltyManagement extends StatefulWidget {
  const LoyaltyManagement({super.key});

  @override
  State<LoyaltyManagement> createState() => _LoyaltyManagementState();
}

class _LoyaltyManagementState extends State<LoyaltyManagement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int tabIndex = 0;
  Stream? _loyaltyLevel;
  bool _uploading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _minimumPurchase = TextEditingController();
  final TextEditingController _cashbackPercent = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loyaltyLevel = LoyaltyFunction().getLoyaltyLevel();

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Loyalty',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
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
                                    : Theme.of(context).colorScheme.outline),
                          ),
                          child: const Center(
                            child: Text(
                              'Level',
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
                                    : Theme.of(context).colorScheme.outline),
                          ),
                          child: const Center(
                            child: Text(
                              'Configure',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                    stream: _loyaltyLevel,
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
                                                  "Loyalty Level",
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
                                                              const AddLoyaltyLevel(),
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
                                                      "Add new level",
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
                                                  child: TableLoyaltyLevel(
                                                      data: data),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection("settingLoyalty")
                                        .doc("loyalty")
                                        .get(),
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

                                      var loyaltyData = snapshot.data!.data();

                                      num minimumPurchase =
                                          loyaltyData['minimumPurchase'];
                                      num cashbackPercent =
                                          loyaltyData['pointFromPurchase'];

                                      _minimumPurchase.text =
                                          minimumPurchase.toString();
                                      _cashbackPercent.text =
                                          cashbackPercent.toString();

                                      return Padding(
                                        padding: EdgeInsets.only(top: 25.h),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Flex(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                direction: Axis.horizontal,
                                                children: [
                                                  CustomFormField(
                                                    readOnly: false,
                                                    title: 'Minimum Purchase',
                                                    textEditingController:
                                                        _minimumPurchase,
                                                    hintText:
                                                        "Minimum Purchase...",
                                                    textInputType:
                                                        TextInputType.number,
                                                  ),
                                                  CustomFormField(
                                                    readOnly: false,
                                                    title: 'Cashback Percent',
                                                    textEditingController:
                                                        _cashbackPercent,
                                                    hintText:
                                                        "Cashback Percent...",
                                                    textInputType:
                                                        TextInputType.number,
                                                  ),
                                                  const Expanded(
                                                    child: SizedBox(),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 25.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 15.0.w),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      width: 135.w,
                                                      height: 50.h,
                                                      child: CustomButton(
                                                          isLoading: _uploading,
                                                          title: "Update",
                                                          onTap:
                                                              _uploading ==
                                                                      false
                                                                  ? () async {
                                                                      if (_formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        setState(
                                                                            () {
                                                                          _uploading =
                                                                              true;
                                                                        });

                                                                        DateTime?
                                                                            dateTime =
                                                                            DateTime.now();

                                                                        String
                                                                            idDocHistory =
                                                                            "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                                                        HistoryLogModel
                                                                            history =
                                                                            HistoryLogModel(
                                                                          idDoc:
                                                                              idDocHistory,
                                                                          date:
                                                                              dateTime.day,
                                                                          month:
                                                                              dateTime.month,
                                                                          year:
                                                                              dateTime.year,
                                                                          dateTime:
                                                                              DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                                                                          keterangan:
                                                                              "Mengubah setting loyalty",
                                                                          user: FirebaseAuth.instance.currentUser!.email ??
                                                                              "",
                                                                          type:
                                                                              "update",
                                                                        );

                                                                        HistoryLogModelFunction
                                                                            historyLogFunction =
                                                                            HistoryLogModelFunction(idDocHistory);

                                                                        try {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection("settingLoyalty")
                                                                              .doc("loyalty")
                                                                              .update({
                                                                            "minimumPurchase": _minimumPurchase.text.isNotEmpty
                                                                                ? num.parse(_minimumPurchase.text)
                                                                                : 0,
                                                                            "pointFromPurchase": _cashbackPercent.text.isNotEmpty
                                                                                ? num.parse(_cashbackPercent.text)
                                                                                : 0.05,
                                                                          });
                                                                          await historyLogFunction.addHistory(
                                                                              history,
                                                                              idDocHistory);
                                                                          setState(
                                                                              () {
                                                                            _uploading =
                                                                                false;
                                                                            _cashbackPercent.clear();
                                                                            _minimumPurchase.clear();
                                                                          });

                                                                          // ignore: use_build_context_synchronously
                                                                          CustomToast.successToast(
                                                                              context,
                                                                              "Berhasil mengubah mengubah setting loyalty");
                                                                        } on FirebaseException catch (_) {
                                                                          setState(
                                                                              () {
                                                                            _uploading =
                                                                                false;
                                                                            _cashbackPercent.clear();
                                                                            _minimumPurchase.clear();
                                                                          });
                                                                          // ignore: use_build_context_synchronously
                                                                          CustomToast.errorToast(
                                                                              context,
                                                                              "Gagal mengubah setting loyalty");
                                                                        }
                                                                      }
                                                                    }
                                                                  : () {},
                                                          color: SonomaneColor
                                                              .containerLight,
                                                          bgColor: SonomaneColor
                                                              .primary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
