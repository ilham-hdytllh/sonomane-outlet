import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class Notifikasi {
  static void waiting(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0.r),
          ),
        ),
        content: SizedBox(
          height: 55.h,
          width: 300.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: SonomaneColor.primary,
              ),
              SizedBox(
                width: 15.w,
              ),
              Text('Mohon tunggu sebentar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 18.sp)),
            ],
          ),
        ),
      ),
    );
  }

  static void warningAlert(context, text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.r),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 170.w,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Lottie.asset(
                  'assets/lottie/warning_alert.json',
                  width: 130,
                  height: 130,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r),
                            side: BorderSide(
                                width: 1.2.w, color: SonomaneColor.lightGrey),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(SonomaneColor.lightGrey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Keluar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: SonomaneColor.scaffoldColorDark),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void successAlertTanpaDelayed(context, text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.r),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 170.w,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Lottie.asset(
                  'assets/lottie/success_alert_fix.json',
                  width: 130,
                  height: 130,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: SonomaneColor.scaffoldColorDark),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r),
                            side: BorderSide(
                                width: 1.2.w, color: SonomaneColor.lightGrey),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(SonomaneColor.lightGrey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Keluar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: SonomaneColor.scaffoldColorDark),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void successAlertSendVerify(context, text, callback2) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.r),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 170.w,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Lottie.asset(
                  'assets/lottie/verify_email.json',
                  width: 130,
                  height: 130,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: SonomaneColor.scaffoldColorDark),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                      width: 1.2.w,
                                      color: SonomaneColor.lightGrey),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  SonomaneColor.lightGrey),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Keluar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: SonomaneColor.scaffoldColorDark),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                      width: 1.2.w,
                                      color: SonomaneColor.primary),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  SonomaneColor.primary),
                            ),
                            onPressed: () {
                              callback2();
                            },
                            child: Text(
                              'Kirim Lagi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: SonomaneColor.textTitleDark),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void erorAlert(context, text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 170.w,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Lottie.asset(
                  'assets/lottie/eror_alert.json',
                  width: 130,
                  height: 130,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SizedBox(
                  height: 25.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r),
                            side: BorderSide(
                                width: 1.2.w, color: SonomaneColor.lightGrey),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(SonomaneColor.lightGrey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: SonomaneColor.scaffoldColorDark),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void successAlert(context, text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            height: 325.h,
            width: 320.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/success_alert.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void waitingAlertPembayaran(context, text, paragraph) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: 450.h,
            width: 390.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Lottie.asset(
                  'assets/lottie/waiting_alert.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: SonomaneColor.scaffoldColorDark),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Text(
                    paragraph,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: SonomaneColor.lightGrey),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(SonomaneColor.lightGrey),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        'Batal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: SonomaneColor.scaffoldColorDark),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void successAlertChangeStatusPayment(context, text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 325.h,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/success_alert.json',
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: SonomaneColor.scaffoldColorDark),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void loading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: 170,
              height: 170,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/loading2.json',
                  width: 170,
                  height: 170,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        });
  }

  static void warningAlertWithCallback(
      BuildContext context, String text, Function callback2) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.r),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 170.w,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/warning_alert.json',
                  width: 130,
                  height: 130,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                      width: 1.2.w,
                                      color: SonomaneColor.primary),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  SonomaneColor.primary),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Tidak",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: SonomaneColor.textTitleDark),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                      width: 1.2.w,
                                      color: SonomaneColor.secondary),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.background),
                            ),
                            onPressed: () {
                              callback2();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Ya",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void closeMarket(
      BuildContext context, String text, Function callback2) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.r),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0.h),
          content: SizedBox(
            width: 170.w,
            height: 325.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/warning_alert.json',
                  width: 130,
                  height: 130,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: SonomaneColor.scaffoldColorDark),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                      width: 1.2.w,
                                      color: SonomaneColor.primary),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Tidak",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: SonomaneColor.textTitleDark),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                      width: 1.2.w,
                                      color: SonomaneColor.lightGrey),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  SonomaneColor.lightGrey),
                            ),
                            onPressed: () {
                              callback2();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Ya",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: SonomaneColor.scaffoldColorDark),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
