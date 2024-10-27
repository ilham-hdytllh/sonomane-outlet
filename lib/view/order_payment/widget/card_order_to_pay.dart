import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class CardOrderToPay extends StatelessWidget {
  final String tableOrderid;
  final String ordertime;
  final List pesanan;
  final List? semuaOrder;
  final String name;
  final String paymentstatus;
  final num totalVoucher;
  const CardOrderToPay(
      {super.key,
      required this.tableOrderid,
      required this.ordertime,
      required this.pesanan,
      this.semuaOrder,
      required this.name,
      required this.paymentstatus,
      required this.totalVoucher});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1.w, color: Theme.of(context).colorScheme.outline),
            color: semuaOrder!
                    .any((element) => element['tableOrder_id'] == tableOrderid)
                ? SonomaneColor.primary
                : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order $tableOrderid",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: semuaOrder!.any((element) =>
                                element['tableOrder_id'] == tableOrderid)
                            ? SonomaneColor.textTitleDark
                            : Theme.of(context).colorScheme.tertiary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    name.toString().capitalize(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: semuaOrder!.any((element) =>
                                element['tableOrder_id'] == tableOrderid)
                            ? SonomaneColor.textTitleDark
                            : Theme.of(context).colorScheme.tertiary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                ordertime,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: semuaOrder!.any((element) =>
                              element['tableOrderid'] == tableOrderid)
                          ? SonomaneColor.textTitleDark
                          : Theme.of(context).colorScheme.tertiary,
                    ),
              ),
              SizedBox(
                height: 10.h,
              ),
              for (int b = 0; b < pesanan.length; b++) ...{
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: paymentstatus == 'telah dibayar'
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                      Colors.grey, BlendMode.saturation),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) {
                                      return Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        child: Icon(
                                          Icons.info_outline,
                                          size: 28.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
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
                                          size: 28.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      );
                                    },
                                    imageUrl: pesanan[b]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : CachedNetworkImage(
                                  placeholder: (context, url) {
                                    return Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 28.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
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
                                        size: 28.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    );
                                  },
                                  imageUrl: pesanan[b]['image'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pesanan[b]['name'].toString().capitalize(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: semuaOrder!.any((element) =>
                                            element['tableOrderid'] ==
                                            tableOrderid)
                                        ? SonomaneColor.textTitleDark
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                  ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int x = 0;
                                      x < pesanan[b]['addons'].length;
                                      x++) ...{
                                    pesanan[b]['addons'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 2.w),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w, vertical: 3.h),
                                            decoration: BoxDecoration(
                                              color: semuaOrder!.any((element) =>
                                                      element['tableOrderid'] ==
                                                      tableOrderid)
                                                  ? SonomaneColor.textTitleDark
                                                  : paymentstatus ==
                                                          'telah dibayar'
                                                      ? SonomaneColor
                                                          .scaffoldColorDark
                                                          .withOpacity(0.7)
                                                      : SonomaneColor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10.r,
                                              ),
                                            ),
                                            child: Text(
                                              pesanan[b]['addons'][x]['name'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: semuaOrder!.any(
                                                            (element) =>
                                                                element[
                                                                    'tableOrderid'] ==
                                                                tableOrderid)
                                                        ? SonomaneColor.primary
                                                        : SonomaneColor
                                                            .textTitleDark,
                                                  ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  }
                                ],
                              ),
                            ),
                            pesanan[b]['discount'] != 0
                                ? Text(
                                    CurrencyFormat.convertToIdr(
                                        pesanan[b]['price'], 2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: semuaOrder!.any((element) =>
                                                  element['tableOrderid'] ==
                                                  tableOrderid)
                                              ? SonomaneColor.textTitleDark
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                        ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      pesanan[b]['discount'] == 0
                                          ? pesanan[b]['price']
                                          : pesanan[b]['price'] -
                                              (pesanan[b]['price'] *
                                                  pesanan[b]['discount']),
                                      2),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: semuaOrder!.any((element) =>
                                                element['tableOrderid'] ==
                                                tableOrderid)
                                            ? SonomaneColor.textTitleDark
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                      ),
                                ),
                                Text(
                                  "Qty : ${pesanan[b]['quantity']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: semuaOrder!.any((element) =>
                                                element['tableOrderid'] ==
                                                tableOrderid)
                                            ? SonomaneColor.textTitleDark
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              },
              SizedBox(
                height: 10.h,
              ),
              DottedLine(
                dashColor: Theme.of(context).colorScheme.tertiary,
                lineThickness: 2,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                    "Voucher   :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(totalVoucher, 0),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
        paymentstatus == 'telah dibayar'
            ? Positioned(
                top: 15,
                right: 15,
                child: Image.asset(
                  "assets/images/stempelpembayaran.png",
                  fit: BoxFit.cover,
                  width: 140,
                  height: 140,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
