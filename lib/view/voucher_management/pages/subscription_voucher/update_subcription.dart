import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/menu_voucher/menu_subscription.dart';
import 'package:sonomaneoutlet/model/voucher/voucher.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';
import 'package:sonomaneoutlet/view/voucher_management/widget/card_menu_voucher.dart';
import 'package:sonomaneoutlet/view/voucher_management/widget/generate_kode_voucher.dart';
import 'package:sonomaneoutlet/view/voucher_management/widget/item_formfield.dart';
import 'package:sonomaneoutlet/view/voucher_management/widget/list_formfield.dart';
import 'package:sonomaneoutlet/view/voucher_management/widget/upload_one_image.dart';

class UpdateSubscriptionVoucher extends StatefulWidget {
  final String? idDoc;
  final String? image;
  final String? discountType;
  final String? voucherType;
  final String? voucherTitle;
  final num? masaBerlaku;
  final num? discountAmount;
  final num? discountPercent;
  final String? voucherCode;
  final num? minimumPurchase;
  final num? maximumDiscount;
  final List? caraKerja;
  final List? syaratKetentuan;
  final bool? used;
  final String? createdAt;
  final List? item;
  final num? price;
  const UpdateSubscriptionVoucher({
    super.key,
    this.idDoc,
    this.image,
    this.discountType,
    this.voucherType,
    this.voucherTitle,
    this.masaBerlaku,
    this.discountAmount,
    this.discountPercent,
    this.voucherCode,
    this.minimumPurchase,
    this.maximumDiscount,
    this.caraKerja,
    this.syaratKetentuan,
    this.used,
    this.createdAt,
    this.item,
    this.price,
  });

  @override
  State<UpdateSubscriptionVoucher> createState() =>
      _UpdateSubscriptionVoucherState();
}

class _UpdateSubscriptionVoucherState extends State<UpdateSubscriptionVoucher> {
  Stream? menu;

  bool _uploading = false;

  String _discountType = 'percent';
  final List _itemAdd = [];

  final List<String> _listDiscountType = [
    'percent',
    'amount',
    'item',
  ];

  GlobalKey<FormState> key = GlobalKey();
  final TextEditingController _voucherTitle = TextEditingController();
  final TextEditingController _masaBerlaku = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _discountAmount = TextEditingController();
  final TextEditingController _voucherCode = TextEditingController();
  final TextEditingController _discountPercent = TextEditingController();
  final TextEditingController _minimumPurchase = TextEditingController();
  final TextEditingController _maximumDiscount = TextEditingController();
  final TextEditingController _limitPerDay = TextEditingController();

  String generateRandomVoucherCode(int length) {
    final random = Random();
    String chars = '0123456789';
    String code = '';

    for (int i = 0; i < length; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  Future alertSemuaMenu() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            content: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 1000.w,
              height: 700.h,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 28.sp,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(25.r),
                          child: StreamBuilder(
                            stream: menu,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  "Kesalahan memuat data dari database",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: SonomaneColor.primary,
                                  ),
                                );
                              } else if (snapshot.data.docs.isNotEmpty) {
                                final List menuDocs = [];
                                snapshot.data!.docs.map((document) {
                                  Map a = document.data();
                                  a['idDoc'] = document.id;
                                  menuDocs.add(a);
                                }).toList();
                                return Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    for (int i = 0;
                                        i < menuDocs.length;
                                        i++) ...{
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w, vertical: 4.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            _itemAdd.add({
                                              "id": menuDocs[i]['idDoc'],
                                              "name": menuDocs[i]['name'],
                                              "price": menuDocs[i]['price'],
                                              "category": menuDocs[i]
                                                  ['category'],
                                              "images": menuDocs[i]['images']
                                                  [0],
                                              "addons": menuDocs[i]['addons'],
                                              "deskripsi": menuDocs[i]
                                                  ['description'],
                                              "subcategory": menuDocs[i]
                                                  ['subcategory'],
                                              "discount": menuDocs[i]
                                                  ['discount'],
                                              'quantity': 1,
                                              'idcart': DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                            });
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: CardMenutoVoucher(
                                            id: menuDocs[i]['idDoc'],
                                            name: menuDocs[i]['name'],
                                            price: menuDocs[i]['price'],
                                            category: menuDocs[i]['category'],
                                            images: menuDocs[i]['images'][0],
                                            addons: menuDocs[i]['addons'],
                                            deskripsi: menuDocs[i]
                                                ['description'],
                                            subcategory: menuDocs[i]
                                                ['subcategory'],
                                            discount: menuDocs[i]['discount'],
                                          ),
                                        ),
                                      ),
                                    },
                                  ],
                                );
                              } else {
                                return Text(
                                  "Tidak ada menu untuk saat ini",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      }
    } else {
      CustomToast.errorToast(context, "Gagal mengambil gambar.");
    }
  }

  String imageUrl = '';
  String imageName = '';
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  final List<TextEditingController> _sdanKetentuanController = [
    TextEditingController()
  ];
  final List<TextEditingController> _caraKerjaController = [
    TextEditingController()
  ];

  void clearControllers() {
    for (int i = 1; i < _caraKerjaController.length; i++) {
      _caraKerjaController[i].clear();
    }
    for (int i = 1; i < _sdanKetentuanController.length; i++) {
      _sdanKetentuanController[i].clear();
    }
    _caraKerjaController.removeRange(1, _caraKerjaController.length);
    _sdanKetentuanController.removeRange(1, _sdanKetentuanController.length);

    if (_caraKerjaController.isNotEmpty) {
      _caraKerjaController[0].clear();
    }
    if (_sdanKetentuanController.isNotEmpty) {
      _sdanKetentuanController[0].clear();
    }
  }

  void addToController() {
    _discountType = widget.discountType!;
    _voucherTitle.text = widget.voucherTitle!;
    _masaBerlaku.text = widget.masaBerlaku.toString();
    _voucherCode.text = widget.voucherCode!.replaceAll("SNM-", "");
    _minimumPurchase.text = widget.minimumPurchase.toString();
    _price.text = widget.price.toString();
    if (widget.discountType == "percent") {
      _discountPercent.text = widget.discountPercent.toString();
      _maximumDiscount.text = widget.maximumDiscount.toString();
    } else if (widget.discountType == "amount") {
      _discountAmount.text = widget.discountAmount.toString();
    } else {
      _itemAdd.addAll(widget.item!);
    }
    for (var isiCarakerja in widget.caraKerja!) {
      _caraKerjaController.removeWhere((controller) => controller.text.isEmpty);
      _caraKerjaController.add(
        TextEditingController(text: isiCarakerja),
      );
    }

    for (var isiSyaratKetentuan in widget.syaratKetentuan!) {
      _sdanKetentuanController
          .removeWhere((controller) => controller.text.isEmpty);
      _sdanKetentuanController.add(
        TextEditingController(text: isiSyaratKetentuan),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    menu = MenuSubscriptionFunction().getAllMenuSubscription();
    addToController();
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
                      'Update Subscription Voucher',
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
                      behavior: NoGlow(),
                      child: SingleChildScrollView(
                        child: Form(
                          key: key,
                          child: Column(
                            children: [
                              Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Title Voucher',
                                    textEditingController: _voucherTitle,
                                    hintText: "Title Voucher...",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomGenerateCode(
                                    readOnly: true,
                                    title: 'Kode Voucher',
                                    textEditingController: _voucherCode,
                                    hintText: "Kode Voucher...",
                                    textInputType: TextInputType.none,
                                    onTap: () {
                                      setState(() {
                                        _voucherCode.text =
                                            generateRandomVoucherCode(11);
                                      });
                                    },
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Masa Berlaku',
                                    textEditingController: _masaBerlaku,
                                    hintText: "Masa Berlaku...",
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
                                  CustomDropdown(
                                    title: "Discount Type",
                                    data: _listDiscountType,
                                    hintText: "Select Discount Type",
                                    onChanged: (value) {
                                      setState(() {
                                        _discountType = value!;
                                      });
                                    },
                                    textNow: _discountType,
                                  ),
                                  _discountType == 'percent'
                                      ? CustomFormField(
                                          readOnly: false,
                                          title: 'Diskon Persen',
                                          textEditingController:
                                              _discountPercent,
                                          hintText: "Diskon Persen...",
                                          textInputType: TextInputType.number,
                                        )
                                      : _discountType == 'amount'
                                          ? CustomFormField(
                                              readOnly: false,
                                              title: 'Diskon Harga',
                                              textEditingController:
                                                  _discountAmount,
                                              hintText: "Diskon Harga...",
                                              textInputType:
                                                  TextInputType.number,
                                            )
                                          : ItemFormField(
                                              items: _itemAdd,
                                              onDelete: (int index) {
                                                setState(() {
                                                  _itemAdd.removeAt(index);
                                                });
                                              },
                                              title: 'Item',
                                              onTap: () {
                                                alertSemuaMenu();
                                              },
                                            ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Minimum Transaksi',
                                    textEditingController: _minimumPurchase,
                                    hintText: "Minimum Transaksi...",
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
                                  _discountType == 'percent'
                                      ? CustomFormField(
                                          readOnly: false,
                                          title: 'Maximal Discount',
                                          textEditingController:
                                              _maximumDiscount,
                                          hintText: "Maximal Discount...",
                                          textInputType: TextInputType.number,
                                        )
                                      : const SizedBox(),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Price',
                                    textEditingController: _price,
                                    hintText: "Price...",
                                    textInputType: TextInputType.number,
                                  ),
                                  _discountType == 'percent'
                                      ? const Expanded(
                                          child: SizedBox(),
                                        )
                                      : const SizedBox(),
                                  _discountType != 'percent'
                                      ? const Expanded(
                                          child: SizedBox(),
                                        )
                                      : const SizedBox(),
                                  _discountType != 'percent'
                                      ? const Expanded(
                                          child: SizedBox(),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  UploadOneImage(
                                    onTap: _pickImage,
                                    pickedImage: _pickedImage,
                                    webImage: webImage,
                                    updateORno: "update",
                                    imageDB: widget.image,
                                    pickedImageClear: () {
                                      _pickedImage = null;
                                    },
                                  ),
                                  ListFormField(
                                      title: "Syarat & Ketentuan",
                                      controller: _sdanKetentuanController),
                                  ListFormField(
                                      title: "Cara Pakai Voucher",
                                      controller: _caraKerjaController),
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
                                          title: "Update Voucher",
                                          onTap: () async {
                                            if (key.currentState!.validate()) {
                                              if (_uploading == false) {
                                                setState(() {
                                                  _uploading = true;
                                                });
                                                Reference referenceRoot =
                                                    FirebaseStorage.instance
                                                        .ref();
                                                Reference referenceDirImages =
                                                    referenceRoot
                                                        .child('voucher');
                                                Reference
                                                    referenceImageToUpload =
                                                    referenceDirImages.child(
                                                        "SNM-${_voucherCode.text}");
                                                if (_discountType == "item" &&
                                                    _itemAdd.isEmpty) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Pilih Item Dahulu');
                                                  return;
                                                }

                                                if (_pickedImage == null &&
                                                    widget.image == null) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Silahkan Pilih Gambar Terlebih Dahulu!');
                                                  return;
                                                }

                                                if (_pickedImage != null) {
                                                  try {
                                                    if (kIsWeb) {
                                                      // Store the file for web
                                                      await referenceImageToUpload
                                                          .putData(
                                                        webImage,
                                                        SettableMetadata(
                                                            contentType:
                                                                'image/jpeg'),
                                                      );
                                                    } else if (!kIsWeb) {
                                                      // Store the file for non-web (mobile, desktop)
                                                      await referenceImageToUpload
                                                          .putFile(File(
                                                              _pickedImage!
                                                                  .path));
                                                    }

                                                    // Success: get the download URL
                                                    imageUrl =
                                                        await referenceImageToUpload
                                                            .getDownloadURL();
                                                    imageName =
                                                        referenceImageToUpload
                                                            .toString();
                                                    FirebaseStorage.instance
                                                        .refFromURL(
                                                            widget.image!)
                                                        .delete();
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

                                                List<String> itemSyarat =
                                                    _sdanKetentuanController
                                                        .map((controller) =>
                                                            controller.text)
                                                        .where((itemText) =>
                                                            itemText.isNotEmpty)
                                                        .toList();
                                                List<String> itemCaraKerja =
                                                    _caraKerjaController
                                                        .map((controller) =>
                                                            controller.text)
                                                        .where((itemText) =>
                                                            itemText.isNotEmpty)
                                                        .toList();

                                                final String voucherCode =
                                                    "SNM-${_voucherCode.text}";
                                                try {
                                                  VoucherModel voucherModel =
                                                      VoucherModel(
                                                          "subscription");
                                                  VoucherGeneralLoyaltyModel
                                                      voucher =
                                                      VoucherGeneralLoyaltyModel(
                                                    limitPerDay: int.parse(
                                                        _limitPerDay.text
                                                            .trim()),
                                                    price: num.parse(
                                                        _price.text.trim()),
                                                    voucherTitle:
                                                        _voucherTitle.text,
                                                    voucherCode: voucherCode,
                                                    image: imageUrl,
                                                    masaBerlaku: num.parse(
                                                        _masaBerlaku.text
                                                            .trim()),
                                                    discountType: _discountType,
                                                    voucherType: 'subscription',
                                                    discountAmount:
                                                        _discountType ==
                                                                    "percent" ||
                                                                _discountType ==
                                                                    "item"
                                                            ? null
                                                            : num.parse(
                                                                _discountAmount
                                                                    .text
                                                                    .trim()),
                                                    discountPercent:
                                                        _discountType ==
                                                                    "amount" ||
                                                                _discountType ==
                                                                    "item"
                                                            ? null
                                                            : num.parse(
                                                                _discountPercent
                                                                    .text
                                                                    .trim()),
                                                    minimumPurchase: num.parse(
                                                        _minimumPurchase.text
                                                            .trim()),
                                                    maximumDiscount:
                                                        _discountType ==
                                                                    "amount" ||
                                                                _discountType ==
                                                                    "item"
                                                            ? null
                                                            : num.parse(
                                                                _maximumDiscount
                                                                    .text
                                                                    .trim()),
                                                    createdAt: DateFormat(
                                                            'yyyy-MM-dd HH:mm:ss')
                                                        .format(DateTime.now()),
                                                    caraKerja: itemCaraKerja,
                                                    syaratKetentuan: itemSyarat,
                                                    used: false,
                                                    item: _discountType ==
                                                                "amount" ||
                                                            _discountType ==
                                                                "percent"
                                                        ? null
                                                        : _itemAdd,
                                                  );
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
                                                    keterangan:
                                                        "Mengubah voucher subscription",
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

                                                  await historyLogFunction
                                                      .addHistory(history,
                                                          idDocHistory);
                                                  await voucherModel
                                                      .updateVoucher(
                                                          voucher, voucherCode);

                                                  setState(() {
                                                    _voucherTitle.clear();
                                                    _masaBerlaku.clear();
                                                    _voucherCode.clear();
                                                    _minimumPurchase.clear();
                                                    _discountPercent.clear();
                                                    _discountAmount.clear();
                                                    _price.clear();
                                                    _maximumDiscount.clear();
                                                    _pickedImage = null;
                                                    _itemAdd.clear();
                                                    _limitPerDay.clear();
                                                    clearControllers();
                                                  });
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.successToast(
                                                      context,
                                                      'Voucher berhasil diupdate!');
                                                } catch (error) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Voucher gagal diupdate!');
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
                                          onTap: () async {
                                            setState(() {
                                              _voucherTitle.clear();
                                              _masaBerlaku.clear();
                                              _voucherCode.clear();
                                              _minimumPurchase.clear();
                                              _discountPercent.clear();
                                              _discountAmount.clear();
                                              _price.clear();
                                              _maximumDiscount.clear();
                                              _limitPerDay.clear();
                                              _pickedImage = null;
                                              clearControllers();
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
