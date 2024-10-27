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
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownSearch.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownWaiting.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  List<ItemModel> items = [];

  bool _uploading = false;

  final focus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemCode = TextEditingController();
  final TextEditingController _unitName = TextEditingController();
  String _placeDropdown = "kitchen";
  Future? getAllsatuan;

  @override
  void initState() {
    super.initState();
    getAllsatuan = FirebaseFirestore.instance.collection("units").get();
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
                      'Add Item',
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
                    child: Form(
                      key: _formKey,
                      child: ScrollConfiguration(
                        behavior: NoGloww(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: false,
                                    title: "Item Code",
                                    textEditingController: _itemCode,
                                    hintText: "Item Code",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: "Item Name",
                                    textEditingController: _itemName,
                                    hintText: "Item Name",
                                    textInputType: TextInputType.text,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 15.0.w),
                                          child: Text(
                                            "Units",
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
                                          child: FutureBuilder(
                                              future: getAllsatuan,
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
                                                  return DropdownWaiting(
                                                      hintText: "Select Unit");
                                                } else {
                                                  List<String> group = [];

                                                  snapshot.data.docs
                                                      .map((data) {
                                                    group.add(data
                                                        .data()['unitName']);
                                                  }).toList();

                                                  return DropdownWithSearch(
                                                    controller: _unitName,
                                                    data: group,
                                                    hintText: 'Select Unit',
                                                    focusNode: focus,
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                  const Expanded(child: SizedBox()),
                                  const Expanded(child: SizedBox()),
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
                                          title: "Tambah",
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
                                                    ItemModel item = ItemModel(
                                                      idDoc:
                                                          _itemCode.text.trim(),
                                                      itemCode:
                                                          _itemCode.text.trim(),
                                                      place: _placeDropdown,
                                                      itemName:
                                                          _itemName.text.trim(),
                                                      unit:
                                                          _unitName.text.trim(),
                                                      status: true,
                                                      createdAt: DateFormat(
                                                              'yyyy-MM-dd HH:mm')
                                                          .format(dateTime),
                                                      updatedAt: DateFormat(
                                                              'yyyy-MM-dd HH:mm')
                                                          .format(dateTime),
                                                    );

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
                                                          "Menambahkan item",
                                                      user: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email ??
                                                          "",
                                                      type: "create",
                                                    );

                                                    HistoryLogModelFunction
                                                        historyLogFunction =
                                                        HistoryLogModelFunction(
                                                            idDocHistory);

                                                    try {
                                                      final checkID =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "items")
                                                              .doc(_itemCode
                                                                  .text
                                                                  .trim())
                                                              .get();
                                                      if (checkID.exists) {
                                                        setState(() {
                                                          _uploading = false;
                                                        });

                                                        // ignore: use_build_context_synchronously
                                                        CustomToast.successToast(
                                                            context,
                                                            "Code item sudah ada");
                                                      } else {
                                                        await item.addItem();
                                                        await historyLogFunction
                                                            .addHistory(history,
                                                                idDocHistory);
                                                        setState(() {
                                                          _uploading = false;
                                                          _itemName.clear();
                                                          _itemCode.clear();
                                                          _unitName.clear();
                                                        });

                                                        // ignore: use_build_context_synchronously
                                                        Navigator.of(context)
                                                            .pop();

                                                        // ignore: use_build_context_synchronously
                                                        CustomToast.successToast(
                                                            context,
                                                            "Berhasil menambahkan item");
                                                      }
                                                    } on FirebaseException catch (_) {
                                                      setState(() {
                                                        _uploading = false;
                                                        _itemName.clear();
                                                        _itemCode.clear();
                                                        _unitName.clear();
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      CustomToast.errorToast(
                                                          context,
                                                          "Gagal menambahkan item");
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
                                                    _itemName.clear();
                                                    _unitName.clear();
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
