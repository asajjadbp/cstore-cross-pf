import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/Model/request_model.dart/login_request_model.dart';
import 'package:cstore/Model/response_model.dart/login_response_model.dart';
import 'package:cstore/Network/authentication.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:cstore/screens/welcome_screen/welcome.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';

class Login extends StatefulWidget {
  static const routeName = "/loginRoute";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var userName = "";
  var password = "";
  var baseUrl = "";

  String agencyName = "";
  String agencyPhoto = "";
  double currentVersion = 1.0;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String deviceToken = "";

  late UserResponseModel loginResponseData;

  @override
  void initState() {
    getLicense();
    super.initState();
  }

  void getLicense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    baseUrl = prefs.getString(AppConstants.baseUrl)!;
    agencyName = prefs.getString(AppConstants.licenseAgency)!;
    agencyPhoto = prefs.getString(AppConstants.agencyPhoto)!;
    if(prefs.containsKey(AppConstants.appCurrentVersion)) {
      currentVersion = prefs.getDouble(AppConstants.appCurrentVersion)!;
    } else {
      currentVersion = 1.0;
      prefs.setDouble(AppConstants.appCurrentVersion, currentVersion);
    }

    getToken();
    print(agencyName);
    print(agencyPhoto);
  }

  Future<void> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await messaging.getToken();
      setState(() {
        deviceToken = token ?? 'Token not available';
      });
      print("_______________________");
      print("Device Token: $deviceToken");
      print("_______________________");
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> submitForm() async {
    SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // print(licensekey);
    setState(() {
      isLoading = true;
    });
    await Authentication()
        .loginUser(
            UserRequestModel(username: userName, password: password,deviceToken: deviceToken), baseUrl)
        .then((value) async {
      final currentTime = DateTime.now().toIso8601String().substring(0, 10);
          setState(() {
            loginResponseData = value;
          });
      sharedPreferences.setBool(AppConstants.userLoggedIn, true);
      sharedPreferences.setString(AppConstants.userName, loginResponseData.data[0].username.toString());
      sharedPreferences.setString(AppConstants.userClient, loginResponseData.data[0].userClient.toString());
      sharedPreferences.setString(AppConstants.userEnMessage, loginResponseData.data[0].enWelcomeMsg.toString());
      sharedPreferences.setString(AppConstants.userArMessage, loginResponseData.data[0].arWelcomeMsg.toString());
      sharedPreferences.setString(AppConstants.userPic, loginResponseData.data[0].userPic.toString());
      sharedPreferences.setString(AppConstants.isSyncronize, loginResponseData.data[0].isSyncronize.toString());
      sharedPreferences.setString(AppConstants.tokenId, loginResponseData.data[0].tokenId.toString());
      sharedPreferences.setString(AppConstants.userRole, loginResponseData.data[0].userRole.toString());
      sharedPreferences.setString(AppConstants.userTimeStamp, currentTime);
      sharedPreferences.setDouble(AppConstants.appUpdatedVersion, loginResponseData.data[0].versionNumber);

      currentVersion = loginResponseData.data[0].versionNumber;

      setState(() {
        isLoading = false;
      });
      if (value.status) {
        ToastMessage.succesMessage(context, value.msg);
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routename);
      } else {
        ToastMessage.errorMessage(context, value.msg);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                left: 0,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.99,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.08,
                          ),
                          Center(
                            child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.asset("assets/images/logo.png")),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 6,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Please Login to continue',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,

                                  ),
                                ),
                              )),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      focusColor: MyColors.appMainColor,
                                      hintText: "username",
                                      filled: true,
                                      fillColor:MyColors.dropBorderColor,
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your username";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    userName = newValue.toString();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                child: TextFormField(
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      hintText: "password",
                                      filled: true,
                                      fillColor:MyColors.dropBorderColor,
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    password = newValue.toString();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              isLoading
                                  ? const Center(
                                  child: SizedBox(
                                      height: 60, child: MyLoadingCircle()))
                                  : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color.fromRGBO(0, 77, 145, 1),
                                  minimumSize: Size(screenWidth, 45),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(0)),
                                ),
                                onPressed: submitForm,
                                child: const Text(
                                  "Login",style: TextStyle(color: MyColors.whiteColor),
                                ),
                              ),
                            ],
                          ),

                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                children: [
                                  SvgPicture.network(agencyPhoto),

                                  Container(
                                    margin:const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(agencyName),),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Text("Version: $currentVersion",style: const TextStyle(color: MyColors.appMainColor),),)
                                ],
                              )),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
