import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/model/customer/customer.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/customer_management/pages/customer/table_customer.dart';

class ScreenCustomerManagement extends StatefulWidget {
  const ScreenCustomerManagement({super.key});

  @override
  State<ScreenCustomerManagement> createState() =>
      _ScreenCustomerManagementState();
}

class _ScreenCustomerManagementState extends State<ScreenCustomerManagement> {
  Stream? getCustomer;

  @override
  void initState() {
    super.initState();
    getCustomer = CustomerModelFunction().getCustomer();
  }

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
                        'Customer',
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
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.1.w,
                          color: Theme.of(context).colorScheme.outline),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: StreamBuilder(
                        stream: getCustomer,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Error Database",
                                style: Theme.of(context).textTheme.titleMedium,
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
                                height: 35.h,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "List Customer",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                    // SizedBox(
                                    //   height: 45.h,
                                    //   child: ElevatedButton.icon(
                                    //     onPressed: () {
                                    //       Navigator.of(context).push(
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const AddEmploye(),
                                    //         ),
                                    //       );
                                    //     },
                                    //     style: ButtonStyle(
                                    //       backgroundColor:
                                    //           MaterialStateProperty.all(
                                    //               SonomaneColor.primary),
                                    //     ),
                                    //     label: Text(
                                    //       "Add Employe",
                                    //       style: TextStyle(
                                    //         color: SonomaneColor.containerLight,
                                    //         fontSize: 14.sp,
                                    //         fontWeight: FontWeight.w400,
                                    //       ),
                                    //     ),
                                    //     icon: Icon(
                                    //       Icons.add,
                                    //       size: 22.sp,
                                    //       color: SonomaneColor.containerLight,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ScrollConfiguration(
                                    behavior: NoGlow(),
                                    child: SingleChildScrollView(
                                      child: ListCustomer(data: data),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
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
