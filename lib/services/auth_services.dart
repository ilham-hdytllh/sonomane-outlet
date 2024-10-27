import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/main.dart';
import 'package:sonomaneoutlet/services/session_manager.dart';
import 'package:sonomaneoutlet/view/auth/new_password.dart';
import 'package:sonomaneoutlet/view/auth/screen_login.dart';
import 'package:sonomaneoutlet/view_model/getVersionNew.dart';
import 'package:sonomaneoutlet/view_model/openMarket.dart';

class AuthServices {
  static Future signInEmail(
      BuildContext context, String email, String password) async {
    final auth = FirebaseAuth.instance;
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        UserCredential? userCredential = await auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        if (userCredential.user != null) {
          if (password == "password") {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const NewPassword(),
              ),
              //if you want to disable back feature set to false
            );
          } else {
            // ignore: use_build_context_synchronously
            await Provider.of<GetNewVersionApp>(context, listen: false)
                .getNewVersion();

            // ignore: use_build_context_synchronously
            Provider.of<OpenMarket>(context, listen: false).setOpenMarket(true);
            // Setelah berhasil login, simpan waktu login
            await SessionManager.saveLoginTime();
            // ignore: use_build_context_synchronously
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const MyApp(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // email tidak terdaftar(done)
          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(
              context, "Email yang anda masukkan tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // password salah(done)
          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(context, "Password yang anda masukkan salah");
        } else if (e.code == 'invalid-email') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // email tidak sesuai(done)
          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(
              context, "Email yang anda masukkan tidak sesuai");
        } else {
          debugPrint(e.code);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(context, e.message);
        }
      }
    } else {
      Notifikasi.erorAlert(context, "Email dan password tidak boleh kosong");
    }
  }

  static Future sendResetPassword(BuildContext context, String email) async {
    final auth = FirebaseAuth.instance;
    if (email.isNotEmpty) {
      Notifikasi.waiting(context);
      try {
        await auth.sendPasswordResetEmail(email: email);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Notifikasi.successAlertSendVerify(
          context,
          "Send Reset Password telah berhasil terkirim",
          () {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const ScreenLogin(),
              ),
              (route) => false,
            );
          },
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Notifikasi.erorAlert(context, "Terjadi kesalahan silahkan coba lagi");
      }
    } else {
      Notifikasi.erorAlert(context, 'Email tidak boleh kosong');
    }
  }

  static Future newPassword(BuildContext context, String newPassword) async {
    final auth = FirebaseAuth.instance;
    if (newPassword.isNotEmpty) {
      Notifikasi.waiting(context);
      try {
        if (newPassword != "password") {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassword);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassword);

          // untuk menutup loading
          // ignore: use_build_context_synchronously
          Navigator.of(context, rootNavigator: true).pop();

          // ignore: use_build_context_synchronously
          Notifikasi.successAlert(context, "Sukses ubah password");

          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MyApp(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          // untuk menutup loading
          Navigator.of(context).pop();

          Notifikasi.erorAlert(context,
              "Password baru tidak boleh sama dengan password default");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();

          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(
              context, "Password terlalu lemah, minimal 5 karakter");
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();

          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(context, e.code);
        }
      }
    } else {
      Notifikasi.erorAlert(context, "Password baru tidak boleh kosong");
    }
  }
}
