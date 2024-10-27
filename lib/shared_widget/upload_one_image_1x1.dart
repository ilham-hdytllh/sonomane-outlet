import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';

// ignore: must_be_immutable
class UploadOneImage1x1 extends StatefulWidget {
  File? pickedImage;
  Uint8List? webImage;
  Function onTap;
  String? updateORno;
  String? imageDB;
  Function? pickedImageClear;
  UploadOneImage1x1(
      {super.key,
      this.pickedImage,
      this.webImage,
      required this.onTap,
      this.updateORno,
      this.imageDB,
      this.pickedImageClear});

  @override
  State<UploadOneImage1x1> createState() => _UploadOneImage1x1State();
}

class _UploadOneImage1x1State extends State<UploadOneImage1x1> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0.w),
            child: RichText(
              text: TextSpan(
                text: 'Upload Gambar',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 12.sp),
                children: <TextSpan>[
                  TextSpan(
                    text: ' *( Ratio 1:1 )',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 12.sp, color: SonomaneColor.primary),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0.w),
            child: GestureDetector(
              onTap: () {
                widget.onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                height: 52.h,
                width: 385.w,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: Text(
                            'Masukkan Gambar',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 1.w,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: Text(
                            "Browse",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          _buildImagePreview(),
          SizedBox(
            height: 10.h,
          ),
          _buildClearButton(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return widget.pickedImage == null
        ? Padding(
            padding: EdgeInsets.only(left: 15.0.w),
            child: SizedBox(
              height: 140.h,
              width: 385.w,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: widget.updateORno == null
                    ? GestureDetector(
                        onTap: () {
                          widget.onTap();
                        },
                        child: DottedBorder(
                          strokeWidth: 1.w,
                          dashPattern: const [10, 6],
                          radius: Radius.circular(10.r),
                          color: Theme.of(context).colorScheme.outline,
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(20.0.w),
                              child: Image.asset(
                                "assets/images/upload_picture.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 15.0.w),
                        child: SizedBox(
                          height: 140.h,
                          width: 385.w,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRect(
                              child: Image.network(
                                widget.imageDB!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          )
        : kIsWeb
            ? Padding(
                padding: EdgeInsets.only(left: 15.0.w),
                child: SizedBox(
                  height: 140.h,
                  width: 385.w,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRect(
                      child: Image.memory(
                        widget.webImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 15.0.w),
                child: SizedBox(
                  height: 140.h,
                  width: 385.w,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRect(
                      child: Image.file(
                        widget.pickedImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
  }

  Widget _buildClearButton() {
    return widget.pickedImage == null
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(left: 15.0.w),
            child: SizedBox(
              height: 50.h,
              width: 135.w,
              child: CustomButton(
                  isLoading: false,
                  title: "Clear",
                  onTap: () async {
                    widget.pickedImageClear!();
                    setState(() {
                      widget.pickedImage = null;
                    });
                  },
                  color: SonomaneColor.textTitleLight,
                  bgColor: SonomaneColor.secondary),
            ),
          );
  }
}
