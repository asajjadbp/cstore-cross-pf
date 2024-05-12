// To parse this JSON data, do
//
//     final dropVisitRequestModel = dropVisitRequestModelFromJson(jsonString);

import 'dart:convert';

DropVisitRequestModel dropVisitRequestModelFromJson(String str) =>
    DropVisitRequestModel.fromJson(json.decode(str));

String dropVisitRequestModelToJson(DropVisitRequestModel data) =>
    json.encode(data.toJson());

class DropVisitRequestModel {
  String username;
  String workingId;
  String dropReason;

  DropVisitRequestModel({
    required this.username,
    required this.workingId,
    required this.dropReason,
  });

  factory DropVisitRequestModel.fromJson(Map<String, dynamic> json) =>
      DropVisitRequestModel(
        username: json["username"],
        workingId: json["working_id"],
        dropReason: json["drop_reason"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "working_id": workingId,
        "drop_reason": dropReason,
      };
}
