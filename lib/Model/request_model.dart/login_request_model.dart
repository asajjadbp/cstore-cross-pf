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

  UserRequestModel({
    required this.username,
    required this.password,
  });

  factory UserRequestModel.fromJson(Map<String, dynamic> json) =>
      UserRequestModel(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
