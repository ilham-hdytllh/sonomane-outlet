import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/view/order_payment/pages/combine_bill.dart/combine_order.dart';
import 'package:sonomaneoutlet/view/order_payment/pages/combine_table/combine_table.dart';
import 'package:sonomaneoutlet/view/order_payment/widget/table_card.dart';

class AvailableTable extends StatefulWidget {
  const AvailableTable({super.key});

  @override
  State<AvailableTable> createState() => _AvailableTableState();
}

class _AvailableTableState extends State<AvailableTable> {
  bool _refresh = false;

  void _refreshParentState() {
    setState(() {
      _refresh = !_refresh;
    });
  }

  Stream? availableMejaA;
  Stream? availableMejaB;

  String combineOrderORTable = "order";
  List<String> tableSelected = [];

  @override
  void initState() {
    super.initState();
    availableMejaA = FirebaseFirestore.instance
        .collection('tables')
        .where('tablelocation', isEqualTo: 'A')
        .snapshots();
    availableMejaB = FirebaseFirestore.instance
        .collection('tables')
        .where('tablelocation', isEqualTo: 'B')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGloww(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 51.h,
                child: CustomButton(
                    title: "Combine Bill",
                    onTap: () {
                      setState(() {
                        combineOrderORTable = "order";
                        tableSelected.clear();
                      });
                    },
                    isLoading: false,
                    color: combineOrderORTable == "order"
                        ? SonomaneColor.textTitleDark
                        : SonomaneColor.textTitleLight,
                    bgColor: combineOrderORTable == "order"
                        ? SonomaneColor.primary
                        : SonomaneColor.textParaghrapDark),
              ),
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                width: 120.w,
                height: 51.h,
                child: CustomButton(
                    title: "Combine Table",
                    onTap: () {
                      setState(() {
                        combineOrderORTable = "table";
                      });
                    },
                    isLoading: false,
                    color: combineOrderORTable == "table"
                        ? SonomaneColor.textTitleDark
                        : SonomaneColor.textTitleLight,
                    bgColor: combineOrderORTable == "table"
                        ? SonomaneColor.primary
                        : SonomaneColor.textParaghrapDark),
              ),
              const Spacer(),
              tableSelected.isNotEmpty && combineOrderORTable == "table"
                  ? SizedBox(
                      width: 120.w,
                      height: 51.h,
                      child: CustomButton(
                          title: "Combine Table",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CombineTable(
                                  refresh: _refreshParentState,
                                  daftarmeja: tableSelected,
                                ),
                              ),
                            );
                          },
                          isLoading: false,
                          color: SonomaneColor.textTitleDark,
                          bgColor: SonomaneColor.primary),
                    )
                  : const SizedBox(),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Meja Restaurant',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  StreamBuilder(
                      stream: availableMejaA,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'something when eror',
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 300,
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  color: SonomaneColor.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        final List tablesDocs = [];
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          tablesDocs.add(a);
                          a['id'] = document.id;
                        }).toList();

                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (var i = 0; i < tablesDocs.length; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  if (combineOrderORTable == "order") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CombineOrder(
                                          refresh: _refreshParentState,
                                          meja: tablesDocs[i]['tablenumber'],
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (tableSelected.contains(
                                            tablesDocs[i]['tablenumber']) ==
                                        true) {
                                      tableSelected
                                          .remove(tablesDocs[i]['tablenumber']);
                                      setState(() {});
                                    } else {
                                      setState(() {
                                        tableSelected
                                            .add(tablesDocs[i]['tablenumber']);
                                      });
                                    }
                                  }
                                },
                                child: TableCard(
                                    isSelected: tableSelected
                                        .contains(tablesDocs[i]['tablenumber']),
                                    max: tablesDocs[i]['maximumcapacity'],
                                    number: tablesDocs[i]['tablenumber'],
                                    ketersediaan: tablesDocs[i]
                                        ['ketersediaan']),
                              ),
                            ],
                          ],
                        );
                      }),
                  SizedBox(
                    height: 35.h,
                  ),
                  Text(
                    'Meja Bar',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  StreamBuilder(
                      stream: availableMejaB,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('something when eror');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 300,
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  color: SonomaneColor.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        final List tablesDocs = [];
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          tablesDocs.add(a);
                          a['id'] = document.id;
                        }).toList();
                        return Wrap(spacing: 10, runSpacing: 10, children: [
                          for (var i = 0; i < tablesDocs.length; i++) ...[
                            GestureDetector(
                              onTap: () {
                                if (combineOrderORTable == "order") {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CombineOrder(
                                        refresh: _refreshParentState,
                                        meja: tablesDocs[i]['tablenumber'],
                                      ),
                                    ),
                                  );
                                } else {
                                  if (tableSelected.contains(
                                          tablesDocs[i]['tablenumber']) ==
                                      true) {
                                    tableSelected
                                        .remove(tablesDocs[i]['tablenumber']);
                                    setState(() {});
                                  } else {
                                    setState(() {
                                      tableSelected
                                          .add(tablesDocs[i]['tablenumber']);
                                    });
                                  }
                                }
                              },
                              child: TableCard(
                                  isSelected: tableSelected
                                      .contains(tablesDocs[i]['tablenumber']),
                                  max: tablesDocs[i]['maximumcapacity'],
                                  number: tablesDocs[i]['tablenumber'],
                                  ketersediaan: tablesDocs[i]['ketersediaan']),
                            ),
                          ],
                        ]);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
