import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class ResponseHandler {
  Future post(Uri url, Map<String, dynamic> reqMap) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http
          .post(url, body: reqMap, headers: head)
          .timeout(const Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      return responseJson;
    } on TimeoutException {
      // throw FetchDataException("Slow internet connection");
      throw "Slow Internet Connection";
    } on SocketException {
      // throw FetchDataException('No Internet connection');
      throw "No Iternet Connection";
    }
  }
}
