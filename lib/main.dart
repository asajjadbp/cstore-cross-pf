import 'package:cstore/screens/Journey%20Plan/journey_plan_screen.dart';
import 'package:cstore/screens/Journey%20Plan/view_jp_photo.dart';
import 'package:cstore/screens/availability/availablity_screen.dart';
import 'package:cstore/screens/before_fixing/view_before_fixing.dart';
import 'package:cstore/screens/brand_share/AddBrandShares.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/osdc/add_osdc.dart';
import 'package:cstore/screens/osdc/view_osdc.dart';
import 'package:cstore/screens/other_photo/add_other_photo.dart';
import 'package:cstore/screens/other_photo/view_other_photo.dart';
import 'package:cstore/screens/pick_list/pick_list.dart';
import 'package:cstore/screens/plano_guide/Planoguides.dart';
import 'package:cstore/screens/planogram/planogram_screen.dart';
import 'package:cstore/screens/planogram/view_planogram_sreen.dart';
import 'package:cstore/screens/price_check/Pricecheck.dart';
import 'package:cstore/screens/rtv_screen/rtv_list_screen.dart';
import 'package:cstore/screens/share_of_shelf/add_share_of_shelf.dart';
import 'package:cstore/screens/share_of_shelf/view_share_of_shelf.dart';
import 'package:cstore/screens/splash_screen.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/visit_upload/visitUploadScreen.dart';
import 'package:cstore/screens/welcome_screen/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/license.dart';
import 'screens/auth/login.dart';
import 'screens/before_fixing/before_fixing.dart';
import 'screens/grid_dashboard/grid_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _deviceToken = "";
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   getToken();
  // }

  // Future<void> getToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   // Request permission for iOS
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     // Get the token
  //     String? token = await messaging.getToken();
  //     setState(() {
  //       _deviceToken = token ?? 'Token not available';
  //     });
  //     print("_______________________");
  //     print("Device Token: $_deviceToken");
  //     print("_______________________");
  //     await Clipboard.setData(ClipboardData(text: _deviceToken));
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }

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
        appBarTheme:const AppBarTheme(
          backgroundColor: MyColors.appMainColor,
          titleTextStyle: TextStyle(color: MyColors.whiteColor),
          iconTheme: IconThemeData(color: MyColors.whiteColor)
        ),
        primaryColor: MyColors.appMainColor,

        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(0, 77, 145, 1)),
        // useMaterial3: true,
      ),
      home: const SplashScreen(),


      routes: {
        GridDashBoard.routeName: (context) => const GridDashBoard(),
        BeforeFixing.routeName: (context) => const BeforeFixing(),
        PlanogramScreen.routeName:(context)=> const PlanogramScreen(),
        ViewPlanogramScreen.routename:(context)=>const ViewPlanogramScreen(),
        Login.routeName: (context) => const Login(),
        WelcomeScreen.routename: (context) => const WelcomeScreen(),
        DashBoard.routeName: (context) => const DashBoard(),
        JourneyPlanScreen.routename: (context) => const JourneyPlanScreen(),
        ViewJPPhoto.routename: (context) => const ViewJPPhoto(),
        ViewBeforeFixing.routename: (context) => const ViewBeforeFixing(),
        Availability.routename:(context)=> const Availability(),
        AddOtherPhoto.routeName:(context)=>const AddOtherPhoto(),
        ViewOtherPhoto.routename:(context)=>const ViewOtherPhoto(),
        ShareOfShelf.routeName:(context)=>const ShareOfShelf(),
        ViewShareOfShelf.routename:(context)=>const ViewShareOfShelf(),
        AddOSDC.routeName:(context)=>const AddOSDC(),
        ViewOSDC.routename:(context)=>const ViewOSDC(),
        LicenseKey.routeName:(context)=>const LicenseKey(),
        Rtv_List_Screen.routeName:(context)=>const Rtv_List_Screen(),
        Planoguides_Screen.routename:(context)=>const Planoguides_Screen(),
        BrandShares_Screen.routename:(context)=>const BrandShares_Screen(),
        PickListScreen.routename:(context)=>const PickListScreen(),
        VisitUploadScreen.routeName:(context)=>const VisitUploadScreen(),
        PriceCheck_Screen.routeName:(context)=>const PriceCheck_Screen()
      },
    );
  }
}
