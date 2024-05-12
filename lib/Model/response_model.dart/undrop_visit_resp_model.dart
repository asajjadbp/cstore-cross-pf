// To parse this JSON data, do
//
//     final unDropVisitResponseModel = unDropVisitResponseModelFromJson(jsonString);

import 'dart:convert';

UnDropVisitResponseModel unDropVisitResponseModelFromJson(String str) =>
    UnDropVisitResponseModel.fromJson(json.decode(str));

String unDropVisitResponseModelToJson(UnDropVisitResponseModel data) =>
    json.encode(data.toJson());

class UnDropVisitResponseModel {
  bool status;
  String msg;
  List<dynamic> data;

  UnDropVisitResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory UnDropVisitResponseModel.fromJson(Map<String, dynamic> json) =>
      UnDropVisitResponseModel(
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
