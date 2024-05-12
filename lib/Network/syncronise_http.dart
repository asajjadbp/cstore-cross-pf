import 'dart:convert';

import 'package:cstore/Model/response_model.dart/syncronise_response_model.dart';

import 'api.dart';
import 'response_handler.dart';
import 'package:http/http.dart' as http;

class SyncroniseHTTP {
  final ResponseHandler _handler = ResponseHandler();

  Future<SyncroniseResponseModel> fetchSyncroniseData(
      String userName, String token) async {
    const url = Api.SYNCRONISEVISIT;
    // print("--------------------------");
    // String token = GetUserDataAndUrl().getToken.toString();
    // print("+++++++++++++++++");
    // print(token);
    // print("bbbbbbbbbbbbbbbbbbb");

    // Map<String, String> headers = {
    //   'Authorization': 'Bearer $token',
    //   'Content-Type': 'application/json', // adjust content type if needed
    // };

    final response =
        await _handler.post(Uri.parse(url), {"username": userName}, token);

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
