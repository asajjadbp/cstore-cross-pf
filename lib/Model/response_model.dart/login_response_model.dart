// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) =>
    json.encode(data.toJson());

class UserResponseModel {
  bool status;
  String msg;
  Data data;

  UserResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  int username;
  String userPic;
  String enWelcomeMsg;
  String arWelcomeMsg;
  String userClient;
  String tokenId;
  int isSyncronize;

  Data({
    required this.username,
    required this.userPic,
    required this.enWelcomeMsg,
    required this.arWelcomeMsg,
    required this.userClient,
    required this.tokenId,
    required this.isSyncronize,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        username: json["username"],
        userPic: json["user_pic"],
        enWelcomeMsg: json["en_welcome_msg"],
        arWelcomeMsg: json["ar_welcome_msg"],
        userClient: json["user_client"],
        tokenId: json["token_id"],
        isSyncronize: json["is_syncronize"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "user_pic": userPic,
        "en_welcome_msg": enWelcomeMsg,
        "ar_welcome_msg": arWelcomeMsg,
        "user_client": userClient,
        "token_id": tokenId,
        "is_syncronize": isSyncronize,
      };
}
