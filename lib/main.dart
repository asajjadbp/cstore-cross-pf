import 'package:cstore/screens/Journey%20Plan/journey_plan_screen.dart';
import 'package:cstore/screens/Journey%20Plan/view_jp_photo.dart';
import 'package:cstore/screens/Language/translation.dart';
import 'package:cstore/screens/Replenishment/replenishment.dart';
import 'package:cstore/screens/availability/availablity_screen.dart';
import 'package:cstore/screens/before_fixing/view_before_fixing.dart';
import 'package:cstore/screens/brand_share/AddBrandShares.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/freshness/Freshness.dart';
import 'package:cstore/screens/freshness/ViewFreshness.dart';
import 'package:cstore/screens/knowledge_share/knowledge_share_screen.dart';
import 'package:cstore/screens/market_issues_show/add_market_issue_screen.dart';
import 'package:cstore/screens/market_issues_show/market_issues_show.dart';
import 'package:cstore/screens/osdc/add_osdc.dart';
import 'package:cstore/screens/osdc/view_osdc.dart';
import 'package:cstore/screens/other_photo/add_other_photo.dart';
import 'package:cstore/screens/other_photo/view_other_photo.dart';
import 'package:cstore/screens/pick_list/pick_list.dart';
import 'package:cstore/screens/plano_guide/Planoguides.dart';
import 'package:cstore/screens/planogram/planogram_screen.dart';
import 'package:cstore/screens/planogram/view_planogram_sreen.dart';
import 'package:cstore/screens/price_check/Pricecheck.dart';
import 'package:cstore/screens/promoplane/PromoPlan.dart';
import 'package:cstore/screens/proof_of_sale/proof_of_sale.dart';
import 'package:cstore/screens/proof_of_sale/show_proof_of_sale.dart';
import 'package:cstore/screens/rtv_1+1/add_new_rtv_1+1.dart';
import 'package:cstore/screens/rtv_1+1/view_rtv_one_plus_one.dart';
import 'package:cstore/screens/rtv_screen/rtv_list_screen.dart';
import 'package:cstore/screens/share_of_shelf/add_share_of_shelf.dart';
import 'package:cstore/screens/share_of_shelf/view_share_of_shelf.dart';
import 'package:cstore/screens/sidco_availability/sidco_availablity_screen.dart';
import 'package:cstore/screens/splash_screen.dart';
import 'package:cstore/screens/stock/stock_list_screen.dart';
import 'package:cstore/screens/survey/survey_screen.dart';
import 'package:cstore/screens/universe/universe_screen.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:cstore/screens/visit_upload/visitUploadScreen.dart';
import 'package:cstore/screens/welcome_screen/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/license.dart';
import 'screens/auth/login.dart';
import 'screens/before_fixing/before_fixing.dart';
import 'screens/grid_dashboard/grid_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // cameras = await availableCameras();
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
  String languageCode = "en";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the message
      print('Handling a foreground message ${message.messageId}');
      // showAnimatedToastMessage("Test Meesage ", "THis will be shown on front ", true);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message
      print('Handling a message open app ${message.messageId}');
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    getLanguageFromSession();
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Handle the message
    print('Handling a background message ${message.messageId}');
  }

  getLanguageFromSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey(AppConstants.languageCode)) {
      languageCode = sharedPreferences.getString(AppConstants.languageCode)!;
    } else {
      languageCode = "en";
    }

    if(languageCode == "en") {
      Get.updateLocale(Locale('en', 'US'));
    } else {
      Get.updateLocale(Locale('ar', 'AE'));
    }


    print("Language Code");
    print(languageCode);

   setState(() {

   });
  }

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
  // String _currentLanguage = 'en';
  // TextDirection _textDirection = TextDirection.ltr;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   getSessionLanguage();
  //
  //   super.initState();
  // }
  //
  // getSessionLanguage() async {
  //
  //   _currentLanguage = await loadLanguagePreference();
  //   _updateTextDirection(_currentLanguage);
  //   setState(() {
  //   });
  // }
  //
  // void _updateTextDirection(String languageCode) {
  //   setState(() {
  //     _textDirection = languageCode == 'ar'
  //         ? TextDirection.rtl
  //         : TextDirection.ltr;
  //   });
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CStore',
      debugShowCheckedModeBanner: false,
      translations: Translation(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),

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
        PriceCheck_Screen.routeName:(context)=>const PriceCheck_Screen(),
        Freshness_Screen.routeName:(context)=>const Freshness_Screen(),
        PromoPlan_scrren.routeName:(context)=> const PromoPlan_scrren(),
        ViewFreshness_Screen.routeName:(context)=>const ViewFreshness_Screen(),
        StockListScreen.routeName:(context)=>const StockListScreen(),
        SidcoAvailability.routename:(context)=>const SidcoAvailability(),
        ViewRtvOnePlusOneScreen.routeName:(context)=>const ViewRtvOnePlusOneScreen(),
        AddRtvOnePlusOne.routeName:(context)=>const AddRtvOnePlusOne(),
        ViewKnowledgeShare.routename:(context)=> const ViewKnowledgeShare(),
        ProofOfSale.routeName:(context)=>const ProofOfSale(),
        ShowProofOfSaleScreen.routename:(context)=>const ShowProofOfSaleScreen(),
        AddMarketIssue.routeName:(context)=>const AddMarketIssue(),
        ViewMarketIssueScreen.routename:(context)=>const ViewMarketIssueScreen(),
        ReplenishmentScreen.routeName: (context)=>const ReplenishmentScreen(),
        UniverseList.routename: (context)=>const UniverseList(),
        SurveyScreen.routeName: (context)=> const SurveyScreen(),
      },
    );
  }
}
