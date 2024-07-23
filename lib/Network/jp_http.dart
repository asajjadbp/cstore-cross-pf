import 'dart:convert';

import 'package:cstore/Model/request_model.dart/drop_visit_request_model.dart';
import 'package:cstore/Model/request_model.dart/jp_request_model.dart';
import 'package:cstore/Model/request_model.dart/start_visit_request_model.dart';
import 'package:cstore/Model/request_model.dart/undrop_visit_req_model.dart';
import 'package:cstore/Model/response_model.dart/drop_visit_response_model.dart';
import 'package:cstore/Model/response_model.dart/undrop_visit_resp_model.dart';
import 'package:cstore/Network/api.dart';

import '../Model/request_model.dart/finish_visit_request_model.dart';
import '../Model/response_model.dart/jp_response_model.dart';
import '../Model/response_model.dart/start_visit_response_model.dart';
import '../Model/response_model.dart/user_dashboard_model.dart';
import 'response_handler.dart';
import 'package:http/http.dart' as http;

class JourneyPlanHTTP {
  final ResponseHandler _handler = ResponseHandler();

  Future<UserDashboardListResponseModel> getUserDashboard(
      String username, String token, String baseUrl) async {
    var url = baseUrl + Api.USER_DASHBOARD_API;
    final response = await _handler.post(Uri.parse(url),
        JourneyPlanRequestModel(username: username).toJson(), token);
    UserDashboardListResponseModel userDashboardListResponseModel = UserDashboardListResponseModel.fromJson(response);
    return userDashboardListResponseModel;
  }

  Future<JourneyPlanResponseModel> getJourneyPlan(
      String username, String token, String baseUrl) async {
    print(token);

    final url = baseUrl + Api.GETJOURNEYPLAN;

    print(url);

    final response = await _handler.post(Uri.parse(url),
        JourneyPlanRequestModel(username: username).toJson(), token);

    print(response);

    JourneyPlanResponseModel jpResponseData =
        JourneyPlanResponseModel.fromJson(response);

    // StoreLicense.storeBaseUrl(licenseResponseData);

    // print(licenseResponseData.data[0].baseUrl);
    return jpResponseData;
  }

  Future<DropVisitResponseModel> dropVisit(String username, String workingID,
      String dropReason, String token, String baseUrl) async {
    final url = baseUrl + Api.DROPVISIT;

    final response = await _handler.post(
        Uri.parse(url),
        DropVisitRequestModel(
                username: username,
                workingId: workingID,
                dropReason: dropReason)
            .toJson(),
        token);

    DropVisitResponseModel dropVisitResponseData =
        DropVisitResponseModel.fromJson(response);

    return dropVisitResponseData;
  }

  Future<UnDropVisitResponseModel> unDropVisit(
      String username, String workingID, String token, String baseUrl) async {
    final url = baseUrl + Api.UNDROPVISIT;

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
      String token,
      String baseUrl) async {
    final url = baseUrl + Api.STARTVISIT;
    print("journey plan url");
    print(workingID);

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

  Future<dynamic> finishVisit(String token, String baseUrl,FinishVisitRequestModel finishVisitRequestModel) async {
    final url = baseUrl + Api.finishVisit;

    print(jsonEncode(finishVisitRequestModel));
    final response = await _handler.post(Uri.parse(url), finishVisitRequestModel.toJson(), token);

    // final response = await http
    //     .post(Uri.parse(url), headers: headers, body: {"username": ""});
    // final responseData = jsonDecode(response.body);

    return response;
  }
}
