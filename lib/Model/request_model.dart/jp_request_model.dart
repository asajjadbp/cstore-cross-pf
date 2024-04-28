// To parse this JSON data, do
//
//     final journeyPlanRequestModel = journeyPlanRequestModelFromJson(jsonString);

import 'dart:convert';

JourneyPlanRequestModel journeyPlanRequestModelFromJson(String str) =>
    JourneyPlanRequestModel.fromJson(json.decode(str));

String journeyPlanRequestModelToJson(JourneyPlanRequestModel data) =>
    json.encode(data.toJson());

class JourneyPlanRequestModel {
  String username;

  JourneyPlanRequestModel({
    required this.username,
  });

  factory JourneyPlanRequestModel.fromJson(Map<String, dynamic> json) =>
      JourneyPlanRequestModel(
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
      };
}
