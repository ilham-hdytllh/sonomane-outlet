import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/services/session_manager.dart';
// import 'package:sonomaneoutlet/view/auth/profile.dart';
import 'package:sonomaneoutlet/view/auth/screen_login.dart';
import 'package:sonomaneoutlet/view/setting/setting.dart';
import 'package:sonomaneoutlet/view_model/closeMarket.dart';

class SonomaneAppBarWidget extends StatefulWidget {
  const SonomaneAppBarWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SonomaneAppBarWidgetState createState() => _SonomaneAppBarWidgetState();
}

class _SonomaneAppBarWidgetState extends State<SonomaneAppBarWidget> {
  Stream? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
              width: 0.3.w, color: Theme.of(context).colorScheme.outline),
        ),
      ),
      height: 65.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          StreamBuilder(
            stream: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                String adminFoto = "assets/images/user3.jpg";
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      user['role'] == "kasir" ||
                              user['role'] == "manajer" ||
                              user['role'] == "superadmin"
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.0.w),
                              child: SizedBox(
                                height: 50.h,
                                child: Consumer<CloseMarket>(
                                    builder: (context, closeMarket, _) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              closeMarket.marketIsClosing ==
                                                      false
                                                  ? SonomaneColor.primary
                                                  : SonomaneColor.secondary),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0.r),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      bool? isClose = Provider.of<CloseMarket>(
                                              context,
                                              listen: false)
                                          .marketIsClosing;

                                      callback2() {
                                        Provider.of<CloseMarket>(context,
                                                listen: false)
                                            .setCloseMarket(true);
                                      }

                                      if (isClose == false) {
                                        Notifikasi.warningAlertWithCallback(
                                            context,
                                            "Yakin ingin menutup toko?",
                                            callback2);
                                      } else {
                                        debugPrint("sudahTutup");
                                      }
                                    },
                                    child: Text(
                                      closeMarket.marketIsClosing == false
                                          ? "Tutup Penjualan"
                                          : "Penjualan Telah Ditutup",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: closeMarket
                                                          .marketIsClosing ==
                                                      false
                                                  ? SonomaneColor.containerLight
                                                  : SonomaneColor
                                                      .textTitleLight,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }),
                              ),
                            )
                          : const SizedBox(),
                      user['role'] == "kasir" ||
                              user['role'] == "manajer" ||
                              user['role'] == "superadmin"
                          ? const Spacer()
                          : const SizedBox(),
                      SizedBox(
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${user['role']}'.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "${user['email']}".toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      fontSize: 13.sp, letterSpacing: 0.3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute<dynamic>(
                          //     builder: (BuildContext context) => ProfileUser(
                          //       userName: user["name"],
                          //       email: user["email"],
                          //       role: user["role"],
                          //       uid: user["uid"],
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          margin: EdgeInsets.all(5.r),
                          width: 45.w,
                          height: double.infinity,
                          child: CircleAvatar(
                            radius: 30.0.r,
                            backgroundImage: AssetImage(adminFoto),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(50.w, 50.h, 0, 0),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              items: <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        size: 20.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text("Settings",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        size: 20.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text("Logout",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                    ],
                                  ),
                                ),
                              ],
                            ).then((value) async {
                              // Tangani pilihan menu di sini...
                              if (value != null) {
                                if (value == 1) {
                                  await SessionManager.clearSession();
                                  await FirebaseAuth.instance.signOut();
                                  // ignore: use_build_context_synchronously
                                  Provider.of<CloseMarket>(context,
                                          listen: false)
                                      .setCloseMarket(false);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          const ScreenLogin(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Setting(),
                                  ));
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.expand_more_rounded,
                            size: 22.sp,
                            color: Theme.of(context).colorScheme.tertiary,
                          ))
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
