import 'dart:convert';

TmrPickListRequestModel tmrPickListRequestModelFromJson(String str) =>
    TmrPickListRequestModel.fromJson(json.decode(str));

String tmrPickListRequestModelToJson(TmrPickListRequestModel data) =>
    json.encode(data.toJson());

class TmrPickListRequestModel {
  String username;
  String workingId;

  TmrPickListRequestModel({
    required this.username,
    required this.workingId,
  });

  factory TmrPickListRequestModel.fromJson(Map<String, dynamic> json) =>
      TmrPickListRequestModel(
        username: json["username"],
          workingId: json['working_id'],
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    'working_id':workingId
  };
}