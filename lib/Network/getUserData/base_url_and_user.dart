import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class GetUserDataAndUrl {
  Future<String> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs = await SharedPreferences.getInstance();
    // final extractedUserData =
    //     json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    final baseUrl =
        json.decode(prefs.getString('userLicense')!) as Map<String, dynamic>;
    String url = baseUrl["data"][0]["base_url"];

    return url;
  }

  Future<String> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    // final baseUrl =
    //     json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    String user = extractedUserData["data"]["username"];

    return user;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    // final baseUrl =
    //     json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    String token = extractedUserData["data"]["token_id"];
    log("This is printing separate");
    print(token);

    return token;
  }
}
