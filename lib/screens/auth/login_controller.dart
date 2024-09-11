import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model.dart/login_request_model.dart';
import '../../Model/response_model.dart/login_response_model.dart';
import '../../Network/authentication.dart';
import '../utils/app_constants.dart';
import '../welcome_screen/welcome.dart';

class LoginController extends GetxController {

  var userName = "";
  var password = "";
  var baseUrl = "";
  String currentLanguage = "en";
  String agencyName = "";
  String agencyPhoto = "";
  double currentVersion = 1.0;
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  String deviceToken = "";
  late UserResponseModel loginResponseData;

  @override
  void onInit() {
    // TODO: implement onInit

    getLicense();

    super.onInit();
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

        deviceToken = token ?? 'Token not available';
      print("_______________________");
      print("Device Token: $deviceToken");
      print("_______________________");
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> submitForm() async {
    SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    // print(licensekey);

      isLoading.value = true;

    await Authentication()
        .loginUser(
        UserRequestModel(username: userName, password: password,deviceToken: deviceToken), baseUrl)
        .then((value) async {
      final currentTime = DateTime.now().toIso8601String().substring(0, 10);

        loginResponseData = value;

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

        isLoading.value = false;
      if (value.status) {
        showAnimatedToastMessage("Success", "Logged In Successfully".tr, true);
        // ToastMessage.succesMessage(context, "Logged In Successfully".tr);
        Get.offNamed(WelcomeScreen.routename);
        // Navigator.of(context).pushReplacementNamed();
      } else {
        showAnimatedToastMessage("Error!", value.msg.toString(), false);
      }
    }).catchError((onError) {

        isLoading.value = false;
      print(onError.toString());
        showAnimatedToastMessage("Error!", onError.toString(), false);
    });
  }


}