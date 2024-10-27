import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/daily_checkin/daily_reward.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';
import 'package:sonomaneoutlet/shared_widget/upload_one_image_1x1.dart';

class AddRewardPoint extends StatefulWidget {
  const AddRewardPoint({
    super.key,
  });

  @override
  State<AddRewardPoint> createState() => _AddRewardPointState();
}

class _AddRewardPointState extends State<AddRewardPoint> {
  bool _uploading = false;

  GlobalKey<FormState> key = GlobalKey();
  final TextEditingController _day = TextEditingController();
  final TextEditingController _point = TextEditingController();

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      }
    } else {
      CustomToast.errorToast(context, "Gagal mengambil gambar.");
    }
  }

  String imageUrl = '';
  String imageName = '';
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

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
                      'Add Reward Point',
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
                                    readOnly: false,
                                    title: 'Days to',
                                    textEditingController: _day,
                                    hintText: "Days to...",
                                    textInputType: TextInputType.number,
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Point',
                                    textEditingController: _point,
                                    hintText: "Point...",
                                    textInputType: TextInputType.number,
                                  ),
                                  UploadOneImage1x1(
                                    onTap: _pickImage,
                                    pickedImage: _pickedImage,
                                    webImage: webImage,
                                    pickedImageClear: () {
                                      _pickedImage = null;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
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
                                          title: "Add Reward",
                                          onTap: () async {
                                            if (key.currentState!.validate()) {
                                              if (_uploading == false) {
                                                setState(() {
                                                  _uploading = true;
                                                });

                                                if (_pickedImage == null) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Silahkan Pilih Gambar Terlebih Dahulu!');
                                                  return;
                                                }

                                                Reference referenceRoot =
                                                    FirebaseStorage.instance
                                                        .ref();
                                                Reference referenceDirImages =
                                                    referenceRoot.child(
                                                        'rewardDailyCheckin');
                                                Reference
                                                    referenceImageToUpload =
                                                    referenceDirImages.child(
                                                        "${DateTime.now().millisecondsSinceEpoch}");

                                                try {
                                                  if (kIsWeb) {
                                                    // Store the file for web
                                                    await referenceImageToUpload
                                                        .putData(
                                                      webImage,
                                                      SettableMetadata(
                                                          contentType:
                                                              'image/jpeg'),
                                                    );
                                                  } else if (!kIsWeb) {
                                                    // Store the file for non-web (mobile, desktop)
                                                    await referenceImageToUpload
                                                        .putFile(File(
                                                            _pickedImage!
                                                                .path));
                                                  }

                                                  // Success: get the download URL
                                                  imageUrl =
                                                      await referenceImageToUpload
                                                          .getDownloadURL();
                                                  imageName =
                                                      referenceImageToUpload
                                                          .toString();
                                                } catch (error) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Gagal upload gambar');
                                                  return;
                                                }
                                                String idDoc = FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                        "rewardMisiDaily")
                                                    .doc()
                                                    .id;
                                                try {
                                                  DailyRewardPointModel
                                                      dailyRewardPointModel =
                                                      DailyRewardPointModel(
                                                          day: _day.text
                                                                  .isNotEmpty
                                                              ? int.parse(_day
                                                                  .text
                                                                  .trim())
                                                              : 1,
                                                          idDoc: idDoc,
                                                          image: imageUrl,
                                                          jenis: "point",
                                                          point: _point.text
                                                                  .isNotEmpty
                                                              ? int.parse(_point
                                                                  .text
                                                                  .trim())
                                                              : 0);

                                                  DailyRewardFunction
                                                      dailyRewardFunction =
                                                      DailyRewardFunction(
                                                          dailyRewardModel:
                                                              dailyRewardPointModel,
                                                          jenis: "point");

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
                                                        "Menambahkan reward point",
                                                    user: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .email ??
                                                        "",
                                                    type: "create",
                                                  );

                                                  HistoryLogModelFunction
                                                      historyLogFunction =
                                                      HistoryLogModelFunction(
                                                          idDocHistory);

                                                  await dailyRewardFunction
                                                      .addDailyReward(idDoc);

                                                  await historyLogFunction
                                                      .addHistory(history,
                                                          idDocHistory);

                                                  setState(() {
                                                    _day.clear();
                                                    _point.clear();
                                                    _pickedImage = null;
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.successToast(
                                                      context,
                                                      'Reward point berhasil ditambahkan');
                                                } catch (error) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Reward point gagal ditambahkan');
                                                }
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
                                          isLoading: false,
                                          title: "Clear",
                                          onTap: () async {
                                            setState(() {
                                              _day.clear();
                                              _point.clear();
                                              _pickedImage = null;
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
