import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/view/kitchen_management/widget/bar_card.dart';

class BarOrder extends StatefulWidget {
  const BarOrder({super.key});

  @override
  State<BarOrder> createState() => _BarOrderState();
}

class _BarOrderState extends State<BarOrder> {
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                size: 24.sp,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Image.asset(
                        'assets/images/kitchen.png',
                        fit: BoxFit.cover,
                        width: 26,
                        height: 26,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        'Kitchen Order',
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
                        stream: FirebaseFirestore.instance
                            .collectionGroup('orders')
                            .where("order_status", isEqualTo: "Dimasak")
                            .orderBy('order_time', descending: true)
                            .snapshots(),
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
                          } else if (snapshot.data.docs.isNotEmpty) {
                            List data = [];

                            snapshot.data.docs.map((value) {
                              Map doc = value.data();
                              doc['idDoc'] = value.id;
                              data.add(doc);
                            }).toList();
                            return SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: ScrollConfiguration(
                                behavior: NoGlow(),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0.h),
                                  child: SingleChildScrollView(
                                    child: StaggeredGrid.count(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 5.w,
                                      crossAxisSpacing: 5.h,
                                      children: [
                                        for (var a = 0;
                                            a < data.length;
                                            a++) ...[
                                          BarCard(
                                            datetime: data[a]['order_time'],
                                            nameuser: data[a]['customer_name'],
                                            tableOrderId: data[a]
                                                ['tableOrder_id'],
                                            ordertype: data[a]['order_type'],
                                            orderid: data[a]['order_id'],
                                            tablenumber: data[a]
                                                ['table_number'],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Tidak ada pesanan yang ingin diantar.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            );
                          }
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
