import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/inventory/item_inventory.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

// ignore: must_be_immutable
class UpdateConfigure extends StatefulWidget {
  String minimumPurchase;
  String cashbackPercent;
  UpdateConfigure(
      {super.key,
      required this.minimumPurchase,
      required this.cashbackPercent});

  @override
  State<UpdateConfigure> createState() => _UpdateConfigureState();
}

class _UpdateConfigureState extends State<UpdateConfigure> {
  List<ItemModel> items = [];

  bool _uploading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _minimumPurchase = TextEditingController();
  final TextEditingController _cashbackPercent = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minimumPurchase.text = widget.minimumPurchase;
    _cashbackPercent.text = widget.cashbackPercent;
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
                      "Update Configure Loyalty",
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
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.1.w,
                          color: Theme.of(context).colorScheme.outline),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
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
                                title: 'Minimum Purchase',
                                textEditingController: _minimumPurchase,
                                hintText: "Minimum Purchase...",
                                textInputType: TextInputType.number,
                              ),
                              CustomFormField(
                                readOnly: true,
                                title: 'Cashback Percent',
                                textEditingController: _cashbackPercent,
                                hintText: "Cashback Percent...",
                                textInputType: TextInputType.number,
                              ),
                              const Expanded(
                                child: SizedBox(),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 25.h,
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
                                      title: "Update",
                                      onTap: _uploading == false
                                          ? () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _uploading = true;
                                                });

                                                DateTime? dateTime =
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
                                                      "Mengubah setting loyalty",
                                                  user: FirebaseAuth.instance
                                                          .currentUser!.email ??
                                                      "",
                                                  type: "update",
                                                );

                                                HistoryLogModelFunction
                                                    historyLogFunction =
                                                    HistoryLogModelFunction(
                                                        idDocHistory);

                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          "settingLoyalty")
                                                      .doc("loyalty")
                                                      .update({
                                                    "minimumPurchase":
                                                        _minimumPurchase
                                                                .text.isNotEmpty
                                                            ? num.parse(
                                                                _minimumPurchase
                                                                    .text)
                                                            : 0,
                                                    "cashbackPercent":
                                                        _cashbackPercent
                                                                .text.isNotEmpty
                                                            ? num.parse(
                                                                _cashbackPercent
                                                                    .text)
                                                            : 0.05,
                                                  });
                                                  await historyLogFunction
                                                      .addHistory(history,
                                                          idDocHistory);
                                                  setState(() {
                                                    _uploading = false;
                                                    _cashbackPercent.clear();
                                                    _minimumPurchase.clear();
                                                  });

                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();

                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.successToast(
                                                      context,
                                                      "Berhasil mengubah mengubah setting loyalty");
                                                } on FirebaseException catch (_) {
                                                  setState(() {
                                                    _uploading = false;
                                                    _cashbackPercent.clear();
                                                    _minimumPurchase.clear();
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.errorToast(
                                                      context,
                                                      "Gagal mengubah setting loyalty");
                                                }
                                              }
                                            }
                                          : () {},
                                      color: SonomaneColor.containerLight,
                                      bgColor: SonomaneColor.primary),
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
