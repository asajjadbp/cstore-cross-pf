// To parse this JSON data, do
//
//     final syncroniseResponseModel = syncroniseResponseModelFromJson(jsonString);

import 'dart:convert';

SyncroniseResponseModel syncroniseResponseModelFromJson(String str) =>
    SyncroniseResponseModel.fromJson(json.decode(str));

String syncroniseResponseModelToJson(SyncroniseResponseModel data) =>
    json.encode(data.toJson());

class SyncroniseResponseModel {
  bool status;
  String msg;
  List<SyncroniseDetail> data;

  SyncroniseResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SyncroniseResponseModel.fromJson(Map<String, dynamic> json) =>
      SyncroniseResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<SyncroniseDetail>.from(
            json["data"].map((x) => SyncroniseDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SyncroniseDetail {
  List<Sys> sysDropReason;
  List<SysAgencyDashboard> sysAgencyDashboard;
  List<SysClient> sysClient;
  List<Sys> sysCategory;

  SyncroniseDetail({
    required this.sysDropReason,
    required this.sysAgencyDashboard,
    required this.sysClient,
    required this.sysCategory,
  });

  factory SyncroniseDetail.fromJson(Map<String, dynamic> json) =>
      SyncroniseDetail(
        sysDropReason:
            List<Sys>.from(json["sys_drop_reason"].map((x) => Sys.fromJson(x))),
        sysAgencyDashboard: List<SysAgencyDashboard>.from(
            json["sys_agency_dashboard"]
                .map((x) => SysAgencyDashboard.fromJson(x))),
        sysClient: List<SysClient>.from(
            json["sys_client"].map((x) => SysClient.fromJson(x))),
        sysCategory:
            List<Sys>.from(json["sys_category"].map((x) => Sys.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sys_drop_reason":
            List<dynamic>.from(sysDropReason.map((x) => x.toJson())),
        "sys_agency_dashboard":
            List<dynamic>.from(sysAgencyDashboard.map((x) => x.toJson())),
        "sys_client": List<dynamic>.from(sysClient.map((x) => x.toJson())),
        "sys_category": List<dynamic>.from(sysCategory.map((x) => x.toJson())),
      };
}

class SysAgencyDashboard {
  int? id;
  String enName;
  String arName;
  String iconSvg;
  int? startDate;
  int? endDate;
  int status;

  SysAgencyDashboard({
    required this.id,
    required this.enName,
    required this.arName,
    required this.iconSvg,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory SysAgencyDashboard.fromJson(Map<String, dynamic> json) =>
      SysAgencyDashboard(
        id: json["id"] ?? 1,
        enName: json["en_name"],
        arName: json["ar_name"],
        iconSvg: json["icon_svg"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "ar_name": arName,
        "icon_svg": iconSvg,
        "start_date": startDate,
        "end_date": endDate,
        "status": status,
      };
}

class Sys {
  int id;
  String enName;
  String? arName;
  int? clientId;
  int? status;

  Sys({
    required this.id,
    required this.enName,
    required this.arName,
    this.clientId,
    this.status,
  });

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
        id: json["id"],
        enName: json["en_name"],
        arName: json["ar_name"],
        clientId: json["client_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "ar_name": arName,
        "client_id": clientId,
        "status": status,
      };
}

class SysClient {
  int clientId;
  String clientName;
  String logo;
  int? isClassification;
  int? isChainSkuCodes;
  int? isDayFreshness;
  int? isGeoRequired;
  int? isSuggetedOrderAvl;
  int? isSurvey;

  SysClient({
    required this.clientId,
    required this.clientName,
    required this.logo,
    required this.isClassification,
    required this.isChainSkuCodes,
    required this.isDayFreshness,
    required this.isGeoRequired,
    required this.isSuggetedOrderAvl,
    required this.isSurvey,
  });

  factory SysClient.fromJson(Map<String, dynamic> json) => SysClient(
        clientId: json["client_id"],
        clientName: json["client_name"],
        logo: json["logo"],
        isClassification: json["is_classification"],
        isChainSkuCodes: json["is_chain_sku_codes"],
        isDayFreshness: json["is_day_freshness"],
        isGeoRequired: json["is_geo_required"],
        isSuggetedOrderAvl: json["is_suggeted_order_avl"],
        isSurvey: json["is_survey"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name": clientName,
        "logo": logo,
        "is_classification": isClassification,
        "is_chain_sku_codes": isChainSkuCodes,
        "is_day_freshness": isDayFreshness,
        "is_geo_required": isGeoRequired,
        "is_suggeted_order_avl": isSuggetedOrderAvl,
        "is_survey": isSurvey,
      };
}
