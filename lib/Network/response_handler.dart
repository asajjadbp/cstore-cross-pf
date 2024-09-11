import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../screens/important_service/genral_checks_status.dart';
import 'app_exceptions.dart';

class ResponseHandler {
  late GeneralChecksStatusController generalStatusController;

  Future post(Uri url, Map<String, dynamic> reqMap, String bearerToken) async {

    await initializeController();

    var head = <String, String>{'Authorization': 'Bearer $bearerToken'};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    // Map<String, dynamic> responseJson = {
    //   "status": false,
    //   "msg": "no data found",
    //   "data": {}
    // };
    var responseJson;

    try {

      print("STATUSES");
      print(generalStatusController.isVpnStatus.value);
      print(generalStatusController.isMockLocation.value);
      print(generalStatusController.isAutoTimeStatus.value);
      print(generalStatusController.isLocationStatus.value);

      if(generalStatusController.isVpnStatus.value) {
        throw FetchDataException("Please Disable Your VPN".tr);
      } else if(generalStatusController.isMockLocation.value) {
        throw FetchDataException("Please Disable Your Fake Locator".tr);
      } else if(!generalStatusController.isAutoTimeStatus.value) {
        throw FetchDataException("Please Enable Your Auto time Option From Setting".tr);
      } else if(!generalStatusController.isLocationStatus.value) {
        throw FetchDataException("Please Enable Your Location".tr);
      }else {
        final response = await http
            .post(
          url,
          body: reqMap,
          headers: head,
        ).timeout(const Duration(seconds: 45));
        // if (response.body.isNotEmpty) {
        // print("why this if not working");
        responseJson = json.decode(response.body.toString());

        // }
        print("%%%%%%%%%%%%%%%%%%%%%");
        print(jsonEncode(responseJson));
        print("%%%%%%%%%%%%%%%%%%%%%");
        // print(responseJson);
        if (responseJson['status'] != true) {
          throw FetchDataException(responseJson['msg'].toString());
        }
        return responseJson;
      }
    } on TimeoutException {
      throw FetchDataException("Slow internet connection".tr);
    } on SocketException {
      throw FetchDataException('No Internet connection'.tr);
    } finally {
      Get.delete<GeneralChecksStatusController>();
    }

  }

  Future postWithJson(Uri url, Map<String, dynamic> reqMap, String bearerToken) async {

    await initializeController();

    var head = <String, String>{'Authorization': 'Bearer $bearerToken'};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    // Map<String, dynamic> responseJson = {
    //   "status": false,
    //   "msg": "no data found",
    //   "data": {}
    // };

    var responseJson;
    try {

      print("STATUSES");
      print(generalStatusController.isVpnStatus.value);
      print(generalStatusController.isMockLocation.value);
      print(generalStatusController.isAutoTimeStatus.value);
      print(generalStatusController.isLocationStatus.value);

      if(generalStatusController.isVpnStatus.value) {
        throw FetchDataException("Please Disable Your VPN".tr);
      } else if(generalStatusController.isMockLocation.value) {
        throw FetchDataException("Please Disable Your Fake Locator".tr);
      } else if(!generalStatusController.isAutoTimeStatus.value) {
        throw FetchDataException("Please Enable Your Auto time Option From Setting".tr);
      } else if(!generalStatusController.isLocationStatus.value) {
        throw FetchDataException("Please Enable Your Location".tr);
      }  else {
        final response = await http
            .post(url, body: jsonEncode(reqMap), headers: head)
            .timeout(const Duration(seconds: 45));
        // if (response.body.isNotEmpty) {
        // print("why this if not working");
        responseJson = json.decode(response.body.toString());
        // }
        print("%%%%%%%%%%%%%%%%%%%%%");
        print(jsonEncode(responseJson));
        print("%%%%%%%%%%%%%%%%%%%%%");
        // print(responseJson);
        if (responseJson['status'] != true) {
          throw FetchDataException(responseJson['msg'].toString());
        }
        return responseJson;
      }
    } on TimeoutException {
      throw FetchDataException("Slow internet connection".tr);
    } on SocketException {
      throw FetchDataException('No Internet connection'.tr);
    } finally {
      Get.delete<GeneralChecksStatusController>();
    }
  }

  Future<bool> initializeController() async {

    generalStatusController = Get.put(GeneralChecksStatusController());

    await generalStatusController.getAppSetting();

    return true;
  }

}
