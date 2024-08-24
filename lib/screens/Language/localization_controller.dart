import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    } else {
      Get.updateLocale(Locale('ar', 'AE')); // Example for Spanish
    }
  }
}