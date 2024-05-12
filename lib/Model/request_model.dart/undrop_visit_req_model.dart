// To parse this JSON data, do
//
//     final unDropVisitRequestModel = unDropVisitRequestModelFromJson(jsonString);

import 'dart:convert';

UnDropVisitRequestModel unDropVisitRequestModelFromJson(String str) =>
    UnDropVisitRequestModel.fromJson(json.decode(str));

String unDropVisitRequestModelToJson(UnDropVisitRequestModel data) =>
    json.encode(data.toJson());

class UnDropVisitRequestModel {
  String username;
  String workingId;

  UnDropVisitRequestModel({
    required this.username,
    required this.workingId,
  });

  factory UnDropVisitRequestModel.fromJson(Map<String, dynamic> json) =>
      UnDropVisitRequestModel(
        username: json["username"],
        workingId: json["working_id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "working_id": workingId,
      };
}
