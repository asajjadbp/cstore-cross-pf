import 'package:cstore/Network/api.dart';
import 'package:cstore/Network/response_handler.dart';
import 'package:cstore/Network/store_license.dart';

import '../model/response_model.dart/license_response.dart';

class LICENSEHTTPMANAGER {
  final ResponseHandler _handler = ResponseHandler();

  Future<LicenseResponseModel> getLicense(String licenseKey) async {
    const url = Api.licenseApi;
    // ignore: avoid_print
print(url);
    final response =
        await _handler.post(Uri.parse(url), {"license_key": licenseKey}, "");
    LicenseResponseModel licenseResponseData =
        LicenseResponseModel.fromJson(response);
    // StoreLicense.storeBaseUrl(licenseResponseData);

    // print(licenseResponseData.data[0].baseUrl);
    return licenseResponseData;
  }
}
