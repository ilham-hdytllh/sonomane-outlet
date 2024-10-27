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
import 'package:sonomaneoutlet/shared_widget/dropdownSearchNoValidator.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownWaiting.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';
import 'package:sonomaneoutlet/shared_widget/formfieldNoValidator.dart';
import 'package:sonomaneoutlet/shared_widget/search_dropdown_map.dart';

class AddBOM extends StatefulWidget {
  const AddBOM({super.key});

  @override
  State<AddBOM> createState() => _AddBOMState();
}

class _AddBOMState extends State<AddBOM> {
  List<ItemModel> items = [];

  bool _uploading = false;

  final focus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String _placeDropdown = "kitchen";
  String _idMenu = "";
  final TextEditingController _codeBOM = TextEditingController();
  final TextEditingController _menuName = TextEditingController();
  final TextEditingController _unitName = TextEditingController();
  final TextEditingController _itemCode = TextEditingController();
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _netto = TextEditingController();
  final TextEditingController _gross = TextEditingController();
  final TextEditingController _waste = TextEditingController();

  final List _allItemBOM = [];

  Future? getAllMenu;
  Future? getAllItem;
  Future? getAllUnit;

  void setGross() {
    if (_netto.text.isNotEmpty && _waste.text.isNotEmpty) {
      double nettoValue = double.tryParse(_netto.text) ?? 0.0;
      double wastePercentage = double.tryParse(_waste.text) ?? 0.0;

      double grossValue = nettoValue * (wastePercentage / 100);

      double gross = nettoValue - grossValue;
      _gross.text = gross.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getAllItem = FirebaseFirestore.instance.collection("items").get();
    getAllUnit = FirebaseFirestore.instance.collection("units").get();
    getAllMenu = FirebaseFirestore.instance
        .collection("menu")
        .where("codeBOM", isEqualTo: "")
        .get();
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
                      'Add BOM',
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
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: false,
                                    title: "Code BOM",
                                    textEditingController: _codeBOM,
                                    hintText: "Code BOM",
                                    textInputType: TextInputType.text,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0.w),
                                      child: FutureBuilder(
                                          future: getAllMenu,
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
                                                hintText: "Menu Name",
                                                parameter: "name",
                                                title: "Menu Name",
                                                controller: _menuName,
                                                data: const [],
                                                onItemSelected: (data) {},
                                              );
                                            } else {
                                              List group = [];

                                              snapshot.data.docs.map((data) {
                                                group.add(data.data());
                                              }).toList();

                                              return DropdownSearchMap(
                                                hintText: "Menu Name",
                                                parameter: "name",
                                                title: "Menu Name",
                                                controller: _menuName,
                                                data: group,
                                                onItemSelected: (data) {
                                                  setState(() {
                                                    _menuName.text =
                                                        data["name"];
                                                    _idMenu = data["id"];
                                                  });
                                                },
                                              );
                                            }
                                          }),
                                    ),
                                  ),
                                  CustomDropdown(
                                    onChanged: (value) {
                                      _placeDropdown = value ?? "kitchen";
                                    },
                                    title: "Place",
                                    hintText: "kitchen/bar/floor",
                                    data: const ["kitchen", "bar", "floor"],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Divider(
                                thickness: 1.w,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withOpacity(0.6),
                              ),
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
                                  CustomFormFieldNoValidator(
                                    readOnly: false,
                                    title: "Netto",
                                    textEditingController: _netto,
                                    hintText: "",
                                    textInputType: TextInputType.number,
                                    onChange: (value) {
                                      setGross();
                                    },
                                  ),
                                  CustomFormFieldNoValidator(
                                    readOnly: false,
                                    title: "Waste %",
                                    textEditingController: _waste,
                                    hintText: "",
                                    textInputType: TextInputType.number,
                                    onChange: (value) {
                                      setGross();
                                    },
                                  ),
                                  CustomFormFieldNoValidator(
                                    readOnly: true,
                                    title: "Gross",
                                    textEditingController: _gross,
                                    hintText: "",
                                    textInputType: TextInputType.number,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.0.w),
                                        child: const Text(
                                          "",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        height: 53.h,
                                        child: CustomButton(
                                            isLoading: false,
                                            title: "Tambah",
                                            onTap: () {
                                              if (_itemCode.text.isNotEmpty &&
                                                  _itemName.text.isNotEmpty &&
                                                  _unitName.text.isNotEmpty &&
                                                  _netto.text.isNotEmpty &&
                                                  _waste.text.isNotEmpty &&
                                                  _gross.text.isNotEmpty) {
                                                _allItemBOM.add({
                                                  "itemCode":
                                                      _itemCode.text.trim(),
                                                  "itemName":
                                                      _itemName.text.trim(),
                                                  "unit": _unitName.text.trim(),
                                                  "netto": _netto
                                                          .text.isNotEmpty
                                                      ? num.parse(
                                                          _netto.text.trim())
                                                      : 0,
                                                  "waste": _waste
                                                          .text.isNotEmpty
                                                      ? num.parse(
                                                          _waste.text.trim())
                                                      : 0,
                                                  "gross": _gross
                                                          .text.isNotEmpty
                                                      ? num.parse(
                                                          _gross.text.trim())
                                                      : 0,
                                                  "no": _allItemBOM.length + 1,
                                                });
                                                _itemCode.clear();
                                                _itemName.clear();
                                                _unitName.clear();
                                                _waste.clear();
                                                _netto.clear();
                                                _gross.clear();
                                                setState(() {});
                                              }
                                            },
                                            color: SonomaneColor.textTitleDark,
                                            bgColor: SonomaneColor.primary),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  columnSpacing: 22.w,
                                  headingRowColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .background),
                                  headingRowHeight: 50.h,
                                  dataRowMaxHeight: 50.h,
                                  dataRowMinHeight: 50.h,
                                  headingTextStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 14.sp),
                                  dataTextStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 14.sp),
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'No',
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Item Code",
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Item Name',
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Netto",
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Waste %",
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Gross",
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Unit",
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    for (int a = 0;
                                        a < _allItemBOM.length;
                                        a++) ...{
                                      DataRow(
                                        cells: [
                                          DataCell(SizedBox(
                                            child: Text(
                                              (a + 1).toString(),
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            child: Text(
                                              _allItemBOM[a]["itemCode"],
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            child: Text(
                                              _allItemBOM[a]["itemName"],
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            child: Text(
                                              _allItemBOM[a]["unit"],
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            child: Text(
                                              _allItemBOM[a]["netto"]
                                                  .toString(),
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            child: Text(
                                              _allItemBOM[a]["waste"]
                                                  .toString(),
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            child: Text(
                                              _allItemBOM[a]["gross"]
                                                  .toString(),
                                            ),
                                          )),
                                        ],
                                      ),
                                    }
                                  ],
                                ),
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

                                                    WriteBatch batch =
                                                        FirebaseFirestore
                                                            .instance
                                                            .batch();

                                                    // Add the BOM document
                                                    batch.set(
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "billOfMaterial")
                                                          .doc(_codeBOM.text),
                                                      {
                                                        "codeBOM": _codeBOM.text
                                                            .trim(),
                                                        "menuID": _idMenu,
                                                        "menuName": _menuName
                                                            .text
                                                            .trim(),
                                                        "place": _placeDropdown,
                                                        "itemsBOM": _allItemBOM,
                                                        "createdAt": DateFormat(
                                                                'yyyy-MM-dd HH:mm:ss')
                                                            .format(dateTime),
                                                        "lastUpdate": DateFormat(
                                                                'yyyy-MM-dd HH:mm:ss')
                                                            .format(dateTime),
                                                      },
                                                    );

                                                    // Update the menu document
                                                    batch.update(
                                                      FirebaseFirestore.instance
                                                          .collection("menu")
                                                          .doc(_idMenu),
                                                      {
                                                        "codeBOM":
                                                            _codeBOM.text.trim()
                                                      },
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
                                                          "Menambahkan BOM",
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
                                                      // Commit the batch
                                                      await batch.commit();

                                                      await historyLogFunction
                                                          .addHistory(history,
                                                              idDocHistory);

                                                      setState(() {
                                                        _uploading = false;
                                                        _itemCode.clear();
                                                        _itemName.clear();
                                                        _unitName.clear();
                                                        _waste.clear();
                                                        _netto.clear();
                                                        _gross.clear();
                                                        _codeBOM.clear();
                                                        _menuName.clear();
                                                        _placeDropdown =
                                                            "kitchen";
                                                        _idMenu = "";
                                                        _allItemBOM.clear();
                                                      });

                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context)
                                                          .pop();

                                                      // ignore: use_build_context_synchronously
                                                      CustomToast.successToast(
                                                          context,
                                                          "Berhasil menambahkan BOM");
                                                    } on FirebaseException catch (_) {
                                                      setState(() {
                                                        _uploading = false;
                                                        _itemCode.clear();
                                                        _itemName.clear();
                                                        _unitName.clear();
                                                        _waste.clear();
                                                        _netto.clear();
                                                        _gross.clear();
                                                        _codeBOM.clear();
                                                        _menuName.clear();
                                                        _placeDropdown =
                                                            "kitchen";
                                                        _idMenu = "";
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      CustomToast.errorToast(
                                                          context,
                                                          "Gagal menambahkan BOM");
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
                                                    _codeBOM.clear();
                                                    _menuName.clear();
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
