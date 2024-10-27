// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:sonomaneoutlet/common/app_colors.dart';
// import 'package:sonomaneoutlet/view/auth/screen_login.dart';
// import '../../common/app_responsive.dart';

// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});

//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   final emailController = TextEditingController();
//   FirebaseAuth auth = FirebaseAuth.instance;

//   Future sendResetPassword() async {
//     if (emailController.text.isNotEmpty) {
//       QuickAlert.show(
//         width: MediaQuery.of(context).size.width * 0.1,
//         barrierDismissible: false,
//         context: context,
//         type: QuickAlertType.loading,
//         text: 'Mohon Tunggu Sebentar',
//       );
//       try {
//         await auth.sendPasswordResetEmail(email: emailController.text);
//         // menutup loading
//         Navigator.of(context).pop();
//         QuickAlert.show(
//           width: MediaQuery.of(context).size.width * 0.1,
//           context: context,
//           type: QuickAlertType.success,
//           text: "Send Reset Password telah berhasil terkirim",
//           onConfirmBtnTap: () {
//             Navigator.pushAndRemoveUntil<dynamic>(
//               context,
//               MaterialPageRoute<dynamic>(
//                 builder: (BuildContext context) => ScreenLogin(),
//               ),
//               (route) =>
//                   false, //if you want to disable back feature set to false
//             );
//           },
//         );
//       } on FirebaseAuthException catch (e) {
//         // menutup loading
//         Navigator.of(context).pop();
//         QuickAlert.show(
//           width: MediaQuery.of(context).size.width * 0.1,
//           context: context,
//           type: QuickAlertType.error,
//           text: e.code,
//         );
//       }
//     } else {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) => AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(15.0))),
//           contentPadding: const EdgeInsets.only(top: 10.0),
//           content: SizedBox(
//             height: 390,
//             width: 390,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset(
//                   'assets/lottie/eror_alert.json',
//                   width: 200,
//                   height: 200,
//                   fit: BoxFit.fill,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Text(
//                     'Email tidak boleh kosong',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                         color: AppColor.black),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         shape: MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         backgroundColor:
//                             MaterialStateProperty.all(AppColor.lightGrey),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Text(
//                         'Keluar',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: AppColor.black),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColor.bgColor,
//       body: SizedBox(
//         height: height,
//         width: width,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             AppResponsive.isMobile(context)
//                 ? SizedBox()
//                 : Expanded(
//                     child: SafeArea(
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage(
//                                   'assets/images/sonomane_place.jpg'),
//                               fit: BoxFit.cover),
//                         ),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               const SizedBox(
//                                 height: 100,
//                               ),
//                               Flexible(
//                                 flex: 2,
//                                 child: Image.asset(
//                                   'assets/images/logo_sonomane-removebg-preview.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Flexible(
//                                 flex: 1,
//                                 child: SizedBox(
//                                   child: Text(
//                                     'Delicious FOOD, Drinks and \n Friendly Atmosphere',
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.patuaOne(
//                                         fontSize: 45,
//                                         fontWeight: FontWeight.w700,
//                                         color: AppColor.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//             Expanded(
//               child: Container(
//                 height: height,
//                 margin: EdgeInsets.symmetric(
//                     horizontal: AppResponsive.isMobile(context)
//                         ? height * 0.032
//                         : height * 0.12),
//                 color: AppColor.white,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.only(bottom: 40.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(height: height * 0.2),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Welcome,',
//                               style: GoogleFonts.raleway(
//                                 fontSize: 25.0,
//                                 color: AppColor.black2,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' Lupa Password ',
//                               style: GoogleFonts.raleway(
//                                 fontSize: 25.0,
//                                 color: AppColor.black2,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: height * 0.02),
//                       Text(
//                         'Hey, Enter your email to get reset password in \nto your email',
//                         style: GoogleFonts.raleway(
//                           fontSize: 12.0,
//                           fontWeight: FontWeight.w400,
//                           color: AppColor.grey,
//                         ),
//                       ),
//                       SizedBox(height: height * 0.064),
//                       // Email
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16.0),
//                         child: Text(
//                           'Email',
//                           style: GoogleFonts.raleway(
//                             fontSize: 14.0,
//                             color: AppColor.black2,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 6.0),
//                       SizedBox(
//                         height: 50.0,
//                         width: width,
//                         child: TextField(
//                           controller: emailController,
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: AppColor.black),
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.email),
//                             contentPadding: const EdgeInsets.only(top: 16.0),
//                             hintText: 'Masukkan Email Anda',
//                             hintStyle: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColor.greyActive),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: AppColor.borderNonactive),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: AppColor.borderActive, width: 1),
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: height * 0.03),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(
//                             width: 160,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all(AppColor.red),
//                               ),
//                               onPressed: sendResetPassword,
//                               child: Text(
//                                 "Reset Password",
//                                 style: TextStyle(
//                                   color: AppColor.white,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: height * 0.03),
//                           SizedBox(
//                             width: 160,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all(AppColor.red),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text(
//                                 "Kembali",
//                                 style: TextStyle(
//                                   color: AppColor.white,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
