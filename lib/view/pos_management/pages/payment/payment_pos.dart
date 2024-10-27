import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_round500.dart';
import 'package:sonomaneoutlet/model/cart/cart.dart';
import 'package:sonomaneoutlet/model/order/order_model.dart';
import 'package:sonomaneoutlet/model/transaction/transaction.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
// import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
// import 'package:sonomaneoutlet/view/pos_management/pages/payment/qrcode_snap.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/card_cart_pos.dart';
import 'package:sonomaneoutlet/view/receipt/receipt_view.dart';

class PaymentPOS extends StatefulWidget {
  final num subtotal;
  final num discount;
  final num totalAddons;
  final List dataCart;
  final String customerName;
  final String waiterName;
  final String tableNumber;
  final int guest;
  final VoidCallback refresh;
  final num serviceCharge;
  final num ppn;
  final num totalAkhir;
  final String salesType;
  final num discountBill;
  const PaymentPOS(
      {super.key,
      required this.subtotal,
      required this.dataCart,
      required this.customerName,
      required this.waiterName,
      required this.tableNumber,
      required this.guest,
      required this.refresh,
      required this.discount,
      required this.totalAddons,
      required this.serviceCharge,
      required this.ppn,
      required this.totalAkhir,
      required this.salesType,
      required this.discountBill});

  @override
  State<PaymentPOS> createState() => _PaymentPOSState();
}

class _PaymentPOSState extends State<PaymentPOS> {
  String _selectPaymentMethod = "debit_bca";
  final List _paymentMethod = [
    {
      "id": 1,
      "image": "assets/images/bca.png",
      "name": "Debit BCA",
      "code": "debit_bca"
    },
    {
      "id": 2,
      "image": "assets/images/mandiri.png",
      "name": "Debit Mandiri",
      "code": "debit_mandiri"
    },
    {
      "id": 3,
      "image": "assets/images/bca.png",
      "name": "Credit BCA",
      "code": "cc_bca"
    },
    {
      "id": 4,
      "image": "assets/images/mandiri.png",
      "name": "Credit Mandiri",
      "code": "cc_mandiri"
    },
    {
      "id": 5,
      "image": "assets/images/go_food.png",
      "name": "Go Food",
      "code": "go_food"
    },
    {
      "id": 6,
      "image": "assets/images/grab_food.png",
      "name": "Grab Food",
      "code": "grab_food"
    },
    {
      "id": 7,
      "image": "assets/images/qris.png",
      "name": "Qris BCA",
      "code": "qris_bca"
    },
    {
      "id": 8,
      "image": "assets/images/qris.png",
      "name": "Qris Mandiri",
      "code": "qris_mandiri"
    }
  ];
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  final TextEditingController _duitBayar = TextEditingController();
  final List<String> _danaDiterima = [];
  final List<String> _numPad = [
    '7',
    '8',
    '9',
    '4',
    '5',
    '6',
    '1',
    '2',
    '3',
    '0',
    'C',
    '<-'
  ];
  Stream? _getCart;

  @override
  void initState() {
    super.initState();
    _getCart = CartModelFunction().getCart();
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
        padding: const EdgeInsets.only(top: 5),
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
                      'Summary Order',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.0.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height *
                                      0.652,
                                  child: StreamBuilder(
                                      stream: _getCart,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'something when eror');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        }
                                        final List cartData = [];
                                        snapshot.data!.docs.map((document) {
                                          Map a = document.data();
                                          cartData.add(a);
                                        }).toList();
                                        if (snapshot.data!.docs.isNotEmpty) {
                                          return ScrollConfiguration(
                                            behavior: NoGloww(),
                                            child: SingleChildScrollView(
                                              child: StaggeredGrid.count(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                children: [
                                                  for (int a = 0;
                                                      a < cartData.length;
                                                      a++) ...{
                                                    CardCartPOS(
                                                      idDoc: cartData[a]
                                                          ["idcart"],
                                                      idMenu: cartData[a]
                                                          ["idmenu"],
                                                      category: cartData[a]
                                                          ["category"],
                                                      subcategory: cartData[a]
                                                          ["subcategory"],
                                                      menuName: cartData[a]
                                                          ["name"],
                                                      addons: cartData[a]
                                                          ["addons"],
                                                      image: cartData[a]
                                                          ["image"],
                                                      price: cartData[a]
                                                          ["price"],
                                                      discount: cartData[a]
                                                          ["discount"],
                                                      quantity: cartData[a]
                                                          ["quantity"],
                                                      context: context,
                                                      noted: cartData[a]
                                                          ["noted"],
                                                      kitchenOrBar: cartData[a]
                                                          ["kitchen_or_bar"],
                                                      codeBOM: cartData[a]
                                                          ["codeBOM"],
                                                    ),
                                                  },
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                              'Tidak ada menu di keranjang.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(fontSize: 16.sp),
                                            ),
                                          );
                                        }
                                      }),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                              width: double.infinity,
                              height: 80.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total : ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.sp),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                num.parse(widget.totalAkhir
                                                        .toStringAsFixed(1))
                                                    .ceil(),
                                                2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total A/round (Cash only) : ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                roundUpToNearest500(
                                                    widget.totalAkhir),
                                                2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        width: 290.w,
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            SizedBox(
                              height: 50.h,
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                controller: _duitBayar,
                                readOnly: true,
                                cursorColor: Colors.transparent,
                                style: Theme.of(context).textTheme.titleMedium,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  hintStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  hintText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1.5.w),
                                  ),
                                  errorStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: SonomaneColor.primary),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1.5.w),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5.w,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1.5.w),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5.w,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: Center(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12.0,
                                      mainAxisSpacing: 12.0,
                                    ),
                                    itemCount: _numPad.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (_numPad[index] == 'C') {
                                            setState(() {
                                              _danaDiterima.clear();
                                              _duitBayar.clear();
                                            });
                                          } else if (_numPad[index] == '<-') {
                                            if (_danaDiterima.length <= 1) {
                                              setState(() {
                                                _danaDiterima.clear();
                                                _duitBayar.clear();
                                              });
                                            } else {
                                              setState(() {
                                                _danaDiterima.removeLast();

                                                _duitBayar.text = int.parse(
                                                        _danaDiterima.join(""))
                                                    .toString();
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _danaDiterima.add(_numPad[index]);

                                              _duitBayar.text = int.parse(
                                                      _danaDiterima.join(""))
                                                  .toString();
                                            });
                                          }
                                        },
                                        child: ClipRRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer),
                                            child: Center(
                                              child: Text(
                                                _numPad[index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 60.h,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      SonomaneColor.primary),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                onPressed: () async {
                                  if (isLoading == true ||
                                      isLoading1 == true ||
                                      isLoading2 == true) {
                                    null;
                                  } else {
                                    setState(() {
                                      isLoading2 = true;
                                    });

                                    /// masukan fungsi pembayaran pakai edc
                                    await paymentAfterEat(
                                        num.parse(widget.totalAkhir
                                                .toStringAsFixed(1))
                                            .ceil(),
                                        widget.serviceCharge,
                                        widget.ppn,
                                        widget.dataCart,
                                        widget.subtotal,
                                        widget.totalAddons,
                                        widget.discount);
                                    setState(() {
                                      isLoading2 = false;
                                    });
                                  }
                                },
                                child: isLoading2 == false
                                    ? Text(
                                        "Pay after eat",
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontSize: 14.sp,
                                                color: SonomaneColor
                                                    .textTitleDark),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: SonomaneColor.textTitleDark,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 15.w,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.h,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                SonomaneColor.primary),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer,
                                                  content: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: ScrollConfiguration(
                                                      behavior: NoGloww(),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        _paymentMethod
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            _selectPaymentMethod =
                                                                                _paymentMethod[index]["name"];
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              60.h,
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical: 5.h,
                                                                              horizontal: 10.w),
                                                                          decoration: BoxDecoration(
                                                                              color: _selectPaymentMethod == _paymentMethod[index]["name"] ? SonomaneColor.primary.withOpacity(0.2) : Colors.transparent,
                                                                              borderRadius: BorderRadius.circular(16.r),
                                                                              border: Border.all(width: 1, color: _selectPaymentMethod == _paymentMethod[index]["name"] ? SonomaneColor.primary : Theme.of(context).colorScheme.outline)),
                                                                          child:
                                                                              ListTile(
                                                                            leading:
                                                                                SizedBox(
                                                                              width: 60.w,
                                                                              child: Image.asset(
                                                                                _paymentMethod[index]["image"],
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                            title:
                                                                                Text(
                                                                              _paymentMethod[index]["name"],
                                                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),
                                                                            ),
                                                                            trailing:
                                                                                Transform.scale(
                                                                              scale: 1,
                                                                              child: Checkbox(
                                                                                splashRadius: 0,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(3.r),
                                                                                ),
                                                                                activeColor: SonomaneColor.primary,
                                                                                checkColor: SonomaneColor.textTitleDark,
                                                                                value: (_selectPaymentMethod == _paymentMethod[index]["name"]),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    _selectPaymentMethod = _paymentMethod[index]["name"];
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                          SizedBox(
                                                            height: 8.h,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.h,
                                                                    horizontal:
                                                                        10.w),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 60.h,
                                                              child:
                                                                  CustomButton(
                                                                      isLoading:
                                                                          isLoading,
                                                                      title:
                                                                          "Lanjut Bayar",
                                                                      onTap:
                                                                          () async {
                                                                        if (isLoading ==
                                                                                true ||
                                                                            isLoading1 ==
                                                                                true) {
                                                                          null;
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                true;
                                                                          });
                                                                          await paymentOther(
                                                                              num.parse(widget.totalAkhir.toStringAsFixed(1)).ceil(),
                                                                              widget.serviceCharge,
                                                                              widget.ppn,
                                                                              widget.dataCart,
                                                                              widget.subtotal,
                                                                              widget.totalAddons,
                                                                              widget.discount,
                                                                              widget.discountBill);
                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                false;
                                                                          });
                                                                        }
                                                                      },
                                                                      color: SonomaneColor
                                                                          .textTitleDark,
                                                                      bgColor:
                                                                          SonomaneColor
                                                                              .primary),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            });
                                      },
                                      child: isLoading1 == false
                                          ? Text(
                                              "Other",
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontSize: 14.sp,
                                                      color: SonomaneColor
                                                          .textTitleDark),
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    SonomaneColor.textTitleDark,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.h,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                SonomaneColor.primary),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      onPressed: () async {
                                        if (isLoading == true ||
                                            isLoading1 == true) {
                                          null;
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (_duitBayar.text.isEmpty) {
                                            Notifikasi.erorAlert(context,
                                                "Anda belum menginput nominal pembayaran !.");
                                          } else {
                                            if (_duitBayar.text.isEmpty) {
                                              Notifikasi.erorAlert(context,
                                                  "Anda Belum Memasukkan Nominal !");
                                            } else if (int.parse(
                                                    _duitBayar.text) <
                                                (roundUpToNearest500(num.parse(
                                                        widget.totalAkhir
                                                            .toStringAsFixed(1))
                                                    .ceil()))) {
                                              Notifikasi.erorAlert(context,
                                                  "Nominal Pembayaran Kurang !");
                                            } else {
                                              await paymentTunai(
                                                  num.parse(widget.totalAkhir
                                                          .toStringAsFixed(1))
                                                      .ceil(),
                                                  widget.serviceCharge,
                                                  widget.ppn,
                                                  widget.dataCart,
                                                  int.parse(_duitBayar.text),
                                                  widget.subtotal,
                                                  widget.totalAddons,
                                                  widget.discount,
                                                  widget.discountBill);
                                            }
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                      child: isLoading == false
                                          ? Text(
                                              "Cash",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontSize: 14.sp,
                                                      color: SonomaneColor
                                                          .textTitleDark),
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    SonomaneColor.textTitleDark,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Future<int> ambilOrderanMeja(String tablenumber) async {
    List<Map<String, dynamic>> orders = [];
    await FirebaseFirestore.instance
        .collection('tables')
        .doc(tablenumber)
        .collection('orders')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        Map<String, dynamic> data = doc.data();
        orders.add(data);
      }
    });

    int a = orders.isEmpty ? 0 : orders.length;

    return a;
  }

  //payment after eat
  paymentAfterEat(num totalAkhir, num servCharge, num ppn, List dataCart,
      num subTotal, num totalAddon, num totalDiskon) async {
    int jumlah = await ambilOrderanMeja(widget.tableNumber);
    String tableOrderId = '${widget.tableNumber}#${jumlah + 1}';
    String orderID = "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

    OrderModel order = OrderModel(
      waiter: widget.waiterName,
      cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
      customerName: widget.customerName,
      guest: widget.guest,
      grossAmount: roundUpToNearest500(totalAkhir),
      subTotal: subTotal,
      totalAddon: totalAddon,
      totalDiskonMenu: totalDiskon,
      serviceCharge: servCharge,
      tax: ppn,
      round: roundUpToNearest500(totalAkhir) - totalAkhir,
      pesanan: dataCart,
      totalVoucher: 0,
      tableNumber: widget.tableNumber,
      orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.now(),
      ),
      orderId: orderID,
      orderStatus: 'Dimasak',
      orderType: 'POS',
      paymentStatus: 'belum dibayar',
      salesType: widget.salesType,
      tableOrderId: tableOrderId,
      uid: [],
      tokenFCM: [],
    );

    try {
      for (var data in dataCart) {
        String kodeBOM = data["codeBOM"];
        num qtyMenu = data["quantity"];

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("billOfMaterial")
            .doc(kodeBOM)
            .get();

        // Check if the document exists
        if (documentSnapshot.exists) {
          // Get the items field from the document
          List<Map<String, dynamic>> items =
              List.from(documentSnapshot["itemsBOM"]);

          String place = documentSnapshot["place"];

          // Loop through items and update Firestore stock
          for (var item in items) {
            String itemCode = item["itemCode"];

            String itemName = item["itemName"];

            String unit = item["unit"];

            num gross = item["gross"];

            String date =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

            String idDoc = FirebaseFirestore.instance
                .collection('adjustmentStock')
                .doc()
                .id;

            // Update Firestore stock here (replace 'yourStockCollection' with your actual collection)
            await FirebaseFirestore.instance
                .collection('adjustmentStock')
                .doc(idDoc)
                .set({
              "id": idDoc,
              'quantity': gross * qtyMenu,
              "itemName": itemName,
              "itemCode": itemCode,
              "status": "input",
              "type": "out",
              "place": place,
              "unit": unit,
              "date": date,
              "bom": true,
            });
          }
        }
      }

      await OrderFunction(tableNumber: widget.tableNumber)
          .addOrder(order, tableOrderId);

      await OrderFunction.addCartItemsInCollection(
          widget.tableNumber, tableOrderId, dataCart);

      await FirebaseFirestore.instance
          .collection('cartspos')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      widget.refresh();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      // ignore: use_build_context_synchronously
      Notifikasi.successAlert(context, "Order Sukses");
    } catch (eror) {
      // ignore: use_build_context_synchronously
      CustomToast.errorToast(context, eror.toString());
    }
  }

  //payment by cash
  paymentTunai(
      num totalAkhir,
      num servCharge,
      num ppn,
      List dataCart,
      int uangDiterima,
      num subTotal,
      num totalAddon,
      num totalDiskon,
      num discountBill) async {
    int jumlah = await ambilOrderanMeja(widget.tableNumber);
    String tableOrderId = '${widget.tableNumber}#${jumlah + 1}';
    String orderID = "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";
    String transactionID =
        "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

    OrderModel order = OrderModel(
      waiter: widget.waiterName,
      cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
      customerName: widget.customerName,
      guest: widget.guest,
      grossAmount: roundUpToNearest500(totalAkhir),
      subTotal: subTotal,
      totalAddon: totalAddon,
      totalDiskonMenu: totalDiskon,
      serviceCharge: servCharge,
      tax: ppn,
      round: roundUpToNearest500(totalAkhir) - totalAkhir,
      pesanan: dataCart,
      totalVoucher: 0,
      tableNumber: widget.tableNumber,
      orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.now(),
      ),
      orderId: orderID,
      orderStatus: 'Dimasak',
      orderType: 'POS',
      paymentStatus: 'telah dibayar',
      salesType: widget.salesType,
      tableOrderId: tableOrderId,
      uid: [],
      tokenFCM: [],
    );

    TransactionModel transaction = TransactionModel(
      waiter: widget.waiterName,
      cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
      customerName: widget.customerName,
      guest: widget.guest,
      grossAmount: roundUpToNearest500(totalAkhir),
      subTotal: subTotal,
      totalAddon: totalAddon,
      totalDiskonMenu: totalDiskon,
      serviceCharge: servCharge,
      tax: ppn,
      round: roundUpToNearest500(totalAkhir) - totalAkhir,
      pesanan: dataCart,
      totalVoucher: 0,
      tableNumber: widget.tableNumber,
      paymentStatus: 'telah dibayar',
      salesType: widget.salesType,
      tableOrderId: tableOrderId,
      paymentType: 'tunai',
      transactionTime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.now(),
      )} +07:00",
      transactionStatus: 'sukses',
      cashAccept: uangDiterima,
      change: uangDiterima - roundUpToNearest500(totalAkhir),
      transactionId: transactionID,
      uid: [],
      tokenFCM: [],
      combineORno: false,
      discountBill: discountBill,
    );

    try {
      for (var data in dataCart) {
        String kodeBOM = data["codeBOM"];
        num qtyMenu = data["quantity"];

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("billOfMaterial")
            .doc(kodeBOM)
            .get();

        // Check if the document exists
        if (documentSnapshot.exists) {
          // Get the items field from the document
          List<Map<String, dynamic>> items =
              List.from(documentSnapshot["itemsBOM"]);

          String place = documentSnapshot["place"];

          // Loop through items and update Firestore stock
          for (var item in items) {
            String itemCode = item["itemCode"];

            String itemName = item["itemName"];

            String unit = item["unit"];

            num gross = item["gross"];

            String date =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

            String idDoc = FirebaseFirestore.instance
                .collection('adjustmentStock')
                .doc()
                .id;

            // Update Firestore stock here (replace 'yourStockCollection' with your actual collection)
            await FirebaseFirestore.instance
                .collection('adjustmentStock')
                .doc(idDoc)
                .set({
              "id": idDoc,
              'quantity': gross * qtyMenu,
              "itemName": itemName,
              "itemCode": itemCode,
              "status": "input",
              "type": "out",
              "place": place,
              "unit": unit,
              "date": date,
              "bom": true,
            });
          }
        }
      }

      await TransactionFunction().addTransaction(transaction, transactionID);

      await OrderFunction(tableNumber: widget.tableNumber)
          .addOrder(order, tableOrderId);

      await OrderFunction.addCartItemsInCollection(
          widget.tableNumber, tableOrderId, dataCart);

      await FirebaseFirestore.instance
          .collection('cartspos')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await Future.delayed(const Duration(seconds: 4), () {
        // ignore: use_build_context_synchronously
        Notifikasi.successAlert(context, "Pembayaran Sukses");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ScreenInvoice(
                  datetime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
                    DateTime.now(),
                  )} +07:00",
                  customerName: widget.customerName,
                  waiterName: widget.waiterName,
                  tableNumber: widget.tableNumber,
                  cashierName: FirebaseAuth.instance.currentUser!.email!
                      .split("@")
                      .first,
                  pesanan: dataCart,
                  servCharge: servCharge,
                  tax: ppn,
                  round: roundUpToNearest500(totalAkhir) - totalAkhir,
                  totalBill: roundUpToNearest500(totalAkhir) -
                      (roundUpToNearest500(totalAkhir) - totalAkhir),
                  grandTotal: roundUpToNearest500(totalAkhir),
                  subTotal: roundUpToNearest500(totalAkhir) -
                      (roundUpToNearest500(totalAkhir) - totalAkhir) -
                      ppn -
                      servCharge,
                  refresh: widget.refresh,
                  transactionid: transactionID,
                  cashaccept: uangDiterima,
                  totalVoucher: 0,
                  discountBill: discountBill,
                )));
        widget.refresh();
        setState(() {
          _duitBayar.clear();
          _danaDiterima.clear();
        });
      });
    } catch (eror) {
      // ignore: use_build_context_synchronously
      CustomToast.errorToast(context, eror.toString());
    }
  }

  paymentOther(num totalAkhir, num servCharge, num ppn, List dataCart,
      num subTotal, num totalAddon, num totalDiskon, num discountBill) async {
    int jumlah = await ambilOrderanMeja(widget.tableNumber);
    String tableOrderId = '${widget.tableNumber}#${jumlah + 1}';
    String orderID = "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";
    String transactionID =
        "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

    OrderModel order = OrderModel(
      waiter: widget.waiterName,
      cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
      customerName: widget.customerName,
      guest: widget.guest,
      grossAmount: totalAkhir,
      subTotal: subTotal,
      totalAddon: totalAddon,
      totalDiskonMenu: totalDiskon,
      serviceCharge: servCharge,
      tax: ppn,
      round: 0,
      pesanan: dataCart,
      totalVoucher: 0,
      tableNumber: widget.tableNumber,
      orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.now(),
      ),
      orderId: orderID,
      orderStatus: 'Dimasak',
      orderType: 'POS',
      paymentStatus: 'telah dibayar',
      salesType: widget.salesType,
      tableOrderId: tableOrderId,
      uid: [],
      tokenFCM: [],
    );

    TransactionModel transaction = TransactionModel(
        waiter: widget.waiterName,
        cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
        customerName: widget.customerName,
        guest: widget.guest,
        grossAmount: totalAkhir,
        subTotal: subTotal,
        totalAddon: totalAddon,
        totalDiskonMenu: totalDiskon,
        serviceCharge: servCharge,
        tax: ppn,
        round: 0,
        pesanan: dataCart,
        totalVoucher: 0,
        tableNumber: widget.tableNumber,
        paymentStatus: 'telah dibayar',
        salesType: widget.salesType,
        tableOrderId: tableOrderId,
        paymentType: _selectPaymentMethod,
        transactionTime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.now(),
        )} +07:00",
        transactionStatus: 'sukses',
        transactionId: transactionID,
        uid: [],
        tokenFCM: [],
        combineORno: false,
        discountBill: discountBill);

    try {
      for (var data in dataCart) {
        String kodeBOM = data["codeBOM"];
        num qtyMenu = data["quantity"];

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("billOfMaterial")
            .doc(kodeBOM)
            .get();

        // Check if the document exists
        if (documentSnapshot.exists) {
          // Get the items field from the document
          List<Map<String, dynamic>> items =
              List.from(documentSnapshot["itemsBOM"]);

          String place = documentSnapshot["place"];

          // Loop through items and update Firestore stock
          for (var item in items) {
            String itemCode = item["itemCode"];

            String itemName = item["itemName"];

            String unit = item["unit"];

            num gross = item["gross"];

            String date =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

            String idDoc = FirebaseFirestore.instance
                .collection('adjustmentStock')
                .doc()
                .id;

            // Update Firestore stock here (replace 'yourStockCollection' with your actual collection)
            await FirebaseFirestore.instance
                .collection('adjustmentStock')
                .doc(idDoc)
                .set({
              "id": idDoc,
              'quantity': gross * qtyMenu,
              "itemName": itemName,
              "itemCode": itemCode,
              "status": "input",
              "type": "out",
              "place": place,
              "unit": unit,
              "date": date,
              "bom": true,
            });
          }
        }
      }

      await TransactionFunction().addTransaction(transaction, transactionID);

      await OrderFunction(tableNumber: widget.tableNumber)
          .addOrder(order, tableOrderId);

      await OrderFunction.addCartItemsInCollection(
          widget.tableNumber, tableOrderId, dataCart);

      await FirebaseFirestore.instance
          .collection('cartspos')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await Future.delayed(const Duration(seconds: 4), () {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop();
        // ignore: use_build_context_synchronously
        Notifikasi.successAlert(context, "Pembayaran Sukses");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ScreenInvoice(
                  datetime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
                    DateTime.now(),
                  )} +07:00",
                  customerName: widget.customerName,
                  waiterName: widget.waiterName,
                  tableNumber: widget.tableNumber,
                  cashierName: FirebaseAuth.instance.currentUser!.email!
                      .split("@")
                      .first,
                  pesanan: dataCart,
                  servCharge: servCharge,
                  tax: ppn,
                  round: 0,
                  totalBill: totalAkhir,
                  grandTotal: totalAkhir,
                  subTotal: totalAkhir - ppn - servCharge,
                  refresh: widget.refresh,
                  transactionid: transactionID,
                  totalVoucher: 0,
                  discountBill: discountBill,
                )));
        widget.refresh();
        setState(() {
          _selectPaymentMethod == "debit_bca";
        });
      });
    } catch (eror) {
      // ignore: use_build_context_synchronously
      CustomToast.errorToast(context, eror.toString());
    }
  }

  //payment by midtrans
  // paymentMidtrans(num totalAkhir, num servCharge, num ppn, List dataCart,
  //     num subTotal, num totalAddon, num totalDiskon) async {
  //   int jumlah = await ambilOrderanMeja(widget.tableNumber);
  //   String tableOrderId = '${widget.tableNumber}#${jumlah + 1}';
  //   String transactionID =
  //       "MNU_${DateTime.now().millisecondsSinceEpoch.toString()}";

  //   TransactionModel transaction = TransactionModel(
  //     combineORno: false,
  //     waiter: widget.waiterName,
  //     cashier: FirebaseAuth.instance.currentUser!.email!.split("@").first,
  //     customerName: widget.customerName,
  //     guest: widget.guest,
  //     grossAmount: totalAkhir,
  //     subTotal: subTotal,
  //     totalAddon: totalAddon,
  //     totalDiskonMenu: totalDiskon,
  //     serviceCharge: servCharge,
  //     tax: ppn,
  //     round: 0,
  //     pesanan: dataCart,
  //     totalVoucher: 0,
  //     tableNumber: widget.tableNumber,
  //     paymentStatus: 'belum dibayar',
  //     salesType: widget.salesType,
  //     tableOrderId: tableOrderId,
  //     paymentType: 'payment gateway',
  //     transactionTime: "${DateFormat('yyyy-MM-dd HH:mm:ss').format(
  //       DateTime.now(),
  //     )} +07:00",
  //     transactionStatus: 'pending',
  //     transactionId: transactionID,
  //     uid: [],
  //     tokenFCM: [],
  //   );

  //   try {
  //     // hapus semua keranjang
  //     await FirebaseFirestore.instance
  //         .collection('cartspos')
  //         .get()
  //         .then((snapshot) {
  //       for (DocumentSnapshot ds in snapshot.docs) {
  //         ds.reference.delete();
  //       }
  //     });

  //     // ignore: use_build_context_synchronously
  //     final response = await apiBaseHelper.post(
  //       "$baseUrl/transaction/snap-pos",
  //       transaction.toMap(),
  //       context,
  //     );

  //     if (response["status_code"] == 200) {
  //       await OrderFunction.addCartItemsInCollection(
  //           widget.tableNumber, tableOrderId, dataCart);
  //       Map<String, dynamic> callback = response["data"];
  //       // ignore: use_build_context_synchronously
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) =>
  //             QrcodeSnap(data: callback, refresh: widget.refresh),
  //       ));
  //       debugPrint(callback["transactionRedirectUrl"]);
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       Notifikasi.erorAlert(context, "Transaksi Gagal");
  //     }

  //     // _virtualpages(
  //     //   hasil: response['redirectURL'].toString(),
  //     //   orderid: response['transaction_id'].toString(),
  //     //   grossamount:
  //     //       CurrencyFormat.convertToIdr(response['gross_amount'], 2).toString(),
  //     // );

  //     widget.refresh;
  //   } catch (eror) {
  //     // ignore: use_build_context_synchronously
  //     CustomToast.errorToast(context, "Terjadi kesalahan");
  //   }
  // }
}
