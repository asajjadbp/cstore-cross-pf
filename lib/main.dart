import 'package:cstore/screens/Journey%20Plan/journey_plan_screen.dart';
import 'package:cstore/screens/Journey%20Plan/view_jp_photo.dart';
import 'package:cstore/screens/before_fixing/view_before_fixing.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/welcome_screen/welcome.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:cstore/screens/widget/rotate.dart';
import 'package:cstore/screens/widget/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/license.dart';
import 'screens/auth/login.dart';
import 'screens/before_fixing/before_fixing.dart';
import 'screens/before_fixing/view_capture_photo.dart';
import 'screens/grid_dashboard/grid_dashboard.dart';
import 'screens/proof_of_sale/proof_of_sale.dart';
import 'screens/Journey Plan/journey_plan_2_screen.dart';

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
      // home: DashBoard(),
      // home: const Login(),
      // home: const TestWidget(),
      // home: const PriceCheck(),
      // home: const ProofOfSale(),
      // home: const BeforeFixing(),
      // home: ViewBeforeFixing(),
      // home: WelcomeScreen(),
      // home: const TestWidget(),
      // home: const ViewBeforeFixing(),
      home: const LicenseKey(),
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
        GridDashBoard.routeName: (context) => const GridDashBoard(),
        BeforeFixing.routeName: (context) => const BeforeFixing(),
        Login.routeName: (context) => const Login(),
        WelcomeScreen.routename: (context) => const WelcomeScreen(),
        DashBoard.routeName: (context) => const DashBoard(),
        JourneyPlanScreen.routename: (context) => const JourneyPlanScreen(),
        ViewJPPhoto.routename: (context) => const ViewJPPhoto(),
        ViewBeforeFixing.routename: (context) => const ViewBeforeFixing()
      },
    );
  }
}
