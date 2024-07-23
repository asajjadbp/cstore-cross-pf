// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

FinishVisitRequestModel userResponseModelFromJson(String str) =>
    FinishVisitRequestModel.fromJson(json.decode(str));

String userRequestModelToJson(FinishVisitRequestModel data) =>
    json.encode(data.toJson());

class FinishVisitRequestModel {
  String username;
  String workingId;
  String checkOutGps;
  String storeId;
  String workingDate;

  FinishVisitRequestModel({
    required this.username,
    required this.workingId,
    required this.checkOutGps,
    required this.storeId,
    required this.workingDate
  });

  factory FinishVisitRequestModel.fromJson(Map<String, dynamic> json) =>
      FinishVisitRequestModel(
        username: json["username"],
        workingId: json["working_id"],
        checkOutGps: json["checkout_gps"],
        storeId: json["store_id"],
        workingDate: json["working_date"],
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    "working_id": workingId,
    "checkout_gps": checkOutGps,
    "store_id": storeId,
    "working_date": workingDate,
  };
}
