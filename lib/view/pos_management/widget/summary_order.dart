import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/model/cart/cart.dart';

class SummaryOrder extends StatefulWidget {
  final String salesType;

  final num discountBill;
  const SummaryOrder(
      {super.key, required this.salesType, required this.discountBill});

  @override
  State<SummaryOrder> createState() => _SummaryOrderState();
}

class _SummaryOrderState extends State<SummaryOrder> {
  Stream? _streamCartPOS;

  @override
  void initState() {
    super.initState();
    _streamCartPOS = CartModelFunction().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //text penjelasan total
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sub Total :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Extra :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "Diskon :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Diskon Bill :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Total Setelah Diskon :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Serv Charge 5% :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Pajak 10% :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Total Bill :",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          //price and total
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: _streamCartPOS,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List dataCart =
                      snapshot.data.docs.map((e) => (e.data())).toList();
                  double sum = 0;
                  double discount = 0;
                  double totalAddons = 0;

                  for (var i = 0; i < dataCart.length; i++) {
                    sum += dataCart[i]['price'] * dataCart[i]['quantity'];
                    num cekNull() {
                      if (dataCart[i]['discount'] == null) {
                        return 0;
                      } else {
                        return dataCart[i]['discount'];
                      }
                    }

                    discount += dataCart[i]['price'] *
                        dataCart[i]['quantity'] *
                        cekNull();

                    for (var a = 0; a < dataCart[i]['addons'].length; a++) {
                      totalAddons += dataCart[i]['addons'][a]['price'] *
                          dataCart[i]['quantity'];
                    }
                  }
                  num totalSum =
                      (sum + totalAddons) - discount - widget.discountBill;
                  num servCharge =
                      widget.salesType == "Dine In" ? totalSum * 0.05 : 0;
                  num ppn = (totalSum + servCharge) * 0.1;
                  num totalakhir = totalSum + servCharge + ppn;
                  num discountBill = widget.discountBill;

                  return SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CurrencyFormat.convertToIdr(sum, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(totalAddons, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(-discount, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(-discountBill, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(totalSum, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(servCharge, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(ppn, 2),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(totalakhir, 2),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
