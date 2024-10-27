import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/dialog_add_to_cart.dart';

class CardCartPOS extends StatefulWidget {
  final String idDoc;
  final String idMenu;
  final String category;
  final String subcategory;
  final String menuName;
  final List addons;
  final String image;
  final num price;
  final num discount;
  final int quantity;
  final String noted;
  final BuildContext context;
  final String kitchenOrBar;
  final String codeBOM;
  const CardCartPOS({
    super.key,
    required this.idDoc,
    required this.idMenu,
    required this.category,
    required this.subcategory,
    required this.menuName,
    required this.addons,
    required this.image,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.context,
    required this.noted,
    required this.kitchenOrBar,
    required this.codeBOM,
  });

  @override
  State<CardCartPOS> createState() => _CardCartPOSState();
}

class _CardCartPOSState extends State<CardCartPOS> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0.h),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                autoClose: true,
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("menu")
                                .doc(widget.idMenu)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const SizedBox();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return DialogAddToCart(
                                idDoc: widget.idDoc,
                                idMenu: widget.idMenu,
                                addonsUpdate: widget.addons,
                                quantityUpdate: widget.quantity,
                                name: widget.menuName,
                                images: widget.image,
                                price: widget.price,
                                category: widget.category,
                                subcategory: widget.subcategory,
                                addons: data["addons"],
                                deskripsi: data["description"],
                                discount: widget.discount,
                                noted: widget.noted,
                                kitchenOrBar: widget.kitchenOrBar,
                                codeBOM: widget.codeBOM,
                              );
                            });
                      });
                },
                borderRadius: BorderRadius.circular(10.r),
                backgroundColor: SonomaneColor.blue.withOpacity(0.2),
                foregroundColor: SonomaneColor.blue,
                icon: Icons.edit,
              ),
              SlidableAction(
                autoClose: true,
                onPressed: (context) async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('cartspos')
                        .doc(widget.idDoc)
                        .delete();

                    // Check if the widget is mounted before showing the toast
                    if (mounted) {
                      CustomToast.successToast(
                          widget.context, "Berhasil menghapus dari keranjang");
                    }
                  } on FirebaseException catch (_) {
                    // Check if the widget is mounted before showing the toast
                    if (mounted) {
                      CustomToast.errorToast(
                          widget.context, "Gagal menghapus dari keranjang");
                    }
                  }
                },
                borderRadius: BorderRadius.circular(10.r),
                backgroundColor: SonomaneColor.primary.withOpacity(0.2),
                foregroundColor: SonomaneColor.primary,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
            height: 130.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 15.w,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    placeholder: (context, url) {
                      return Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.info_outline,
                          size: 24.sp,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.info_outline,
                          size: 24.sp,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                    },
                    imageUrl: widget.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.menuName.capitalize(),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          for (int i = 0; i < widget.addons.length; i++) ...{
                            Padding(
                              padding: EdgeInsets.only(right: 5.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 25.h,
                                decoration: BoxDecoration(
                                  color: SonomaneColor.primary.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.addons[i]['name']
                                          .toString()
                                          .capitalize(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color:
                                                  SonomaneColor.textTitleDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                CurrencyFormat.convertToIdr(widget.price, 2),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        decoration: widget.discount != 0
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        fontWeight: FontWeight.w600),
                              ),
                              widget.discount != 0
                                  ? Text(
                                      CurrencyFormat.convertToIdr(
                                          widget.price -
                                              (widget.price * widget.discount),
                                          2),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600))
                                  : const SizedBox(),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 18.0.w),
                            child: Text('${widget.quantity.toString()} x',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ),
                        ],
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
