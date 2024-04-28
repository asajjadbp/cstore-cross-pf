import 'package:cstore/Model/response_model.dart/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreUserData {
  static Future storeUserCred(UserResponseModel userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userCred', userResponseModelToJson(userData));
  }
}
