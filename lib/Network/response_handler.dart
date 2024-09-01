import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cstore/screens/utils/services/vpn_detector.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_exceptions.dart';
// import 'package:http/retry.dart';

class ResponseHandler {
  Future post(Uri url, Map<String, dynamic> reqMap, String bearerToken) async {
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
      // bool isVpnConnected = await vpnDetector();
      // if(isVpnConnected) throw FetchDataException("Please Disable Your Vpn");
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
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future postWithJson(Uri url, Map<String, dynamic> reqMap, String bearerToken) async {
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
      // bool isVpnConnected = await vpnDetector();
      // if(isVpnConnected) throw FetchDataException("Please Disable Your Vpn");
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
    } on TimeoutException {
      throw FetchDataException("Slow internet connection".tr);
    } on SocketException {
      throw FetchDataException('No Internet connection'.tr);
    }
  }
}
