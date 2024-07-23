import 'dart:io';
class ShowTransRTVShowModel {
  late int id;
  late int sku_id;
  late String pro_en_name;
  late String pro_ar_name;
  late String reason_en_name;
  late String reason_ar_name;
  late String pro_image;
  late String rtv_image;
  late int pieces;
  late int gcs_status;
  late int upload_status;
  late String exp_date;
  late String dateTime;
  File? imageFile;
  ShowTransRTVShowModel({
    required this.id,
    required this.sku_id,
    required this.reason_en_name,
    required this.reason_ar_name,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.pro_image,
    required this.rtv_image,
    required this.pieces,
    required this.upload_status,
    required this.gcs_status,
    required this.exp_date,
    required this.dateTime,
    required this.imageFile,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'sku_id': this.sku_id,
      'pro_en_name': this.pro_en_name,
      'pro_ar_name': this.pro_ar_name,
      'reason_en_name': this.reason_en_name,
      'reason_ar_name': this.reason_ar_name,
      'pro_image': this.pro_image,
      'rtv_image': this.rtv_image,
      'pieces': this.pieces,
      "imageFile":imageFile,
      'exp_date': this.exp_date,
      'dateTime': this.dateTime,
    };
  }

  factory ShowTransRTVShowModel.fromMap(Map<String, dynamic> map) {
    return ShowTransRTVShowModel(
      id: map['id'] as int,
      sku_id: map['sku_id'] as int,
      pro_en_name: map['pro_en_name'] as String,
      pro_ar_name: map['pro_ar_name'] as String,
      reason_en_name: map['reason_en_name'] as String,
      reason_ar_name: map['reason_ar_name'] as String,
      pro_image: map['pro_image'] as String,
      rtv_image: map['rtv_image'] as String,
      pieces: map['pieces'] as int,
      upload_status: map['upload_status'] as int,
      gcs_status: map['gcs_status'] as int,
      exp_date: map['exp_date'] as String,
      dateTime: map['dateTime'] as String,
      imageFile: null,
    );
  }

  @override
  String toString() {
    return 'ShowTransRTVShowModel{id: $id, sku_id: $sku_id, pro_en_name: $pro_en_name, pro_ar_name: $pro_ar_name, reason_en_name: $reason_en_name, reason_ar_name: $reason_ar_name, pro_image: $pro_image, rtv_image: $rtv_image, pieces: $pieces, gcs_status: $gcs_status, upload_status: $upload_status, exp_date: $exp_date, dateTime: $dateTime, imageFile: $imageFile}';
  }
}
