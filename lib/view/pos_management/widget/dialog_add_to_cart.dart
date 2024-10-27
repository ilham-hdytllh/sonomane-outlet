import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/cart/cart.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/formField_no_title.dart';

// ignore: must_be_immutable
class DialogAddToCart extends StatefulWidget {
  String? idDoc;
  int? quantityUpdate;
  List? addonsUpdate;
  String? noted;
  final String idMenu;
  final String name;
  final String images;
  final num price;
  final String category;
  final String subcategory;
  final List addons;
  final String deskripsi;
  final num discount;
  final String kitchenOrBar;
  final String codeBOM;
  DialogAddToCart({
    super.key,
    this.idDoc,
    this.quantityUpdate,
    this.addonsUpdate,
    this.noted,
    required this.idMenu,
    required this.name,
    required this.images,
    required this.price,
    required this.category,
    required this.subcategory,
    required this.addons,
    required this.deskripsi,
    required this.discount,
    required this.kitchenOrBar,
    required this.codeBOM,
  });

  @override
  State<DialogAddToCart> createState() => _DialogAddToCartState();
}

class _DialogAddToCartState extends State<DialogAddToCart> {
  final TextEditingController _note = TextEditingController();
  final List _addons = [];
  int _quantity = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantityUpdate ?? 1;
    _addons.addAll(widget.addonsUpdate ?? []);
    _note.text = widget.noted ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGloww(),
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                size: 18.sp,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  right: 15.w, left: 15.w, top: 15.h, bottom: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CachedNetworkImage(
                              placeholder: (context, url) {
                                return Container(
                                  width: double.infinity,
                                  height: 200.h,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 80.sp,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  width: double.infinity,
                                  height: 200.h,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 80.sp,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                );
                              },
                              imageUrl: widget.images,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.name.capitalize(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.sp),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.discount != 0
                                    ? Text(
                                        CurrencyFormat.convertToIdr(
                                            widget.price, 0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: SonomaneColor.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp),
                                      )
                                    : const SizedBox(),
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      widget.price -
                                          (widget.price * widget.discount),
                                      0),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: SonomaneColor.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(widget.deskripsi.capitalizeSingle(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 14.sp)),
                        SizedBox(
                          height: 20.h,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 35.h,
                            width: 120.w,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_quantity > 1) {
                                      _quantity--;
                                      setState(() {});
                                    } else {
                                      null;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _quantity < 2
                                          ? Colors.transparent
                                          : SonomaneColor.primary,
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                          width: 1,
                                          color: SonomaneColor.primary),
                                    ),
                                    width: 35.h,
                                    height: 35.h,
                                    child: Icon(
                                      Icons.remove,
                                      size: 20.sp,
                                      color: _quantity < 2
                                          ? SonomaneColor.primary
                                          : SonomaneColor.textTitleDark,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 38.h,
                                  child: Center(
                                    child: Text(
                                      _quantity.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _quantity++;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: SonomaneColor.primary,
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                          width: 1,
                                          color: SonomaneColor.primary),
                                    ),
                                    width: 35.h,
                                    height: 35.h,
                                    child: Icon(
                                      Icons.add,
                                      size: 20.sp,
                                      color: SonomaneColor.textTitleDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Addons",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 20.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        widget.addons.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.all(0.w),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.addons.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 1.3,
                                              child: Checkbox(
                                                splashRadius: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r),
                                                ),
                                                activeColor:
                                                    SonomaneColor.primary,
                                                checkColor:
                                                    SonomaneColor.textTitleDark,
                                                value: _addons.any((element) =>
                                                    element["id"] ==
                                                    widget.addons[index]["id"]),
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (_addons.any((element) =>
                                                        element['id'] ==
                                                        widget.addons[index]
                                                            ['id'])) {
                                                      _addons.removeWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              widget.addons[
                                                                  index]['id']);
                                                      debugPrint(
                                                          _addons.toString());
                                                    } else {
                                                      _addons.add({
                                                        'id':
                                                            widget.addons[index]
                                                                ['id'],
                                                        'name':
                                                            widget.addons[index]
                                                                ['name'],
                                                        'price':
                                                            widget.addons[index]
                                                                ['price'],
                                                        'expanded': true,
                                                        'quantity': 1,
                                                      });
                                                      debugPrint(
                                                          _addons.toString());
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            Text(
                                              widget.addons[index]["name"]
                                                  .toString()
                                                  .capitalize(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120.w,
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                              widget.addons[index]["price"], 0),
                                          textAlign: TextAlign.right,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: SonomaneColor.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp),
                                        ),
                                      ),
                                    ],
                                  );
                                })
                            : SizedBox(
                                height: 100.h,
                                child: Text(
                                  "Tidak ada addon",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                ),
                              ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Notes",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 20.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: CustomFormFieldNoTitle(
                            readOnly: false,
                            hintText: "Notes for food...",
                            textInputType: TextInputType.text,
                            suffixIcon: Icons.edit_document,
                            textEditingController: _note,
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: SizedBox(
                            height: 55.h,
                            child: CustomButton(
                              isLoading: _isLoading,
                              bgColor: SonomaneColor.primary,
                              color: SonomaneColor.textTitleDark,
                              onTap: () async {
                                if (widget.idDoc == null) {
                                  if (_isLoading == false) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    String id = FirebaseFirestore.instance
                                        .collection('cartspos')
                                        .doc()
                                        .id;
                                    CartModel cartModel = CartModel(
                                        idCart: id,
                                        idMenu: widget.idMenu,
                                        name: widget.name,
                                        price: widget.price,
                                        discount: widget.discount,
                                        category: widget.category,
                                        subcategory: widget.subcategory,
                                        addons: _addons,
                                        quantity: _quantity,
                                        noted: _note.text.trim(),
                                        image: widget.images,
                                        codeBOM: widget.codeBOM,
                                        kitchenOrBar: widget.kitchenOrBar);
                                    CartModelFunction cartModelFunction =
                                        CartModelFunction();

                                    DateTime dateTime = DateTime.now();

                                    String idDocHistory =
                                        "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                    HistoryLogModel history = HistoryLogModel(
                                      idDoc: idDocHistory,
                                      date: dateTime.day,
                                      month: dateTime.month,
                                      year: dateTime.year,
                                      dateTime:
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(dateTime),
                                      keterangan:
                                          "Menambahkan menu kedalam keranjang",
                                      user: FirebaseAuth
                                              .instance.currentUser!.email ??
                                          "",
                                      type: "create",
                                    );

                                    HistoryLogModelFunction historyLogFunction =
                                        HistoryLogModelFunction(idDocHistory);
                                    try {
                                      await cartModelFunction.addCart(
                                          cartModel, id);

                                      await historyLogFunction.addHistory(
                                          history, idDocHistory);
                                      setState(() {
                                        _quantity = 1;
                                        _note.clear();
                                        _addons.clear();
                                        _isLoading = false;
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      // ignore: use_build_context_synchronously
                                      CustomToast.successToast(context,
                                          'Menu berhasil dimasukan kedalam keranjang!');
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                } else {
                                  if (_isLoading == false) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    CartModel cartModel = CartModel(
                                        idCart: widget.idDoc ?? "",
                                        idMenu: widget.idMenu,
                                        name: widget.name,
                                        price: widget.price,
                                        discount: widget.discount,
                                        category: widget.category,
                                        subcategory: widget.subcategory,
                                        addons: _addons,
                                        quantity: _quantity,
                                        noted: _note.text.trim(),
                                        image: widget.images,
                                        codeBOM: widget.codeBOM,
                                        kitchenOrBar: widget.kitchenOrBar);
                                    CartModelFunction cartModelFunction =
                                        CartModelFunction();

                                    DateTime dateTime = DateTime.now();

                                    String idDocHistory =
                                        "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                    HistoryLogModel history = HistoryLogModel(
                                      idDoc: idDocHistory,
                                      date: dateTime.day,
                                      month: dateTime.month,
                                      year: dateTime.year,
                                      dateTime:
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(dateTime),
                                      keterangan:
                                          "Mengubah menu didalam keranjang",
                                      user: FirebaseAuth
                                              .instance.currentUser!.email ??
                                          "",
                                      type: "update",
                                    );

                                    HistoryLogModelFunction historyLogFunction =
                                        HistoryLogModelFunction(idDocHistory);
                                    try {
                                      await cartModelFunction.updateCart(
                                          cartModel, widget.idDoc ?? "");

                                      await historyLogFunction.addHistory(
                                          history, idDocHistory);
                                      setState(() {
                                        _quantity = 1;
                                        _note.clear();
                                        _addons.clear();
                                        _isLoading = false;
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      // ignore: use_build_context_synchronously
                                      CustomToast.successToast(
                                          context, 'Menu berhasil diubah !');
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                }
                              },
                              title: widget.idDoc == null
                                  ? "Add to cart"
                                  : "Update cart",
                            ),
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
      ),
    );
  }
}
