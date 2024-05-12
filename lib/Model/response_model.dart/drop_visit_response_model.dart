// To parse this JSON data, do
//
//     final dropVisitResponseModel = dropVisitResponseModelFromJson(jsonString);

import 'dart:convert';

DropVisitResponseModel dropVisitResponseModelFromJson(String str) =>
    DropVisitResponseModel.fromJson(json.decode(str));

String dropVisitResponseModelToJson(DropVisitResponseModel data) =>
    json.encode(data.toJson());

class DropVisitResponseModel {
  bool status;
  String msg;
  List<dynamic> data;

  DropVisitResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory DropVisitResponseModel.fromJson(Map<String, dynamic> json) =>
      DropVisitResponseModel(
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
