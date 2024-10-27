import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/inventory/item_inventory.dart';
import 'package:sonomaneoutlet/model/spoile/spoile.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownSearchNoValidator.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownWaiting.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formfieldNoValidator.dart';
import 'package:sonomaneoutlet/shared_widget/search_dropdown_map.dart';

class AddSpoile extends StatefulWidget {
  const AddSpoile({super.key});

  @override
  State<AddSpoile> createState() => _AddSpoileState();
}

class _AddSpoileState extends State<AddSpoile> {
  List<ItemModel> items = [];

  bool _uploading = false;

  final focus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String _placeDropdown = "kitchen";
  final TextEditingController _unitName = TextEditingController();
  final TextEditingController _itemCode = TextEditingController();
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _description = TextEditingController();

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.0.h),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
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
                    Text(
                      'Add Item Spoile',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.1.w,
                          color: Theme.of(context).colorScheme.outline),
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
                              SizedBox(
                                height: 20.h,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0.w),
                                      child: FutureBuilder(
                                          future: getAllItem,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                "Error Database",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              );
                                            } else if (snapshot
                                                    .connectionState ==
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
                                                    _itemName.text =
                                                        data["itemName"];
                                                    _itemCode.text =
                                                        data["itemCode"];
                                                    _unitName.text =
                                                        data["unit"];
                                                  });
                                                },
                                              );
                                            }
                                          }),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0.w),
                                      child: FutureBuilder(
                                          future: getAllItem,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                "Error Database",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              );
                                            } else if (snapshot
                                                    .connectionState ==
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
                                                    _itemName.text =
                                                        data["itemName"];
                                                    _itemCode.text =
                                                        data["itemCode"];
                                                    _unitName.text =
                                                        data["unit"];
                                                  });
                                                },
                                              );
                                            }
                                          }),
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: getAllUnit,
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                            "Error Database",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0.w),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0.w),
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
                                                  child:
                                                      DropdownWithSearchNoValidator(
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
                                  CustomDropdown(
                                    onChanged: (value) {
                                      _placeDropdown = value ?? "kitchen";
                                    },
                                    title: "Place",
                                    hintText: "kitchen/bar/floor",
                                    data: const ["kitchen", "bar", "floor"],
                                  ),
                                  CustomFormFieldNoValidator(
                                    readOnly: false,
                                    title: "Quantity",
                                    textEditingController: _quantity,
                                    hintText: "",
                                    textInputType: TextInputType.number,
                                  ),
                                  CustomFormFieldNoValidator(
                                    readOnly: false,
                                    title: "Description",
                                    textEditingController: _description,
                                    hintText: "",
                                    textInputType: TextInputType.text,
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
                                          isLoading: _uploading,
                                          title: "Simpan",
                                          onTap: _uploading == false
                                              ? () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      _uploading = true;
                                                    });

                                                    DateTime dateTime =
                                                        DateTime.now();

                                                    String idDocHistory =
                                                        "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                                    final idDocSpoile =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "spoile")
                                                            .doc()
                                                            .id;

                                                    HistoryLogModel history =
                                                        HistoryLogModel(
                                                      idDoc: idDocHistory,
                                                      date: dateTime.day,
                                                      month: dateTime.month,
                                                      year: dateTime.year,
                                                      dateTime: DateFormat(
                                                              'yyyy-MM-dd HH:mm:ss')
                                                          .format(dateTime),
                                                      keterangan:
                                                          "Menambahkan Spoile Item",
                                                      user: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email ??
                                                          "",
                                                      type: "create",
                                                    );

                                                    SpoileModel spoile =
                                                        SpoileModel(
                                                      idDoc: idDocSpoile,
                                                      itemCode:
                                                          _itemCode.text.trim(),
                                                      itemName:
                                                          _itemName.text.trim(),
                                                      place: _placeDropdown,
                                                      unit:
                                                          _unitName.text.trim(),
                                                      description: _description
                                                          .text
                                                          .trim(),
                                                      quantity: _quantity
                                                              .text.isNotEmpty
                                                          ? num.parse(_quantity
                                                              .text
                                                              .trim())
                                                          : 0,
                                                      date: DateFormat(
                                                              'yyyy-MM-dd HH:mm:ss')
                                                          .format(dateTime),
                                                    );

                                                    HistoryLogModelFunction
                                                        historyLogFunction =
                                                        HistoryLogModelFunction(
                                                            idDocHistory);

                                                    SpoileFunction
                                                        spoileFunction =
                                                        SpoileFunction();

                                                    try {
                                                      await spoileFunction
                                                          .addSpoile(spoile,
                                                              idDocSpoile);
                                                      await historyLogFunction
                                                          .addHistory(history,
                                                              idDocHistory);

                                                      setState(() {
                                                        _uploading = false;
                                                        _itemCode.clear();
                                                        _itemName.clear();
                                                        _unitName.clear();

                                                        _quantity.clear();
                                                        _placeDropdown =
                                                            "kitchen";
                                                      });

                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context)
                                                          .pop();

                                                      // ignore: use_build_context_synchronously
                                                      CustomToast.successToast(
                                                          context,
                                                          "Berhasil menambahkan spoile item");
                                                    } on FirebaseException catch (_) {
                                                      setState(() {
                                                        _uploading = false;
                                                        _itemCode.clear();
                                                        _itemName.clear();
                                                        _unitName.clear();
                                                        _quantity.clear();
                                                        _placeDropdown =
                                                            "kitchen";
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      CustomToast.errorToast(
                                                          context,
                                                          "Gagal menambahkan spoile item");
                                                    }
                                                  }
                                                }
                                              : () {},
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
                                          isLoading2: false,
                                          title: "Clear",
                                          onTap: _uploading == false
                                              ? () {
                                                  setState(() {
                                                    _uploading = false;
                                                    _itemCode.clear();
                                                    _itemName.clear();
                                                    _unitName.clear();
                                                    _quantity.clear();
                                                    _placeDropdown = "kitchen";
                                                  });
                                                }
                                              : () {},
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
