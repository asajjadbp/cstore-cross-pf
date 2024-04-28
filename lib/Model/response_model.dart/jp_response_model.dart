// To parse this JSON data, do
//
//     final journeyPlanResponseModel = journeyPlanResponseModelFromJson(jsonString);

import 'dart:convert';

JourneyPlanResponseModel journeyPlanResponseModelFromJson(String str) =>
    JourneyPlanResponseModel.fromJson(json.decode(str));

String journeyPlanResponseModelToJson(JourneyPlanResponseModel data) =>
    json.encode(data.toJson());

class JourneyPlanResponseModel {
  bool status;
  String msg;
  List<Datum> data;

  JourneyPlanResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory JourneyPlanResponseModel.fromJson(Map<String, dynamic> json) =>
      JourneyPlanResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int workingId;
  String workingDate;
  int storeId;
  String enStoreName;
  String arStoreName;
  String gcode;
  String clientIds;
  int userId;
  dynamic checkIn;
  dynamic checkOut;
  dynamic startVisitPhoto;
  String checkinGps;
  String checkoutGps;
  String visitStatus;
  String visitType;
  String avlExclude;
  String otherExclude;
  int isDrop;

  Datum({
    required this.workingId,
    required this.workingDate,
    required this.storeId,
    required this.enStoreName,
    required this.arStoreName,
    required this.gcode,
    required this.clientIds,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.startVisitPhoto,
    required this.checkinGps,
    required this.checkoutGps,
    required this.visitStatus,
    required this.visitType,
    required this.avlExclude,
    required this.otherExclude,
    required this.isDrop,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        workingId: json["working_id"],
        workingDate: json["working_date"],
        storeId: json["store_id"],
        enStoreName: json["en_store_name"],
        arStoreName: json["ar_store_name"],
        gcode: json["gcode"],
        clientIds: json["client_ids"],
        userId: json["user_id"],
        checkIn: json["check_in"],
        checkOut: json["check_out"],
        startVisitPhoto: json["start_visit_photo"],
        checkinGps: json["checkin_gps"],
        checkoutGps: json["checkout_gps"],
        visitStatus: json["visit_status"],
        visitType: json["visit_type"],
        avlExclude: json["avl_exclude"],
        otherExclude: json["other_exclude"],
        isDrop: json["is_drop"],
      );

  Map<String, dynamic> toJson() => {
        "working_id": workingId,
        "working_date": workingDate,
        "store_id": storeId,
        "en_store_name": enStoreName,
        "ar_store_name": arStoreName,
        "gcode": gcode,
        "client_ids": clientIds,
        "user_id": userId,
        "check_in": checkIn,
        "check_out": checkOut,
        "start_visit_photo": startVisitPhoto,
        "checkin_gps": checkinGps,
        "checkout_gps": checkoutGps,
        "visit_status": visitStatus,
        "visit_type": visitType,
        "avl_exclude": avlExclude,
        "other_exclude": otherExclude,
        "is_drop": isDrop,
      };
}
