import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';

// ignore: must_be_immutable
class UploadManyImage extends StatefulWidget {
  List<File> pickedImage;
  List<Uint8List>? webImage;
  Function onTap;
  String? updateORno;
  List? imageDB;
  Function? pickedImageClear;
  Function(int)? removeImage;
  UploadManyImage(
      {super.key,
      required this.pickedImage,
      this.webImage,
      required this.onTap,
      this.updateORno,
      this.imageDB,
      this.pickedImageClear,
      this.removeImage});

  @override
  State<UploadManyImage> createState() => _UploadManyImageState();
}

class _UploadManyImageState extends State<UploadManyImage> {
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
    return widget.pickedImage.isEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 15.0.w),
            child: SizedBox(
              height: 150.h,
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
                    : SizedBox(
                        height: 150.h,
                        width: 385.w,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.imageDB!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imageDB![index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
              ),
            ),
          )
        : kIsWeb
            ? Padding(
                padding: EdgeInsets.only(left: 15.0.w),
                child: SizedBox(
                  height: 150.h,
                  width: 385.w,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.webImage!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: Image.memory(
                                    widget.webImage![index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w, top: 6.h),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.delete,
                                    size: 22.sp,
                                    color: SonomaneColor.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 15.0.w),
                child: SizedBox(
                  height: 150.h,
                  width: 385.w,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.pickedImage.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: Image.file(
                                    widget.pickedImage[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.removeImage!(index);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 6.w, top: 6.h),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.delete,
                                      size: 22.sp,
                                      color: SonomaneColor.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              );
  }

  Widget _buildClearButton() {
    return widget.pickedImage.isEmpty
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
                      widget.pickedImage.clear();
                    });
                  },
                  color: SonomaneColor.textTitleLight,
                  bgColor: SonomaneColor.secondary),
            ),
          );
  }
}
