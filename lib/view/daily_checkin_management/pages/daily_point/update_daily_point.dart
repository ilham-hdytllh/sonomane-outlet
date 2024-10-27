import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/daily_checkin/daily_point.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class UpdateDailyPoint extends StatefulWidget {
  final String idDoc;
  final String day;
  final int point;
  const UpdateDailyPoint({
    super.key,
    required this.idDoc,
    required this.day,
    required this.point,
  });

  @override
  State<UpdateDailyPoint> createState() => _UpdateDailyPointState();
}

class _UpdateDailyPointState extends State<UpdateDailyPoint> {
  bool _uploading = false;

  GlobalKey<FormState> key = GlobalKey();
  final TextEditingController _day = TextEditingController();
  final TextEditingController _point = TextEditingController();

  @override
  void initState() {
    super.initState();
    _day.text = widget.day;
    _point.text = widget.point.toString();
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
                      'Update Daily Checkin Coint',
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
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.1.w,
                          color: Theme.of(context).colorScheme.outline),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                    child: ScrollConfiguration(
                      behavior: NoGlow(),
                      child: SingleChildScrollView(
                        child: Form(
                          key: key,
                          child: Column(
                            children: [
                              Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: true,
                                    title: 'Days to ',
                                    textEditingController: _day,
                                    hintText: "Days to...",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Point',
                                    textEditingController: _point,
                                    hintText: "Point...",
                                    textInputType: TextInputType.number,
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 135.w,
                                      height: 50.h,
                                      child: CustomButton(
                                        isLoading: _uploading,
                                        title: "Update Point",
                                        onTap: () async {
                                          if (key.currentState!.validate()) {
                                            if (_uploading == false) {
                                              setState(() {
                                                _uploading = true;
                                              });

                                              try {
                                                DailyPointModel
                                                    dailyPointModel =
                                                    DailyPointModel(
                                                  idDoc: widget.idDoc,
                                                  day: _day.text.trim(),
                                                  point: _point.text.isNotEmpty
                                                      ? int.parse(
                                                          _point.text.trim())
                                                      : 0,
                                                );

                                                DailyPointFunction
                                                    dailyPointFunction =
                                                    DailyPointFunction();
                                                DateTime dateTime =
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
                                                      "Mengubah daily point",
                                                  user: FirebaseAuth.instance
                                                          .currentUser!.email ??
                                                      "",
                                                  type: "update",
                                                );

                                                HistoryLogModelFunction
                                                    historyLogFunction =
                                                    HistoryLogModelFunction(
                                                        idDocHistory);

                                                await dailyPointFunction
                                                    .updateDailyPoint(
                                                        dailyPointModel,
                                                        widget.idDoc);
                                                await historyLogFunction
                                                    .addHistory(
                                                        history, idDocHistory);

                                                setState(() {
                                                  _point.clear();
                                                });

                                                setState(() {
                                                  _uploading = false;
                                                });

                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                                // ignore: use_build_context_synchronously
                                                CustomToast.successToast(
                                                    context,
                                                    'Point berhasil diubah');
                                              } catch (error) {
                                                setState(() {
                                                  _uploading = false;
                                                });
                                                // ignore: use_build_context_synchronously
                                                CustomToast.errorToast(context,
                                                    'Point gagal diubah');
                                              }
                                            }
                                          }
                                        },
                                        color: SonomaneColor.containerLight,
                                        bgColor: SonomaneColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    SizedBox(
                                      width: 135.w,
                                      height: 50.h,
                                      child: CustomButton(
                                          isLoading: false,
                                          title: "Clear",
                                          onTap: () async {
                                            setState(() {
                                              _point.clear();
                                            });
                                          },
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
