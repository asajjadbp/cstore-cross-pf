// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

UserRequestModel userResponseModelFromJson(String str) =>
    UserRequestModel.fromJson(json.decode(str));

String userRequestModelToJson(UserRequestModel data) =>
    json.encode(data.toJson());

class UserRequestModel {
  String username;
  String password;
  String deviceToken;

  UserRequestModel({
    required this.username,
    required this.password,
    required this.deviceToken,
  });

  factory UserRequestModel.fromJson(Map<String, dynamic> json) =>
      UserRequestModel(
        username: json["username"],
        password: json["password"],
        deviceToken: json["device_token"]
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "device_token" : deviceToken,
      };
}
