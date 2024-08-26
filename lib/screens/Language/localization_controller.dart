import 'package:cstore/screens/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxService {
  var isEnglish = true.obs; // Observable boolean

  // Function to toggle the language status
  bool languageCheck() {
    return isEnglish.value ? true : false;
  }

  void changeLanguage() {
    isEnglish.value = !isEnglish.value;
    // Change the locale based on the boolean value
    print(isEnglish.value);
    if (isEnglish.value) {
      Get.updateLocale(Locale('en', 'US'));
      setLanguageSession("en");
    } else {
      Get.updateLocale(Locale('ar', 'AE'));
      setLanguageSession("ar");
    }
  }

  setLanguageSession(String languageCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(AppConstants.languageCode, languageCode);
  }
}