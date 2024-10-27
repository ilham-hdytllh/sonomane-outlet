import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/dialog_add_to_cart.dart';

// ignore: must_be_immutable
class CardMenu extends StatelessWidget {
  String id;
  String name;
  String images;
  num price;
  String category;
  List addons;
  String deskripsi;
  num discount;
  String subcategory;
  String codeBOM;
  final String kitchenOrBar;
  CardMenu({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.images,
    required this.addons,
    required this.deskripsi,
    required this.subcategory,
    required this.discount,
    required this.codeBOM,
    required this.kitchenOrBar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return DialogAddToCart(
              idMenu: id,
              name: name,
              price: price,
              category: category,
              addons: addons,
              deskripsi: deskripsi,
              discount: discount,
              subcategory: subcategory,
              images: images,
              kitchenOrBar: kitchenOrBar,
              codeBOM: codeBOM,
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 0.5.w, color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(10.r),
        ),
        width: 182.w,
        height: 253.h,
        child: Column(
          children: [
            SizedBox(
              width: 182.w,
              height: 150.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      width: 182.w,
                      height: 152.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) {
                            return Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                Icons.info_outline,
                                size: 70.sp,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                Icons.info_outline,
                                size: 70.sp,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            );
                          },
                          imageUrl: images,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  (discount != 0)
                      ? Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            width: 65.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: SonomaneColor.primary.withOpacity(0.8),
                            ),
                            child: Center(
                              child: Text(
                                '${((discount) * 100).round().toString()} % off',
                                style: TextStyle(
                                    color: SonomaneColor.textTitleDark,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Text(
                name.toString().capitalize(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              CurrencyFormat.convertToIdr(price, 2),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    decoration:
                        discount == 0 ? null : TextDecoration.lineThrough,
                    fontWeight: FontWeight.w700,
                    fontSize: discount != 0 ? 11.sp : 14.sp,
                  ),
            ),
            (discount != 0)
                ? SizedBox(
                    height: 8.h,
                  )
                : const SizedBox(),
            (discount != 0)
                ? Text(
                    CurrencyFormat.convertToIdr(price - (price * discount), 2),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp),
                  )
                : const SizedBox(),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
