import 'package:cstore/model/response_model.dart/license_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreLicense {
  static Future storeBaseUrl(LicenseResponseModel licenseData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userLicense', licenseResponseModelToJson(licenseData));
  }
}
