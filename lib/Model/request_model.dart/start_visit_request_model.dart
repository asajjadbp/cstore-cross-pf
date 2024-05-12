// To parse this JSON data, do
//
//     final startVisitRequestModel = startVisitRequestModelFromJson(jsonString);

import 'dart:convert';

StartVisitRequestModel startVisitRequestModelFromJson(String str) =>
    StartVisitRequestModel.fromJson(json.decode(str));

String startVisitRequestModelToJson(StartVisitRequestModel data) =>
    json.encode(data.toJson());

class StartVisitRequestModel {
  String username;
  String workingId;
  String storeImageData;
  String checkinGps;
  String clientIds;
  String comment;

  StartVisitRequestModel({
    required this.username,
    required this.workingId,
    required this.storeImageData,
    required this.checkinGps,
    required this.clientIds,
    required this.comment,
  });

  factory StartVisitRequestModel.fromJson(Map<String, dynamic> json) =>
      StartVisitRequestModel(
        username: json["username"],
        workingId: json["working_id"],
        storeImageData: json["store_image_data"],
        checkinGps: json["checkin_gps"],
        clientIds: json["client_ids"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "working_id": workingId,
        "store_image_data": storeImageData,
        "checkin_gps": checkinGps,
        "client_ids": clientIds,
        "comment": comment,
      };
}
