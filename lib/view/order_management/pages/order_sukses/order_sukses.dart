import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/transaction/transaction.dart';
import 'package:sonomaneoutlet/services/session_manager.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/custom_button_icon.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField_no_title.dart';
import 'package:sonomaneoutlet/shared_widget/search.dart';
import 'package:sonomaneoutlet/view/order_management/widget/table_order.dart';

class OrderSukses extends StatefulWidget {
  const OrderSukses({super.key});

  @override
  State<OrderSukses> createState() => _OrderSuksesState();
}

class _OrderSuksesState extends State<OrderSukses> {
  final TextEditingController _search = TextEditingController();
  final TextEditingController _startDateTime = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  Stream? getTransactionSukses;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 12),
      lastDate: DateTime(2100, 12),
    );
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(DateTime.now());
      final dateTime = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
      _startDateTime.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }
  }

  Future<void> _selectDate2() async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 12),
      lastDate: DateTime(2100, 12),
    );
    if (picked2 != null) {
      final time = TimeOfDay.fromDateTime(DateTime.now());
      final dateTime = DateTime(
          picked2.year, picked2.month, picked2.day, time.hour, time.minute);
      _endDate.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }
  }

  @override
  void initState() {
    super.initState();
    getTransactionSukses = TransactionFunction().getTransactionFilter("sukses");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: ScrollConfiguration(
        behavior: NoGlow(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SizedBox(
                      child: Row(
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Image.asset(
                            'assets/svg/checklist.png',
                            fit: BoxFit.cover,
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            'Transaksi Sukses',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.1.w,
                            color: Theme.of(context).colorScheme.outline),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w, top: 15.h),
                            child: Text(
                              'Pilih Berdasarkan Tanggal',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0.w),
                                    child: CustomFormFieldNoTitle(
                                      readOnly: false,
                                      textEditingController: _startDateTime,
                                      hintText: "yyyy/mm/dd ",
                                      textInputType: TextInputType.none,
                                      onTap: () {
                                        _selectDate();
                                      },
                                      suffixIcon: Icons.calendar_month,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0.w),
                                    child: CustomFormFieldNoTitle(
                                      readOnly: false,
                                      textEditingController: _endDate,
                                      hintText: "yyyy/mm/dd ",
                                      textInputType: TextInputType.none,
                                      onTap: () {
                                        _selectDate2();
                                      },
                                      suffixIcon: Icons.calendar_month,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0.w),
                                    child: SizedBox(
                                      height: 53.h,
                                      child: CustomButton(
                                          isLoading: false,
                                          title: "Reset",
                                          onTap: () {
                                            setState(() {
                                              _endDate.clear();
                                              _startDateTime.clear();
                                            });
                                          },
                                          color: SonomaneColor.textTitleLight,
                                          bgColor: SonomaneColor.secondary),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0.w),
                                    child: SizedBox(
                                      height: 53.h,
                                      child: CustomButton(
                                          isLoading: false,
                                          title: "Tampilkan Data",
                                          onTap: () {
                                            setState(() {});
                                          },
                                          color: SonomaneColor.containerLight,
                                          bgColor: SonomaneColor.primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomSearch(
                                  controller: _search,
                                  hintText: 'Cari dengan ID Transaksi',
                                  keyboardType: TextInputType.text,
                                  readOnly: false,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                const Spacer(),
                                StreamBuilder(
                                    stream: getTransactionSukses,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return SizedBox(
                                          height: 53.h,
                                          width: 125.w,
                                          child: CustomButtonIcon(
                                            isLoading: false,
                                            title: "Report",
                                            color: SonomaneColor.textTitleDark,
                                            bgColor: SonomaneColor.primary,
                                            onTap: () {},
                                            icon: Icon(
                                              Icons.print_rounded,
                                              size: 22.sp,
                                              color:
                                                  SonomaneColor.textTitleDark,
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 53.h,
                                          width: 125.w,
                                          child: CustomButtonIcon(
                                            isLoading: false,
                                            title: "Report",
                                            color: SonomaneColor.textTitleDark,
                                            bgColor: SonomaneColor.primary,
                                            onTap: () {},
                                            icon: Icon(
                                              Icons.print_rounded,
                                              size: 22.sp,
                                              color:
                                                  SonomaneColor.textTitleDark,
                                            ),
                                          ),
                                        );
                                      }
                                      final List transaksi = [];
                                      snapshot.data!.docs.map((document) {
                                        Map a = document.data();
                                        transaksi.add(a);
                                        a['idDoc'] = document.id;
                                      }).toList();
                                      return SizedBox(
                                        height: 53.h,
                                        width: 125.w,
                                        child: CustomButtonIcon(
                                          isLoading: false,
                                          title: "Report",
                                          color: SonomaneColor.textTitleDark,
                                          bgColor: SonomaneColor.primary,
                                          onTap: () async {
                                            String? waktuLoginString =
                                                await SessionManager
                                                    .getLoginTime();

                                            print(waktuLoginString);
                                            print(transaksi
                                                .where((element) =>
                                                    DateTime.parse(element[
                                                            'transaction_time'])
                                                        .isAfter(DateTime.parse(
                                                            waktuLoginString!)))
                                                .where((element) =>
                                                    DateTime.parse(element[
                                                            'transaction_time'])
                                                        .isBefore(
                                                            DateTime.now()))
                                                .toList());
                                          },
                                          icon: Icon(
                                            Icons.print_rounded,
                                            size: 22.sp,
                                            color: SonomaneColor.textTitleDark,
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          StreamBuilder(
                              stream: (_startDateTime.text.isNotEmpty &&
                                      _endDate.text.isNotEmpty)
                                  ? FirebaseFirestore.instance
                                      .collection('transaction')
                                      .where('transaction_time',
                                          isLessThan: _endDate.text.trim())
                                      .where('transaction_time',
                                          isGreaterThan:
                                              _startDateTime.text.trim())
                                      .orderBy('transaction_time',
                                          descending: true)
                                      .snapshots()
                                  : getTransactionSukses,
                              builder: (context, snapshot) {
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
                                    width: double.infinity,
                                    height: 400.h,
                                    child: Center(
                                      child: SizedBox(
                                        height: 45.h,
                                        width: 45.h,
                                        child: CircularProgressIndicator(
                                            color: SonomaneColor.primary),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.data.docs.isEmpty) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: TableOrder(data: const []),
                                  );
                                } else {
                                  List<dynamic> filterNameData(
                                      {required List<dynamic> data,
                                      required String orderidSearchField,
                                      required String searchString}) {
                                    return data
                                        .where((element) =>
                                            element[orderidSearchField]
                                                .contains(searchString.trim()))
                                        .toList(growable: false);
                                  }

                                  final List data = [];
                                  snapshot.data!.docs.map((document) {
                                    Map a = document.data();
                                    data.add(a);
                                    a['idDoc'] = document.id;
                                  }).toList();

                                  if (_search.text.isEmpty) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: TableOrder(data: data),
                                    );
                                  } else {
                                    var datafilter = filterNameData(
                                        data: data,
                                        orderidSearchField: "transaction_id",
                                        searchString: _search.text);
                                    return SizedBox(
                                      width: double.infinity,
                                      child: TableOrder(data: datafilter),
                                    );
                                  }
                                }
                              }),
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
      ),
    );
  }
}
