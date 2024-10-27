import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sonomaneoutlet/services/auth_services.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool loading = false;
  bool visibilityPassword = false;

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SizedBox(
          height: height,
          width: width,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/sonomane_place.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 150.h,
                          ),
                          SizedBox(
                            height: 350.h,
                            child: Image.asset(
                              'assets/images/logo_sonomane-removebg-preview.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              'Delicious FOOD, Drinks and \n Friendly Atmosphere',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.patuaOne(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w700,
                                  color: SonomaneColor.textTitleDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: (width * 0.09).w),
                  color: Theme.of(context).colorScheme.background,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 40.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: (height * 0.06).h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ubah,',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(fontSize: 25.sp),
                                ),
                                TextSpan(
                                  text: ' Password ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(fontSize: 25.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: (height * 0.02).h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: Text(
                            'Hai, Masukkan password baru anda lalu \npergi ke halaman admin',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(height: (height * 0.05).h),
                        // Password
                        Row(
                          children: [
                            CustomFormField(
                              title: 'Password Baru',
                              readOnly: false,
                              hintText: 'Masukkan password baru anda',
                              textInputType: TextInputType.text,
                              textEditingController: _passwordController,
                              suffixIcon: visibilityPassword == false
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              obscureText: visibilityPassword,
                              onTapSuffixIcon: () {
                                setState(() {
                                  visibilityPassword = !visibilityPassword;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: (height * 0.01).h),

                        SizedBox(height: (height * 0.034).h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: SizedBox(
                            width: 160.w,
                            height: 50.h,
                            child: CustomButton(
                              bgColor: SonomaneColor.primary,
                              color: SonomaneColor.textTitleDark,
                              isLoading: loading,
                              onTap: () async {
                                if (loading == false) {
                                  if (mounted) {
                                    setState(() {
                                      loading = true;
                                    });
                                  }
                                  await AuthServices.newPassword(
                                      context, _passwordController.text.trim());
                                  if (mounted) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                } else {
                                  null;
                                }
                              },
                              title: "Simpan",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
