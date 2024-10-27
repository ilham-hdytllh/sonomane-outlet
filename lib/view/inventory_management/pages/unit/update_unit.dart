import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/inventory/satuan_inventory.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

// ignore: must_be_immutable
class UpdateUnit extends StatefulWidget {
  String? idDoc;
  String? unitName;
  String? unit;
  UpdateUnit({super.key, this.idDoc, this.unitName, this.unit});

  @override
  State<UpdateUnit> createState() => _UpdateUnitState();
}

class _UpdateUnitState extends State<UpdateUnit> {
  List<UpdateUnit> items = [];

  bool _uploading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _unitName = TextEditingController();
  final TextEditingController _unitCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    _unitName.text = widget.unitName ?? "";
    _unitCode.text = widget.idDoc ?? "";
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
                      "Update Unit",
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
                            direction: Axis.horizontal,
                            children: [
                              CustomFormField(
                                readOnly: true,
                                title: "Unit Code",
                                textEditingController: _unitCode,
                                hintText: "Unit Code...",
                                textInputType: TextInputType.text,
                              ),
                              CustomFormField(
                                readOnly: false,
                                title: "Unit Name",
                                textEditingController: _unitName,
                                hintText: "Unit Name...",
                                textInputType: TextInputType.text,
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
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
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _uploading = true;
                                          });

                                          DateTime dateTime = DateTime.now();

                                          String idDocHistory =
                                              "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";
                                          UnitModel unit = UnitModel(
                                            idDoc: widget.idDoc ?? "",
                                            unitCode: widget.idDoc ?? "",
                                            unitName: _unitName.text.trim(),
                                            status: true,
                                            createdAt:
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(dateTime),
                                            updatedAt:
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(dateTime),
                                          );

                                          HistoryLogModel history =
                                              HistoryLogModel(
                                            idDoc: idDocHistory,
                                            date: dateTime.day,
                                            month: dateTime.month,
                                            year: dateTime.year,
                                            dateTime: DateFormat(
                                                    'yyyy-MM-dd HH:mm:ss')
                                                .format(dateTime),
                                            keterangan: "Mengubah unit",
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
                                            await unit.updateUnit();
                                            await historyLogFunction.addHistory(
                                                history, idDocHistory);
                                            setState(() {
                                              _uploading = false;
                                              _unitName.clear();
                                            });

                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();

                                            // ignore: use_build_context_synchronously
                                            CustomToast.successToast(context,
                                                "Berhasil mengubah unit");
                                          } on FirebaseException catch (_) {
                                            setState(() {
                                              _uploading = false;
                                              _unitName.clear();
                                            });
                                            // ignore: use_build_context_synchronously
                                            CustomToast.errorToast(
                                                context, "Gagal mengubah unit");
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
                                      isLoading2: false,
                                      title: "Clear",
                                      onTap: _uploading == false
                                          ? () {
                                              setState(() {
                                                _unitName.clear();
                                              });
                                            }
                                          : () {},
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
