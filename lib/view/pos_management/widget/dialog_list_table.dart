import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/helper/get_data_order.dart';
import 'package:sonomaneoutlet/model/table/table_model.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/custom_button_icon.dart';
import 'package:sonomaneoutlet/shared_widget/outline_custom_button.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/card_table.dart';

class TableList extends StatefulWidget {
  final TextEditingController textEditingController;
  const TableList({super.key, required this.textEditingController});

  @override
  State<TableList> createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  // variable meja
  List<String> tablelist = [];
  List<int> selectedIndex = [];
  Stream? _listTable;

  @override
  void initState() {
    super.initState();
    _listTable = TableModelFunction().getTable();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      content: StreamBuilder(
          stream: _listTable,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error database",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 50.h,
                width: 50.h,
                child: Center(
                  child: CircularProgressIndicator(
                    color: SonomaneColor.primary,
                  ),
                ),
              );
            } else if (snapshot.data.docs.isNotEmpty) {
              List dataTable = [];

              snapshot.data.docs.map((e) {
                Map a = e.data();
                a['idDoc'] = e.id;
                dataTable.add(a);
              }).toList();
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.h, horizontal: 20.0.w),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width < 800
                          ? (MediaQuery.of(context).size.width * 0.45).w
                          : (MediaQuery.of(context).size.width * 0.6).w,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 15,
                                runSpacing: 15,
                                children: [
                                  for (var i = 0;
                                      i < dataTable.length;
                                      i++) ...[
                                    GestureDetector(
                                      onTap: () async {
                                        List order =
                                            await GetDataOrder.getDataOrder(
                                                dataTable[i]['tablenumber']);

                                        if (order.isEmpty) {
                                          setState(() {
                                            if (selectedIndex.isNotEmpty ||
                                                tablelist.isNotEmpty) {
                                              selectedIndex.clear();
                                              tablelist.clear();
                                              tablelist.add(
                                                  dataTable[i]['tablenumber']);
                                              selectedIndex.add(i);
                                            } else {
                                              tablelist.add(
                                                  dataTable[i]['tablenumber']);
                                              selectedIndex.add(i);
                                            }
                                          });
                                        } else {
                                          null;
                                        }
                                      },
                                      child: CustomCardTable(
                                        tableMax: dataTable[i]
                                            ['maximumcapacity'],
                                        tableNumber: dataTable[i]
                                            ['tablenumber'],
                                        selectedIndex: selectedIndex,
                                        index: i,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonIcon(
                                    isLoading: false,
                                    title: "Dipilih",
                                    onTap: () {},
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    bgColor: Colors.transparent,
                                    icon: Icon(Icons.circle,
                                        size: 15.sp,
                                        color: SonomaneColor.primary),
                                  ),
                                  CustomButtonIcon(
                                    isLoading: false,
                                    title: "Tersedia",
                                    onTap: () {},
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    bgColor: Colors.transparent,
                                    icon: Icon(Icons.circle,
                                        size: 15.sp,
                                        color: SonomaneColor.textParaghrapDark),
                                  ),
                                  CustomButtonIcon(
                                    isLoading: false,
                                    title: "Tidak Tersedia",
                                    onTap: () {},
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    bgColor: Colors.transparent,
                                    icon: Icon(Icons.circle,
                                        size: 15.sp,
                                        color: SonomaneColor.textTitleLight
                                            .withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 900),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 110.w,
                                    height: 50.h,
                                    child: OutlinedCustomButton(
                                        isLoading: false,
                                        color: SonomaneColor.primary,
                                        bgColor: SonomaneColor.primary,
                                        onTap: () {
                                          tablelist.clear();
                                          selectedIndex.clear();
                                          Navigator.of(context).pop();
                                        },
                                        title: 'Batal'),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  SizedBox(
                                    width: 110.w,
                                    height: 50.h,
                                    child: CustomButton(
                                      isLoading: false,
                                      title: "Ok",
                                      onTap: () {
                                        setState(() {
                                          widget.textEditingController.text =
                                              tablelist.join(",");
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      color: SonomaneColor.textTitleDark,
                                      bgColor: SonomaneColor.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 3.0.w,
                    top: 3.0.h,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  "Tidak ada meja",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              );
            }
          }),
    );
  }
}
