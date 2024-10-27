import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/theme.dart';
import 'package:sonomaneoutlet/firebase_options.dart';
import 'package:sonomaneoutlet/navigation.dart';
import 'package:sonomaneoutlet/services/session_manager.dart';
import 'package:sonomaneoutlet/view/auth/screen_login.dart';
import 'package:sonomaneoutlet/view_model/closeMarket.dart';
import 'package:sonomaneoutlet/view_model/getServerTime.dart';
import 'package:sonomaneoutlet/view_model/getVersionNew.dart';
import 'package:sonomaneoutlet/view_model/openMarket.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<CloseMarket>(create: (_) => CloseMarket()),
        ChangeNotifierProvider<OpenMarket>(create: (_) => OpenMarket()),
        ChangeNotifierProvider<GetServerTime>(create: (_) => GetServerTime()),
        ChangeNotifierProvider<GetNewVersionApp>(
            create: (_) => GetNewVersionApp()),
      ],
      builder: (context, snapshot) {
        return const MyApp();
      }));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ScreenUtilInit(
                designSize: const Size(1329.870, 935.065),
                builder: (context, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme(context),
                    darkTheme: darkTheme(context),
                    home: const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                });
          }
          return ScreenUtilInit(
              designSize: const Size(1329.870, 935.065),
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme(context),
                  darkTheme: darkTheme(context),
                  home: snapshot.data != null &&
                          snapshot.data!.emailVerified != false
                      ? const MainScreen()
                      : const ScreenLogin(),
                );
              });
        });
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void checkSessionExpiration() async {
    if (await SessionManager.isSessionExpired()) {
      // Session kadaluwarsa, arahkan ke halaman login
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        (MaterialPageRoute(
          builder: (context) => const MyApp(),
        )),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<GetNewVersionApp>(context, listen: false).getNewVersion();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: SonomaneColor.primary,
                  ),
                ),
              ),
            );
          }

          String user = snapshot.data.data()['role'];
          return Navigation(
            user: user,
          );
        });
  }
}
