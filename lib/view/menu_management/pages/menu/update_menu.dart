import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/menu/menu.dart';
import 'package:sonomaneoutlet/model/menu_addon/menu_addon.dart';
import 'package:sonomaneoutlet/model/menu_category/menu_category.dart';
import 'package:sonomaneoutlet/model/menu_subcategory/menu_subcategory.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';
import 'package:sonomaneoutlet/shared_widget/formField_novalidation.dart';
import 'package:sonomaneoutlet/view/menu_management/widget/upload_many_image.dart';
import 'package:uuid/uuid.dart';

class UpdateMenu extends StatefulWidget {
  final String idDoc;
  final String name;
  final String description;
  final num price;
  final String category;
  final String subcategory;
  final List images;
  final num discount;
  final List addons;
  const UpdateMenu(
      {super.key,
      required this.idDoc,
      required this.name,
      required this.description,
      required this.price,
      required this.category,
      required this.subcategory,
      required this.images,
      required this.discount,
      required this.addons});

  @override
  State<UpdateMenu> createState() => _UpdateMenuState();
}

class _UpdateMenuState extends State<UpdateMenu> {
  // formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _uploading = false;

  Stream? dataAddon;
  Stream? dataCategory;
  Stream? dataSubcategory;

  String _selectedCategory = "food";
  String _selectedSubCategory = "appetizer";
  String _selectedKitchenorBar = "kitchen";
  final _description = TextEditingController();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _discount = TextEditingController();
  final _codeMenu = TextEditingController();

  final List _addons = [];

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      List<XFile> image = await picker.pickMultiImage();
      if (image.isNotEmpty && image.length <= 5) {
        for (int a = 0; a < image.length; a++) {
          _pickedImage.add(File(image[a].path));
          setState(() {});
        }
      } else {
        // ignore: use_build_context_synchronously
        CustomToast.errorToast(context, "Tidak boleh lebih dari 5.");
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      List<XFile>? image = await picker.pickMultiImage();
      if (image.isNotEmpty && image.length <= 5) {
        for (int a = 0; a < image.length; a++) {
          _pickedImage.add(File(image[a].readAsBytes() as String));
          setState(() {});
        }
      } else {
        // ignore: use_build_context_synchronously
        CustomToast.errorToast(context, "Tidak boleh lebih dari 5.");
      }
    } else {
      CustomToast.errorToast(context, "Gagal mengambil gambar.");
    }
  }

  List imageUrl = [];
  // String imageName = '';
  final List<File> _pickedImage = [];
  Uint8List webImage = Uint8List(8);

  void _setToController() {
    _codeMenu.text = widget.idDoc;
    _name.text = widget.name;
    _description.text = widget.description;
    _price.text = widget.price.toStringAsFixed(0);
    _selectedCategory = widget.category;
    _selectedSubCategory = widget.subcategory;
    _discount.text =
        widget.discount != 0 ? (widget.discount * 100).toStringAsFixed(0) : "";
    _addons.addAll(widget.addons);
  }

  @override
  void initState() {
    super.initState();
    dataAddon = AddonFunction().getAllAddon();
    dataCategory = CategoryFunction().getAllCategory();
    dataSubcategory = SubCategoryFunction().getAllSubCategory();
    _setToController();
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
                      'Update Menu',
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
                    width: double.infinity,
                    height: double.infinity,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: true,
                                    title: 'Code',
                                    textEditingController: _codeMenu,
                                    hintText: "Code...",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Name',
                                    textEditingController: _name,
                                    hintText: "Name...",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Price',
                                    textEditingController: _price,
                                    hintText: "Price...",
                                    textInputType: TextInputType.number,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Description',
                                    textEditingController: _description,
                                    hintText: "Description...",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomFormFieldNoValidation(
                                    readOnly: false,
                                    title: 'Discount',
                                    textEditingController: _discount,
                                    hintText: "Discount...",
                                    textInputType: TextInputType.number,
                                  ),
                                  StreamBuilder(
                                      stream: dataCategory,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                            "Error Database",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CustomDropdown(
                                            title: "Category",
                                            data: const [],
                                            hintText: "Select Category",
                                            onChanged: (value) {},
                                            textNow: _selectedCategory,
                                          );
                                        }
                                        List<String> data = [];
                                        snapshot.data.docs.map((e) {
                                          data.add(
                                            e.data()['name'],
                                          );
                                        }).toList();
                                        return CustomDropdown(
                                          title: "Category",
                                          data: data,
                                          hintText: "Select Category",
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCategory = value!;
                                            });
                                          },
                                          textNow: _selectedCategory,
                                        );
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 200.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          StreamBuilder(
                                              stream: dataSubcategory,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                    "Error Database",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  );
                                                } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CustomDropdown(
                                                    title: "Sub Category",
                                                    data: const [],
                                                    hintText:
                                                        "Select Sub Category",
                                                    onChanged: (value) {},
                                                    textNow:
                                                        _selectedSubCategory,
                                                  );
                                                }
                                                List<String> data = [];
                                                snapshot.data.docs.map((e) {
                                                  data.add(
                                                    e.data()['name'],
                                                  );
                                                }).toList();
                                                return CustomDropdown(
                                                  title: "Sub Category",
                                                  data: data,
                                                  hintText:
                                                      "Select Sub Category",
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedSubCategory =
                                                          value!;
                                                    });
                                                  },
                                                  textNow: _selectedSubCategory,
                                                );
                                              }),
                                          CustomDropdown(
                                            title: "Kitchen or Bar",
                                            data: const ["kitchen", "bar"],
                                            hintText: "Select kitchen / bar",
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedKitchenorBar = value!;
                                              });
                                            },
                                            textNow: _selectedKitchenorBar,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  UploadManyImage(
                                      updateORno: "update",
                                      imageDB: widget.images,
                                      onTap: _pickImage,
                                      pickedImage: _pickedImage,
                                      pickedImageClear: () {
                                        _pickedImage.clear();
                                      },
                                      removeImage: (int index) {
                                        _pickedImage.removeAt(index);
                                        setState(() {});
                                      }),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 16.0.w),
                                          child: Text(
                                            'Addon yang tersedia : ',
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
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 52.h,
                                            child: StreamBuilder(
                                              stream: dataAddon,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  Text(
                                                    "Error database",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  );
                                                }

                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(
                                                    height: 35.h,
                                                  );
                                                }

                                                final List addons = [];
                                                snapshot.data!.docs.map(
                                                    (DocumentSnapshot
                                                        document) {
                                                  Map a = document.data()
                                                      as Map<String, dynamic>;
                                                  addons.add(a);
                                                  a['id'] = document.id;
                                                }).toList();
                                                return ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    for (int i = 0;
                                                        i < addons.length;
                                                        i++) ...{
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (_addons.any(
                                                                (element) =>
                                                                    element[
                                                                        'id'] ==
                                                                    addons[i][
                                                                        'id'])) {
                                                              _addons.removeWhere(
                                                                  (element) =>
                                                                      element[
                                                                          'id'] ==
                                                                      addons[i][
                                                                          'id']);
                                                            } else {
                                                              _addons.add({
                                                                'id': addons[i]
                                                                    ['id'],
                                                                'name': addons[
                                                                    i]['name'],
                                                                'price': addons[
                                                                    i]['price']
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: 6.w,
                                                          ),
                                                          child: Chip(
                                                            backgroundColor: _addons.any(
                                                                    (element) =>
                                                                        element[
                                                                            'id'] ==
                                                                        addons[i]
                                                                            [
                                                                            'id'])
                                                                ? SonomaneColor
                                                                    .primary
                                                                : SonomaneColor
                                                                    .textParaghrapDark,
                                                            label: Text(
                                                              addons[i]['name']
                                                                  .toString()
                                                                  .capitalize(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    color: _addons.any((element) =>
                                                                            element['id'] ==
                                                                            addons[i][
                                                                                'id'])
                                                                        ? SonomaneColor
                                                                            .textTitleDark
                                                                        : SonomaneColor
                                                                            .textTitleLight,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    }
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0.w),
                                          child: Container(
                                            width: double.infinity,
                                            height: 150.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 0.7.w,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                            child: Wrap(
                                              children: [
                                                for (int i = 0;
                                                    i < _addons.length;
                                                    i++) ...{
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 3.w),
                                                    child: Chip(
                                                      backgroundColor:
                                                          SonomaneColor.primary,
                                                      onDeleted: () {
                                                        setState(() {
                                                          _addons.removeWhere(
                                                              (element) =>
                                                                  element[
                                                                      'id'] ==
                                                                  _addons[i]
                                                                      ['id']);
                                                        });
                                                      },
                                                      label: Text(
                                                        _addons[i]['name']
                                                            .toString()
                                                            .capitalize(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              color: _addons.any((element) =>
                                                                      element[
                                                                          'id'] ==
                                                                      _addons[i]
                                                                          [
                                                                          'id'])
                                                                  ? SonomaneColor
                                                                      .textTitleDark
                                                                  : SonomaneColor
                                                                      .textTitleLight,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                }
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
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
                                          title: "Update Menu",
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (_uploading == false) {
                                                setState(() {
                                                  _uploading = true;
                                                });

                                                String pId = const Uuid().v4();
                                                Reference referenceRoot =
                                                    FirebaseStorage.instance
                                                        .ref();
                                                Reference referenceDirImages =
                                                    referenceRoot
                                                        .child('Images');
                                                String productPath =
                                                    '$_selectedCategory/${_name.text}';

                                                if (_pickedImage.isEmpty &&
                                                    widget.images.isEmpty) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Silahkan Pilih Gambar Terlebih Dahulu!');
                                                  return;
                                                }
                                                if (_pickedImage.isNotEmpty) {
                                                  try {
                                                    for (int i = 0;
                                                        i < _pickedImage.length;
                                                        i++) {
                                                      String imageFileName =
                                                          'product_$pId$i.jpg';
                                                      Reference
                                                          referenceImageToUpload =
                                                          referenceDirImages.child(
                                                              '$productPath/$imageFileName');

                                                      if (kIsWeb) {
                                                        await referenceImageToUpload
                                                            .putData(
                                                          webImage,
                                                          SettableMetadata(
                                                              contentType:
                                                                  'image/jpeg'),
                                                        );
                                                      } else {
                                                        // Store the file for non-web (mobile, desktop)
                                                        await referenceImageToUpload
                                                            .putFile(File(
                                                                _pickedImage[i]
                                                                    .path));
                                                      }

                                                      imageUrl.add(
                                                          await referenceImageToUpload
                                                              .getDownloadURL());
                                                    }
                                                    for (int i = 0;
                                                        i <
                                                            widget
                                                                .images.length;
                                                        i++) {
                                                      FirebaseStorage.instance
                                                          .refFromURL(
                                                              widget.images[i])
                                                          .delete();
                                                    }
                                                  } catch (error) {
                                                    setState(() {
                                                      _uploading = false;
                                                    });
                                                    // ignore: use_build_context_synchronously
                                                    CustomToast.errorToast(
                                                        context,
                                                        'Gagal upload gambar');
                                                    return;
                                                  }
                                                }

                                                try {
                                                  MenuFunction menuFunction =
                                                      MenuFunction();
                                                  MenuModel menu = MenuModel(
                                                      idDoc: widget.idDoc,
                                                      id: widget.idDoc,
                                                      name: _name.text.trim(),
                                                      price:
                                                          _price.text.isNotEmpty
                                                              ? num.parse(
                                                                  _price.text)
                                                              : 0,
                                                      addon: _addons,
                                                      category:
                                                          _selectedCategory,
                                                      description: _description
                                                          .text
                                                          .trim(),
                                                      discount: _discount
                                                              .text.isNotEmpty
                                                          ? num.parse(_discount
                                                                  .text) /
                                                              100
                                                          : 0,
                                                      images: imageUrl.isEmpty
                                                          ? widget.images
                                                          : imageUrl,
                                                      subcategory:
                                                          _selectedSubCategory,
                                                      recommended: false,
                                                      kitchenORBar:
                                                          _selectedKitchenorBar,
                                                      codeBOM: "");

                                                  DateTime dateTime =
                                                      DateTime.now();

                                                  String idDocHistory =
                                                      "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                                  HistoryLogModel history =
                                                      HistoryLogModel(
                                                    idDoc: idDocHistory,
                                                    date: dateTime.day,
                                                    month: dateTime.month,
                                                    year: dateTime.year,
                                                    dateTime: DateFormat(
                                                            'yyyy-MM-dd HH:mm:ss')
                                                        .format(dateTime),
                                                    keterangan: "Mengubah menu",
                                                    user: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .email ??
                                                        "",
                                                    type: "update",
                                                  );

                                                  HistoryLogModelFunction
                                                      historyLogFunction =
                                                      HistoryLogModelFunction(
                                                          idDocHistory);

                                                  await menuFunction.updateMenu(
                                                      menu, widget.idDoc);

                                                  await historyLogFunction
                                                      .addHistory(history,
                                                          idDocHistory);

                                                  setState(() {
                                                    _name.clear();
                                                    _price.clear();
                                                    _discount.clear();
                                                    _description.clear();
                                                    _pickedImage.clear();
                                                    _addons.clear();
                                                    _discount.clear();
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.successToast(
                                                      context,
                                                      'Menu berhasil diubah!');
                                                } catch (error) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Menu gagal diubah!');
                                                }
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
                                          isLoading: false,
                                          title: "Clear",
                                          onTap: _uploading == false
                                              ? () async {
                                                  setState(() {
                                                    _name.clear();
                                                    _price.clear();
                                                    _discount.clear();
                                                    _description.clear();
                                                    _pickedImage.clear();
                                                    _addons.clear();
                                                    _discount.clear();
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