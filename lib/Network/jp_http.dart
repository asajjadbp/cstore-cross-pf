import 'dart:convert';

import 'package:cstore/Model/request_model.dart/drop_visit_request_model.dart';
import 'package:cstore/Model/request_model.dart/start_visit_request_model.dart';
import 'package:cstore/Model/request_model.dart/undrop_visit_req_model.dart';
import 'package:cstore/Model/response_model.dart/drop_visit_response_model.dart';
import 'package:cstore/Model/response_model.dart/undrop_visit_resp_model.dart';
import 'package:cstore/Network/api.dart';
import 'package:cstore/Network/getUserData/base_url_and_user.dart';

import '../Model/response_model.dart/jp_response_model.dart';
import '../Model/response_model.dart/start_visit_response_model.dart';
import 'response_handler.dart';
import 'package:http/http.dart' as http;

class JourneyPlanHTTP {
  final ResponseHandler _handler = ResponseHandler();

  Future<JourneyPlanResponseModel> getJourneyPlan(
      String username, String token) async {
    print(token);

    const url = Api.GETJOURNEYPLAN;
    // print("--------------------------");
    // String token = GetUserDataAndUrl().getToken.toString();
    // print("+++++++++++++++++");
    // print(token);
    // print("bbbbbbbbbbbbbbbbbbb");

    // Map<String, String> headers = {
    //   'Authorization': 'Bearer $bearerToken',
    //   'Content-Type': 'application/json', // adjust content type if needed
    // };

    final response =
        await _handler.post(Uri.parse(url), {"username": username}, token);

    // final response = await http
    //     .post(Uri.parse(url), headers: headers, body: {"username": ""});
    // final responseData = jsonDecode(response.body);
    print("some thing went");
    print(response);

    JourneyPlanResponseModel jpResponseData =
        JourneyPlanResponseModel.fromJson(response);
    print("test 1");
    // StoreLicense.storeBaseUrl(licenseResponseData);

    // print(licenseResponseData.data[0].baseUrl);
    return jpResponseData;
  }

  Future<DropVisitResponseModel> dropVisit(String username, String workingID,
      String dropReason, String token) async {
    const url = Api.DROPVISIT;
    // Map<String, String> headers = {
    //   'Authorization': 'Bearer $bearerToken',
    //   'Content-Type': 'application/json', // adjust content type if needed
    // };

    final response = await _handler.post(
        Uri.parse(url),
        DropVisitRequestModel(
                username: username,
                workingId: workingID,
                dropReason: dropReason)
            .toJson(),
        token);

    // final response = await http
    //     .post(Uri.parse(url), headers: headers, body: {"username": ""});
    // final responseData = jsonDecode(response.body);

    DropVisitResponseModel dropVisitResponseData =
        DropVisitResponseModel.fromJson(response);

    return dropVisitResponseData;
  }

  Future<UnDropVisitResponseModel> unDropVisit(
      String username, String workingID, String token) async {
    const url = Api.UNDROPVISIT;
    // Map<String, String> headers = {
    //   'Authorization': 'Bearer $bearerToken',
    //   'Content-Type': 'application/json', // adjust content type if needed
    // };

    final response = await _handler.post(
        Uri.parse(url),
        UnDropVisitRequestModel(
          username: username,
          workingId: workingID,
        ).toJson(),
        token);

    // final response = await http
    //     .post(Uri.parse(url), headers: headers, body: {"username": ""});
    // final responseData = jsonDecode(response.body);

    UnDropVisitResponseModel undropVisitResponseData =
        UnDropVisitResponseModel.fromJson(response);

    return undropVisitResponseData;
  }

  Future<StartVisitResponseModel> startVisit(
      String username,
      String workingID,
      String storeImage,
      String lat,
      String long,
      String clientIds,
      String commentText,
      String token) async {
    const url = Api.STARTVISIT;

    final response = await _handler.post(
        Uri.parse(url),
        StartVisitRequestModel(
                username: username,
                workingId: workingID,
                storeImageData: storeImage,
                checkinGps: "$lat,$long",
                clientIds: clientIds,
                comment: commentText)
            .toJson(),
        token);

    // final response = await http
    //     .post(Uri.parse(url), headers: headers, body: {"username": ""});
    // final responseData = jsonDecode(response.body);

    StartVisitResponseModel startVisitResponseData =
        StartVisitResponseModel.fromJson(response);

    return startVisitResponseData;
  }
}
