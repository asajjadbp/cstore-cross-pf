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
  String bucketName;
  String agency;
  String agencyPhoto;
  String updatedAt;

  Datum({
    required this.id,
    required this.licenseKey,
    required this.baseUrl,
    required this.imageReadUrl,
    required this.bucketName,
    required this.agency,
    required this.agencyPhoto,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        licenseKey: json["license_key"],
        baseUrl: json["base_url"],
        imageReadUrl: json["static_image_url"],
        bucketName: json["bucket_name"],
        agency: json["agency"],
        agencyPhoto: json["agancy_photo"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "license_key": licenseKey,
        "base_url": baseUrl,
        "static_image_url": imageReadUrl,
        "bucket_name": bucketName,
        "agency": agency,
        "agancy_photo":agencyPhoto,
        "updated_at": updatedAt,
      };
}
