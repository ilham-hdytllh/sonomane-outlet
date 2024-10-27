import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownSearch.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownWaiting.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';
import 'package:sonomaneoutlet/shared_widget/search_dropdown_map.dart';

// ignore: must_be_immutable
class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  bool uploading = false;

  bool uploading2 = false;

  final _formKey = GlobalKey<FormState>();

  String _place = "kitchen";

  final TextEditingController _dateCome = TextEditingController();
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _unitName = TextEditingController();
  final TextEditingController _itemCode = TextEditingController();

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1925, 01),
      lastDate: DateTime(2100, 12),
    );
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(DateTime.now());
      final dateTime = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
      _dateCome.text = DateFormat('yyyy-MM-dd HH:ss').format(dateTime);
    }
  }

  Future? getAllItem;
  Future? getAllUnit;

  @override
  void initState() {
    super.initState();
    getAllItem = FirebaseFirestore.instance.collection("items").get();
    getAllUnit = FirebaseFirestore.instance.collection("units").get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.1.w, color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5.r),
      ),
      padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
      child: ScrollConfiguration(
        behavior: NoGloww(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        child: FutureBuilder(
                            future: getAllItem,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  "Error Database",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return DropdownSearchMap(
                                  hintText: "Item Code",
                                  parameter: "itemCode",
                                  title: "Item Code",
                                  controller: _itemCode,
                                  data: const [],
                                  onItemSelected: (data) {},
                                );
                              } else {
                                List group = [];

                                snapshot.data.docs.map((data) {
                                  group.add(data.data());
                                }).toList();

                                return DropdownSearchMap(
                                  hintText: "Item Code",
                                  parameter: "itemCode",
                                  title: "Item Code",
                                  controller: _itemCode,
                                  data: group,
                                  onItemSelected: (data) {
                                    setState(() {
                                      _itemName.text = data["itemName"];
                                      _itemCode.text = data["itemCode"];
                                      _unitName.text = data["unit"];
                                      _place = data["place"];
                                    });
                                  },
                                );
                              }
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        child: FutureBuilder(
                            future: getAllItem,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  "Error Database",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return DropdownSearchMap(
                                  hintText: "Item Name",
                                  parameter: "itemName",
                                  title: "Item Name",
                                  controller: _itemName,
                                  data: const [],
                                  onItemSelected: (data) {},
                                );
                              } else {
                                List group = [];

                                snapshot.data.docs.map((data) {
                                  group.add(data.data());
                                }).toList();

                                return DropdownSearchMap(
                                  hintText: "Item Name",
                                  parameter: "itemName",
                                  title: "Item Name",
                                  controller: _itemName,
                                  data: group,
                                  onItemSelected: (data) {
                                    setState(() {
                                      _itemName.text = data["itemName"];
                                      _itemCode.text = data["itemCode"];
                                      _unitName.text = data["unit"];
                                      _place = data["place"];
                                    });
                                  },
                                );
                              }
                            }),
                      ),
                    ),
                    FutureBuilder(
                        future: getAllUnit,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              "Error Database",
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0.w),
                                    child: Text(
                                      "Unit",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0.w),
                                    child: DropdownWaiting(
                                        hintText: "Select Unit"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            List<String> group = [];

                            snapshot.data.docs.map((data) {
                              group.add(data.data()['unitName']);
                            }).toList();

                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0.w),
                                    child: Text(
                                      "Unit",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0.w),
                                    child: DropdownWithSearch(
                                      controller: _unitName,
                                      data: group,
                                      hintText: 'Select Unit',
                                      focusNode: FocusNode(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    CustomFormField(
                      readOnly: false,
                      title: "Quantity",
                      textEditingController: _quantity,
                      hintText: "Quantity...",
                      textInputType: TextInputType.text,
                    ),
                    CustomFormField(
                      readOnly: false,
                      title: "Date Come",
                      textEditingController: _dateCome,
                      hintText: "Date Come...",
                      textInputType: TextInputType.none,
                      onTap: _selectDate,
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 135.w,
                        height: 50.h,
                        child: CustomButton(
                            isLoading: uploading,
                            title: "Add Stock",
                            onTap: () async {
                              setState(() {
                                uploading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                DateTime dateTime = DateTime.now();

                                String idDocs = FirebaseFirestore.instance
                                    .collection("adjustmentStock")
                                    .doc()
                                    .id;
                                String idDocHistory =
                                    "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                HistoryLogModel history = HistoryLogModel(
                                  idDoc: idDocHistory,
                                  date: dateTime.day,
                                  month: dateTime.month,
                                  year: dateTime.year,
                                  dateTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(dateTime),
                                  keterangan: "Menambahkan stock item",
                                  user: FirebaseAuth
                                          .instance.currentUser!.email ??
                                      "",
                                  type: "create",
                                );

                                HistoryLogModelFunction historyLogFunction =
                                    HistoryLogModelFunction(idDocHistory);

                                try {
                                  FirebaseFirestore.instance
                                      .collection('adjustmentStock')
                                      .doc(idDocs)
                                      .set({
                                    "id": idDocs,
                                    "itemName": _itemName.text.trim(),
                                    "itemCode": _itemCode.text.trim(),
                                    "unit": _unitName.text.trim(),
                                    "quantity": _quantity.text.isNotEmpty
                                        ? num.parse(_quantity.text)
                                        : 0,
                                    "status": "input",
                                    "type": "in",
                                    "date": _dateCome.text.trim(),
                                    "place": _place,
                                  });

                                  await historyLogFunction.addHistory(
                                      history, idDocHistory);

                                  setState(() {
                                    uploading = false;
                                    _itemCode.clear();
                                    _dateCome.clear();
                                    _itemName.clear();
                                    _quantity.clear();
                                    _unitName.clear();
                                    _place = "kitchen";
                                  });

                                  // ignore: use_build_context_synchronously
                                  CustomToast.successToast(
                                      context, "Berhasil menambahkan stock");
                                } on FirebaseException catch (_) {
                                  setState(() {
                                    uploading = false;
                                    _itemCode.clear();
                                    _dateCome.clear();
                                    _itemName.clear();
                                    _quantity.clear();
                                    _unitName.clear();
                                    _place = "kitchen";
                                  });
                                  // ignore: use_build_context_synchronously
                                  CustomToast.errorToast(
                                      context, "Gagal menambahkan stock");
                                }
                              }
                            },
                            color: SonomaneColor.containerLight,
                            bgColor: SonomaneColor.primary),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      SizedBox(
                        width: 135.w,
                        height: 50.h,
                        child: CustomButton(
                            isLoading2: uploading2,
                            title: "Clear",
                            onTap: () {
                              setState(() {
                                _itemCode.clear();
                                _dateCome.clear();
                                _itemName.clear();
                                _quantity.clear();
                                _unitName.clear();
                                _place = "kitchen";
                              });
                            },
                            color: SonomaneColor.textTitleLight,
                            bgColor: SonomaneColor.secondary),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
