import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/welcome_screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/license.dart';
import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/RouteSplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final currentTime = DateTime.now().toIso8601String().substring(0, 10);


    if(sharedPreferences.containsKey(AppConstants.baseUrl)) {

      if(sharedPreferences.containsKey(AppConstants.userLoggedIn) && sharedPreferences.containsKey(AppConstants.userTimeStamp)) {
        bool isUserLoggedIn = sharedPreferences.getBool(AppConstants.userLoggedIn)!;
        String userTimeStamp = sharedPreferences.getString(AppConstants.userTimeStamp)!;

        if(isUserLoggedIn && userTimeStamp == currentTime) {

          Future.delayed(const Duration(seconds: 3)).then((value) => {
            Navigator.of(context).pushReplacementNamed(WelcomeScreen.routename)
          });
        } else {
          Future.delayed(const Duration(seconds: 3)).then((value) => {
          Navigator.of(context).pushReplacementNamed(Login.routeName)
          });
        }
      } else {
        Navigator.of(context).pushReplacementNamed(Login.routeName);
      }

    } else {
      Future.delayed(const Duration(seconds: 3)).then((value) => {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const LicenseKey()))
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/splash_logo.png",fit: BoxFit.fitWidth,)),
    );
  }
}
