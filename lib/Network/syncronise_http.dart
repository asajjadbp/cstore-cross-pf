// import 'dart:convert';

import 'dart:convert';

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

    print(url);
    print(token);

    var response;
    await Future.delayed(const Duration(seconds: 0)).then((value) async {
      response = await _handler.post(Uri.parse(url), JourneyPlanRequestModel(username: userName).toJson(), token);
    });

    SyncroniseResponseModel syncResponseData =
        SyncroniseResponseModel.fromJson(response);

    print("_____________JSON DATA_______________");
    print(jsonEncode(syncResponseData.data[0].sysStorePog));
    print("_________________________________");


    return syncResponseData;
  }
}
