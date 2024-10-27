import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';

class TableMenuSalesGrandTotal extends StatefulWidget {
  final List data;
  const TableMenuSalesGrandTotal({super.key, required this.data});

  @override
  State<TableMenuSalesGrandTotal> createState() =>
      _TableMenuSalesGrandTotalState();
}

class _TableMenuSalesGrandTotalState extends State<TableMenuSalesGrandTotal> {
  @override
  Widget build(BuildContext context) {
    int totalQuantity = 0;
    num totalOriginalPrice = 0;
    num totalDiscount = 0;
    num totalAdditional = 0;
    num totalGrandTotal = 0;

    // Iterate through the data to calculate totals
    for (var order in widget.data) {
      if (order["transaction_status"] == "sukses") {
        for (var pesananItem in order['pesanan']) {
          final int quantity = pesananItem['quantity'];
          final num originalPrice = pesananItem['price'];
          final num discount = pesananItem['discount'];

          for (var addon in pesananItem["addons"]) {
            final int quantityAddon = addon['quantity'];
            final num priceAddon = addon['price'];
            totalAdditional += quantityAddon * priceAddon;
          }

          // Calculate total original price, discount, and grand total
          totalOriginalPrice += (originalPrice * quantity);
          totalDiscount += ((originalPrice * discount) * quantity);

          // Calculate total quantity
          totalQuantity += quantity;
        }
      }
    }
    totalGrandTotal = (totalOriginalPrice + totalAdditional) - totalDiscount;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.3, color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Menu Sales Number : ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    totalQuantity.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total menu sales : ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    CurrencyFormat.convertToIdr(totalOriginalPrice, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Additional Price : ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    CurrencyFormat.convertToIdr(totalAdditional, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(
            thickness: 0.3.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Discount : ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    CurrencyFormat.convertToIdr(totalDiscount, 0),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 16.sp, color: SonomaneColor.primary),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.3.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Grand Total : ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    CurrencyFormat.convertToIdr(totalGrandTotal, 0),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
