import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/cart/cart.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/custom_dropdown_notitle.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownWaiting.dart';
import 'package:sonomaneoutlet/shared_widget/formField_no_title.dart';
import 'package:sonomaneoutlet/shared_widget/outline_custom_button.dart';
import 'package:sonomaneoutlet/view/pos_management/pages/payment/payment_pos.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/card_cart_pos.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/dialog_list_table.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/summary_order.dart';

class CartPOS extends StatefulWidget {
  const CartPOS({super.key});

  @override
  State<CartPOS> createState() => _CartPOSState();
}

class _CartPOSState extends State<CartPOS> {
  int _numberof = 1;
  final TextEditingController _nameCustomer = TextEditingController();
  final TextEditingController _tableNumber = TextEditingController();
  final TextEditingController _discountAmount = TextEditingController();

  Stream? _streamCartPOS;
  Future? _getWaiter;
  String _selectedWaiter = "";
  String _salesType = "Dine In";
  num _discountBill = 0;

  void _refresh() {
    setState(() {
      _tableNumber.clear();
      _nameCustomer.clear();
      _discountAmount.clear();
      _salesType = "Dine In";
      _numberof = 1;
      _selectedWaiter = "";
    });
  }

  @override
  void initState() {
    super.initState();
    _streamCartPOS = CartModelFunction().getCart();
    _getWaiter = FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "waiter")
        .orderBy("name", descending: false)
        .get();
  }

  @override
  void dispose() {
    _tableNumber;
    _nameCustomer;
    _numberof = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 55.h,
          alignment: Alignment.centerLeft,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.r),
                topRight: Radius.circular(5.r),
              ),
              color: Theme.of(context).colorScheme.secondaryContainer),
          child: Padding(
            padding: EdgeInsets.only(left: 13.0.w),
            child: Text(
              "Transaksi",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlow(),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: CustomFormFieldNoTitle(
                      readOnly: false,
                      hintText: 'Customer Name',
                      textInputType: TextInputType.text,
                      textEditingController: _nameCustomer,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return TableList(
                                    textEditingController: _tableNumber,
                                  );
                                });
                          },
                          child: SizedBox(
                            width: 110.w,
                            height: 54.h,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.w,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.table_restaurant_sharp,
                                    size: 18.sp,
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Text(
                                    "Select Table",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Expanded(
                          child: CustomFormFieldNoTitle(
                            readOnly: true,
                            hintText: 'Table Number',
                            textInputType: TextInputType.none,
                            textEditingController: _tableNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: Container(
                      width: double.infinity,
                      height: 54.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.w,
                            color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 15.0.w),
                              child: Row(
                                children: [
                                  Text(
                                    _numberof.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    ('(Jumlah Orang)'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 210.w,
                            child: Row(
                              children: [
                                for (int a = 1; a < 5; a++) ...{
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _numberof = a;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 2.w),
                                      width: 30.w,
                                      decoration: BoxDecoration(
                                        color: _numberof != a
                                            ? Colors.transparent
                                            : SonomaneColor.primary,
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border: Border.all(
                                          width: 0.3.w,
                                          color: _numberof != a
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                              : SonomaneColor.primary,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          a.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontSize: 14.sp,
                                                color: _numberof != a
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .tertiary
                                                    : SonomaneColor
                                                        .textTitleDark,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                },
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _numberof++;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 2.w),
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                        width: 1.w,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 20.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_numberof <= 1) {
                                      null;
                                    } else {
                                      setState(() {
                                        --_numberof;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 2.w),
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                        width: 1.w,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.remove,
                                        size: 20.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: Row(
                      children: [
                        FutureBuilder(
                            future: _getWaiter,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasError) {
                                return Expanded(
                                    child: DropdownWaiting(
                                        hintText: "--Select Waiter--"));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Expanded(
                                    child: DropdownWaiting(
                                        hintText: "--Select Waiter--"));
                              } else if (snapshot.data.docs.isNotEmpty) {
                                List<String> data = [];
                                snapshot.data.docs.map((e) {
                                  data.add(e.data()['name']);
                                }).toList();
                                return CustomDropdownNoTitle(
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _selectedWaiter = value!;
                                    });
                                  },
                                  data: data,
                                  hintText: "--Select Waiter--",
                                );
                              } else {
                                return Expanded(
                                    child: DropdownWaiting(
                                        hintText: "--Select Waiter--"));
                              }
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 50.h,
                            child: _salesType != "Dine In"
                                ? OutlinedCustomButton(
                                    isLoading: false,
                                    title: "Dine In",
                                    onTap: () {
                                      setState(() {
                                        _salesType = "Dine In";
                                      });
                                    },
                                    color: SonomaneColor.primary,
                                    bgColor: SonomaneColor.primary,
                                  )
                                : CustomButton(
                                    isLoading: false,
                                    title: "Dine In",
                                    onTap: () {
                                      setState(() {
                                        _salesType = "Dine In";
                                      });
                                    },
                                    color: SonomaneColor.textTitleDark,
                                    bgColor: SonomaneColor.primary,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 50.h,
                            child: _salesType != "Delivery"
                                ? OutlinedCustomButton(
                                    isLoading: false,
                                    title: "Delivery",
                                    onTap: () {
                                      setState(() {
                                        _salesType = "Delivery";
                                      });
                                    },
                                    color: SonomaneColor.primary,
                                    bgColor: SonomaneColor.primary,
                                  )
                                : CustomButton(
                                    isLoading: false,
                                    title: "Delivery",
                                    onTap: () {
                                      setState(() {
                                        _salesType = "Delivery";
                                      });
                                    },
                                    color: SonomaneColor.textTitleDark,
                                    bgColor: SonomaneColor.primary,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /////////////////////////////////////////////////////////////////////
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomFormFieldNoTitle(
                            readOnly: false,
                            hintText: 'Discount e.g. 5000',
                            textInputType: TextInputType.number,
                            textEditingController: _discountAmount,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        SizedBox(
                          width: 100.w,
                          height: 60.h,
                          child: CustomButton(
                            isLoading: false,
                            title: "Apply",
                            onTap: () {
                              setState(() {
                                _discountBill = _discountAmount.text.isEmpty
                                    ? 0
                                    : num.parse(_discountAmount.text);
                              });
                            },
                            color: SonomaneColor.textTitleDark,
                            bgColor: SonomaneColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ////////////////////////////////////////////////////////////////////
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.w),
                    child: StreamBuilder(
                      stream: _streamCartPOS,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something when Erorr");
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 60.h,
                          );
                        } else if (snapshot.data.docs.isNotEmpty) {
                          List data = [];
                          snapshot.data.docs.map((e) {
                            Map a = e.data();
                            a['idDoc'] = e.id;
                            data.add(a);
                          }).toList();
                          return ListView.builder(
                              padding: EdgeInsets.all(0.w),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return CardCartPOS(
                                  idDoc: data[index]["idDoc"],
                                  idMenu: data[index]["idmenu"],
                                  menuName: data[index]["name"],
                                  addons: data[index]["addons"],
                                  image: data[index]["image"],
                                  price: data[index]["price"],
                                  discount: data[index]["discount"],
                                  quantity: data[index]["quantity"],
                                  context: context,
                                  category: data[index]["category"],
                                  subcategory: data[index]["subcategory"],
                                  noted: data[index]["noted"],
                                  kitchenOrBar: data[index]["kitchen_or_bar"],
                                  codeBOM: data[index]['codeBOM'],
                                );
                              });
                        } else {
                          return SizedBox(
                            height: 80.h,
                            child: Center(
                              child: Text("Tidak ada menu di keranjang.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp)),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SummaryOrder(
                    salesType: _salesType,
                    discountBill: _discountBill,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: OutlinedCustomButton(
                              isLoading: false,
                              title: "Cancel",
                              onTap: () async {
                                CartModelFunction cartDeleteAll =
                                    CartModelFunction();
                                try {
                                  //menghapus semua data state variabel
                                  await cartDeleteAll.deleteAllCart();
                                  setState(() {
                                    _nameCustomer.clear();
                                    _numberof = 1;
                                  });
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  CustomToast.errorToast(context, e.toString());
                                }
                              },
                              color: SonomaneColor.primary,
                              bgColor: SonomaneColor.primary,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: StreamBuilder(
                                stream: _streamCartPOS,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something when Erorr");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox(
                                      height: 110.h,
                                    );
                                  }

                                  List dataCart = snapshot.data.docs
                                      .map((e) => (e.data()))
                                      .toList();
                                  double sum = 0;
                                  double discount = 0;
                                  double totalAddons = 0;

                                  for (var i = 0; i < dataCart.length; i++) {
                                    sum += dataCart[i]['price'] *
                                        dataCart[i]['quantity'];
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

                                    for (var a = 0;
                                        a < dataCart[i]['addons'].length;
                                        a++) {
                                      totalAddons += dataCart[i]['addons'][a]
                                              ['price'] *
                                          dataCart[i]['quantity'];
                                    }
                                  }
                                  num totalSum = (sum + totalAddons) - discount;
                                  num servCharge = _salesType == "Dine In"
                                      ? totalSum * 0.05
                                      : 0;
                                  num ppn = (totalSum + servCharge) * 0.1;
                                  num totalakhir = totalSum + servCharge + ppn;

                                  return CustomButton(
                                    isLoading: false,
                                    title: "Pay",
                                    onTap: () {
                                      if (_tableNumber.text.isEmpty ||
                                          dataCart.isEmpty ||
                                          _selectedWaiter.isEmpty) {
                                        Notifikasi.erorAlert(context,
                                            'Anda belum memilih meja / menu');
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PaymentPOS(
                                              subtotal: sum,
                                              discount: discount,
                                              totalAddons: totalAddons,
                                              dataCart: dataCart,
                                              serviceCharge:
                                                  _salesType == "Dine In"
                                                      ? servCharge
                                                      : 0,
                                              ppn: ppn,
                                              totalAkhir: totalakhir,
                                              customerName:
                                                  _nameCustomer.text.trim(),
                                              waiterName: _selectedWaiter,
                                              tableNumber:
                                                  _tableNumber.text.trim(),
                                              guest: _numberof,
                                              refresh: _refresh,
                                              salesType: _salesType,
                                              discountBill: _discountBill,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    color: SonomaneColor.textTitleDark,
                                    bgColor: SonomaneColor.primary,
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
