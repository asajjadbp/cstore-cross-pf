import 'package:cstore/screens/Jouney%20Plan/journey_plan_screen.dart';
import 'package:cstore/screens/Jouney%20Plan/start_visit.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/welcome_screen/welcome.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:cstore/screens/widget/rotate.dart';
import 'package:cstore/screens/widget/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/license.dart';
import 'screens/auth/login.dart';
import 'screens/capture_photo/capture_photo.dart';
import 'screens/capture_photo/view_capture_photo.dart';
import 'screens/price_check/price_check.dart';
import 'screens/proof_of_sale/proof_of_sale.dart';
import 'screens/Jouney Plan/journey_plan_2_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    return MaterialApp(
      title: 'CStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(11, 80, 112, 1)),
        // useMaterial3: true,
      ),
      // home: const Login()
      // home: TestWidget(),
      home: WelcomeScreen(),
      // home: const WelcomeScreen(),
      // home: TestWidget(),
      // home: const LicenseKey(),
      // home: ClockwiseAnticlockwiseRotation(),
      // home: MyLoadingCircle(),
      // home: const WelcomeScreen(),
      // home: DashBoard(),
      // home: VisitPoolScreen2(),
      // home: CapturePhoto(),
      // home: const ViewJPPhoto(),
      // home: const ViewCapturePhoto(),
      // home: const ProofOfSale(),
      // home: const JourneyPlanScreen(),

      routes: {
        PriceCheck.routeName: (context) => const PriceCheck(),
        CapturePhoto.routename: (context) => const CapturePhoto(),
        Login.routeName: (context) => const Login(),
        WelcomeScreen.routename: (context) => const WelcomeScreen(),
        DashBoard.routeName: (context) => const DashBoard(),
        JourneyPlanScreen.routename: (context) => const JourneyPlanScreen(),
        ViewJPPhoto.routename: (context) => const ViewJPPhoto()
      },
    );
  }
}
