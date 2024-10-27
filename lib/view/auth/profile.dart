import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

// ignore: must_be_immutable
class ProfileUser extends StatefulWidget {
  final String email;
  final String userName;
  final String role;
  final String uid;
  String? image;
  ProfileUser(
      {super.key,
      required this.email,
      required this.userName,
      required this.role,
      required this.uid,
      this.image});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final TextEditingController _namaPcontroller = TextEditingController();
  final TextEditingController _emailPcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 5.h),
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
                              color: SonomaneColor.textTitleDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      width: 350.w,
                      padding: EdgeInsets.symmetric(
                          vertical: 30.h, horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120.h,
                            height: 120.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                widget.image == null
                                    ? CircleAvatar(
                                        backgroundColor:
                                            SonomaneColor.lightGrey,
                                        radius: 66,
                                        backgroundImage: const AssetImage(
                                            "assets/images/user3.jpg"),
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            SonomaneColor.lightGrey,
                                        radius: 66,
                                        backgroundImage: NetworkImage(
                                          widget.image!,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            widget.userName.toString().capitalize(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(fontSize: 18.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(widget.role,
                              style: Theme.of(context).textTheme.titleMedium!),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: SonomaneColor.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.person,
                                    color: SonomaneColor.primary,
                                    size: 25.sp,
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    "Personal Information",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                            fontSize: 14.sp,
                                            color: SonomaneColor.textTitleDark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.lock,
                                    color: SonomaneColor.textTitleDark,
                                    size: 25.sp,
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    "Password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                            fontSize: 14.sp,
                                            color: SonomaneColor
                                                .textParaghrapDark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.logout_rounded,
                                    color: SonomaneColor.textTitleDark,
                                    size: 25.sp,
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    "Logout",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                            fontSize: 14.sp,
                                            color: SonomaneColor
                                                .textParaghrapDark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Personal Information",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              children: [
                                CustomFormField(
                                  title: "Username",
                                  readOnly: false,
                                  hintText: "",
                                  textInputType: TextInputType.text,
                                  textEditingController: _namaPcontroller,
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                CustomFormField(
                                  title: "Email",
                                  readOnly: true,
                                  hintText: "",
                                  textInputType: TextInputType.emailAddress,
                                  textEditingController: _emailPcontroller,
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: SizedBox(
                                height: 53.h,
                                width: 383.w,
                                child: CustomButton(
                                    isLoading: false,
                                    title: "Save changes",
                                    onTap: () {},
                                    color: SonomaneColor.textTitleDark,
                                    bgColor: SonomaneColor.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
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
