// import 'dart:convert';

import 'package:cstore/Model/request_model.dart/jp_request_model.dart';
import 'package:cstore/Model/response_model.dart/syncronise_response_model.dart';

import 'api.dart';
import 'response_handler.dart';
// import 'package:http/http.dart' as http;

class SyncroniseHTTP {
  final ResponseHandler _handler = ResponseHandler();

  Future<SyncroniseResponseModel> fetchSyncroniseData(
      String userName, String token, String baseUrl) async {
    final url = baseUrl + Api.SYNCRONISEVISIT;
    // print("--------------------------");
    // String token = GetUserDataAndUrl().getToken.toString();
    // print("+++++++++++++++++");
    // print(token);
    // print("bbbbbbbbbbbbbbbbbbb");

    // Map<String, String> headers = {
    //   'Authorization': 'Bearer $token',
    //   'Content-Type': 'application/json', // adjust content type if needed
    // };
    var response;
    await Future.delayed(const Duration(seconds: 0)).then((value) async {
      response = await _handler.post(Uri.parse(url),
          JourneyPlanRequestModel(username: userName).toJson(), token);
    });

    // final response = await http
    //     .post(Uri.parse(url), headers: headers, body: {"username": userName});
    // final responseData = jsonDecode(response.body);
    // print("some thing went");
    // print(responseData);

    SyncroniseResponseModel syncResponseData =
        SyncroniseResponseModel.fromJson(response);

    // StoreLicense.storeBaseUrl(licenseResponseData);

    // print(licenseResponseData.data[0].baseUrl);
    return syncResponseData;
  }
}
