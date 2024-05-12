// To parse this JSON data, do
//
//     final startVisitResponseModel = startVisitResponseModelFromJson(jsonString);

import 'dart:convert';

StartVisitResponseModel startVisitResponseModelFromJson(String str) =>
    StartVisitResponseModel.fromJson(json.decode(str));

String startVisitResponseModelToJson(StartVisitResponseModel data) =>
    json.encode(data.toJson());

class StartVisitResponseModel {
  bool status;
  String msg;
  List<dynamic> data;

  StartVisitResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory StartVisitResponseModel.fromJson(Map<String, dynamic> json) =>
      StartVisitResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
