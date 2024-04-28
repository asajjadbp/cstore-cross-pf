// To parse this JSON data, do
//
//     final licenseResponseModel = licenseResponseModelFromJson(jsonString);

import 'dart:convert';

LicenseResponseModel licenseResponseModelFromJson(String str) =>
    LicenseResponseModel.fromJson(json.decode(str));

String licenseResponseModelToJson(LicenseResponseModel data) =>
    json.encode(data.toJson());

class LicenseResponseModel {
  bool status;
  String msg;
  List<Datum> data;

  LicenseResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory LicenseResponseModel.fromJson(Map<String, dynamic> json) =>
      LicenseResponseModel(
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
  int id;
  String licenseKey;
  String baseUrl;
  String imageReadUrl;
  String gcs;
  String agency;
  String updatedAt;

  Datum({
    required this.id,
    required this.licenseKey,
    required this.baseUrl,
    required this.imageReadUrl,
    required this.gcs,
    required this.agency,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        licenseKey: json["license_key"],
        baseUrl: json["base_url"],
        imageReadUrl: json["image_read_url"],
        gcs: json["gcs"],
        agency: json["agency"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "license_key": licenseKey,
        "base_url": baseUrl,
        "image_read_url": imageReadUrl,
        "gcs": gcs,
        "agency": agency,
        "updated_at": updatedAt,
      };
}
