import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/version/version.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formFieldNoExpanded.dart';
import 'package:sonomaneoutlet/shared_widget/formField_no_title.dart';

class AddVersionOutlet extends StatefulWidget {
  const AddVersionOutlet({super.key});

  @override
  State<AddVersionOutlet> createState() => _AddVersionOutletState();
}

class _AddVersionOutletState extends State<AddVersionOutlet> {
  // formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noVersion = TextEditingController();
  List<TextEditingController> listController = [TextEditingController()];
  void clearControllers() {
    for (int i = 1; i < listController.length; i++) {
      listController[i].clear();
    }
    listController.removeRange(1, listController.length);
    if (listController.isNotEmpty) {
      listController[0].clear();
    }
  }

  bool _uploading = false;
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
                      'Add Version Customer',
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
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomFormFieldNoExpanded(
                                        readOnly: false,
                                        title: 'No Version',
                                        textEditingController: _noVersion,
                                        hintText: "No Version...",
                                        textInputType: TextInputType.text,
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.0.w),
                                        child: Text(
                                          "Description",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              left: 15.0.w, right: 15.w),
                                          itemCount: listController.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.h),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomFormFieldNoTitle(
                                                        readOnly: false,
                                                        hintText: "",
                                                        textEditingController:
                                                            listController[
                                                                index],
                                                        textInputType:
                                                            TextInputType.text),
                                                  ),
                                                  index == 0
                                                      ? SizedBox(
                                                          width: 10.w,
                                                        )
                                                      : const SizedBox(),
                                                  index == 0
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              listController.add(
                                                                  TextEditingController());
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 50.w,
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  SonomaneColor
                                                                      .primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.w),
                                                            ),
                                                            child: Icon(
                                                              Icons.add_rounded,
                                                              size: 22.sp,
                                                              color: SonomaneColor
                                                                  .textTitleDark,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  index != 0
                                                      ? SizedBox(
                                                          width: 10.w,
                                                        )
                                                      : const SizedBox(),
                                                  index != 0
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              listController[
                                                                      index]
                                                                  .clear();
                                                              listController[
                                                                      index]
                                                                  .dispose();
                                                              listController
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 50.w,
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  SonomaneColor
                                                                      .primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.w),
                                                            ),
                                                            child: Icon(
                                                              Icons.delete,
                                                              size: 22.sp,
                                                              color: SonomaneColor
                                                                  .textTitleDark,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                            );
                                          }),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.0.w, right: 15.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50.h,
                                                child: CustomButton(
                                                    isLoading: _uploading,
                                                    title: "Add version",
                                                    onTap: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        if (_uploading ==
                                                            false) {
                                                          setState(() {
                                                            _uploading = true;
                                                          });
                                                          List<String>
                                                              description = [];

                                                          for (var controller
                                                              in listController) {
                                                            String itemText =
                                                                controller.text;

                                                            if (itemText
                                                                .isNotEmpty) {
                                                              description.add(
                                                                  itemText);
                                                            }
                                                          }

                                                          String idDoc =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "softwareVersionCustomer")
                                                                  .doc()
                                                                  .id;

                                                          VersionModel
                                                              versionModel =
                                                              VersionModel(
                                                            datetime: DateFormat(
                                                                    'yyyy-MM-dd HH:mm:ss')
                                                                .format(
                                                              DateTime.parse(
                                                                  DateTime.now()
                                                                      .toString()),
                                                            ),
                                                            description:
                                                                description,
                                                            noVersion:
                                                                _noVersion.text
                                                                    .trim(),
                                                          );

                                                          DateTime dateTime =
                                                              DateTime.now();

                                                          String idDocHistory =
                                                              "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                                          HistoryLogModel
                                                              history =
                                                              HistoryLogModel(
                                                            idDoc: idDocHistory,
                                                            date: dateTime.day,
                                                            month:
                                                                dateTime.month,
                                                            year: dateTime.year,
                                                            dateTime: DateFormat(
                                                                    'yyyy-MM-dd HH:mm:ss')
                                                                .format(
                                                                    dateTime),
                                                            keterangan:
                                                                "Menambahkan version app customer",
                                                            user: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .email ??
                                                                "",
                                                            type: "create",
                                                          );

                                                          try {
                                                            VersionFunction
                                                                versionFunction =
                                                                VersionFunction();

                                                            HistoryLogModelFunction
                                                                historyLogFunction =
                                                                HistoryLogModelFunction(
                                                                    idDocHistory);

                                                            versionFunction
                                                                .addVersionOutlet(
                                                                    versionModel,
                                                                    idDoc);

                                                            await historyLogFunction
                                                                .addHistory(
                                                                    history,
                                                                    idDocHistory);

                                                            setState(() {
                                                              _noVersion
                                                                  .clear();
                                                              _uploading =
                                                                  false;
                                                              clearControllers();
                                                              description
                                                                  .clear();
                                                            });
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            // ignore: use_build_context_synchronously
                                                            CustomToast
                                                                .successToast(
                                                                    context,
                                                                    'New version berhasil dibuat!');
                                                          } catch (error) {
                                                            setState(() {
                                                              _uploading =
                                                                  false;
                                                              description
                                                                  .clear();
                                                            });
                                                            // ignore: use_build_context_synchronously
                                                            CustomToast.errorToast(
                                                                context,
                                                                'New version gagal ditambahkan!');
                                                          }
                                                        }
                                                      }
                                                    },
                                                    color: SonomaneColor
                                                        .containerLight,
                                                    bgColor:
                                                        SonomaneColor.primary),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50.h,
                                                child: CustomButton(
                                                    isLoading: false,
                                                    title: "Clear",
                                                    onTap: () async {
                                                      setState(() {
                                                        _noVersion.clear();
                                                        clearControllers();
                                                      });
                                                    },
                                                    color: SonomaneColor
                                                        .textTitleLight,
                                                    bgColor: SonomaneColor
                                                        .secondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              const Expanded(
                                child: SizedBox(),
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
