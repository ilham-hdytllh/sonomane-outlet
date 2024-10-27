import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sonomaneoutlet/services/auth_services.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool loading = false;
  bool visibilityPassword = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Future signIn(BuildContext context) async {
  //   if (_emailController.text.isNotEmpty &&
  //       _passwordController.text.isNotEmpty) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(6.0.r),
  //           ),
  //         ),
  //         content: SizedBox(
  //           height: 55.h,
  //           width: 300.w,
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               CircularProgressIndicator(
  //                 color: AppColor.red,
  //               ),
  //               SizedBox(
  //                 width: 15.w,
  //               ),
  //               Text(
  //                 'Mohon tunggu sebentar',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     fontSize: 18.sp,
  //                     fontWeight: FontWeight.w500,
  //                     color: AppColor.black),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //     try {
  //       UserCredential? userCredential = await _auth.signInWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );

  //       if (userCredential.user != null) {
  //         // untuk menutup loading

  //         if (userCredential.user!.emailVerified == true) {
  //           if (_passwordController.text == "password") {
  //             // untuk menutup loading
  //             // ignore: use_build_context_synchronously
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute<dynamic>(
  //                 builder: (BuildContext context) => const NewPassword(),
  //               ),
  //               //if you want to disable back feature set to false
  //             );
  //           } else {
  //             // ignore: use_build_context_synchronously
  //             Provider.of<GetNewVersionApp>(context, listen: false)
  //                 .getNewVersion();

  //             // ignore: use_build_context_synchronously
  //             Provider.of<OpenMarket>(context, listen: false)
  //                 .setOpenMarket(true);
  //             // ignore: use_build_context_synchronously
  //             await Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute<dynamic>(
  //                 builder: (BuildContext context) => const MyApp(),
  //               ),
  //             );

  //             // String? accessToken = await userCredential.user?.getIdToken();

  //             // SharedPreferences prefs = await SharedPreferences.getInstance();
  //             // await prefs.setString('userToken', accessToken!);
  //           }
  //         } else {
  //           // verfy email

  //           void callback2() async {
  //             try {
  //               await userCredential.user!.sendEmailVerification();
  //               // ignore: use_build_context_synchronously
  //               Navigator.of(context).pop();
  //               // ignore: use_build_context_synchronously
  //               Notifikasi.successAlertTanpaDelayed(
  //                   context, 'Email verifikasi telah dikirim');
  //             } catch (e) {
  //               // untuk menutup loading
  //               Navigator.of(context).pop();
  //               Notifikasi.erorAlert(
  //                   context, 'Telah terjadi kesalahan silahkan hubungi admin');
  //             }
  //           }

  //           // ignore: use_build_context_synchronously
  //           Notifikasi.successAlertSendVerify(
  //               context,
  //               "Maaf kamu belum verified, cek email untuk verifikasi",
  //               callback2);
  //         }
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         // untuk menutup loading
  //         Navigator.of(context).pop();
  //         // email tidak terdaftar(done)
  //         Notifikasi.erorAlert(
  //             context, "Email yang anda masukkan tidak terdaftar");
  //       } else if (e.code == 'wrong-password') {
  //         // untuk menutup loading
  //         Navigator.of(context).pop();
  //         // password salah(done)
  //         Notifikasi.erorAlert(context, "Password yang anda masukkan salah");
  //       } else if (e.code == 'invalid-email') {
  //         // untuk menutup loading
  //         Navigator.of(context).pop();
  //         // email tidak sesuai(done)
  //         Notifikasi.erorAlert(
  //             context, "Email yang anda masukkan tidak sesuai");
  //       } else {
  //         debugPrint(e.code);
  //         // untuk menutup loading
  //         Navigator.of(context).pop();
  //         // e eror
  //         Notifikasi.erorAlert(context, e.message);
  //       }
  //     }
  //   } else {
  //     Notifikasi.erorAlert(context, "Email dan password tidak boleh kosong");
  //   }
  // }

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
                                  text: 'Hai,',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(fontSize: 25.sp),
                                ),
                                TextSpan(
                                  text: ' Selamat Datang ',
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
                            'Masukkan akun anda dengan benar agar \ndapat masuk ke akun anda',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(height: (height * 0.05).h),
                        // Email
                        Row(
                          children: [
                            CustomFormField(
                              title: 'Email',
                              readOnly: false,
                              hintText: 'Masukkan email anda',
                              textInputType: TextInputType.emailAddress,
                              textEditingController: _emailController,
                              suffixIcon: Icons.email,
                            ),
                          ],
                        ),
                        SizedBox(height: (height * 0.02).h),
                        // Password
                        Row(
                          children: [
                            CustomFormField(
                              title: 'Password',
                              readOnly: false,
                              hintText: 'Masukkan password',
                              textInputType: TextInputType.text,
                              textEditingController: _passwordController,
                              suffixIcon: visibilityPassword == false
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              obscureText:
                                  visibilityPassword == false ? true : false,
                              onTapSuffixIcon: () {
                                setState(() {
                                  visibilityPassword = !visibilityPassword;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: (height * 0.01).h),
                        // lupa password
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute<dynamic>(
                        //           builder: (BuildContext context) =>
                        //               const forgotPassword(),
                        //         ), //if you want to disable back feature set to false
                        //       );
                        //     },
                        //     child: Text(
                        //       "Lupa password?",
                        //       style: TextStyle(
                        //           fontSize: 12.0,
                        //           fontWeight: FontWeight.w600,
                        //           color: AppColor.black),
                        //     ),
                        //   ),
                        // ),
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
                                  await AuthServices.signInEmail(
                                      context,
                                      _emailController.text.trim(),
                                      _passwordController.text.trim());
                                }
                              },
                              title: "Sign In",
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
