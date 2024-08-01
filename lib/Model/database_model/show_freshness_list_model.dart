import 'dart:io';

class FreshnessListShowModel {
  late int pro_id;
  late String pro_en_name;
  late String pro_ar_name;
  late String cat_en_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String img_name;
  late String rsp;
  late int freshness_taken;
  late int upload_status;
  late int activity_status;

  FreshnessListShowModel.fromJson(Map<String, dynamic> json) {
    pro_id = json['sku_id'];
    cat_en_name = json['cat_en_name'] ?? "";
    cat_ar_name = json['cat_ar_name'] ?? "";
    brand_en_name = json['brand_en_name'] ?? "";
    brand_ar_name = json['brand_ar_name'] ?? "";
    pro_en_name = json['pro_en_name'] ?? "";
    pro_ar_name = json['pro_ar_name'] ?? "";
    img_name = json['image'] ?? "";
    rsp = json['rsp'] ?? "";
    freshness_taken = json['freshness_taken'] ?? 0;
    activity_status = json['act_status'] ?? 0;
    upload_status = json['upload_status'] ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'sku_id': pro_id.toString(),
        'cat_en_name': cat_en_name.toString(),
        'cat_ar_name': cat_ar_name.toString(),
        'brand_ar_name': brand_ar_name.toString(),
        'brand_en_name': brand_en_name.toString(),
        'pro_en_name': pro_ar_name.toString(),
        'pro_ar_name': pro_ar_name.toString(),
        'image': img_name.toString(),
        'rsp': rsp.toString(),
        'freshness_taken': freshness_taken.toString(),
        'act_status': activity_status.toString(),
        'upload_status': upload_status.toString(),
      };

  FreshnessListShowModel({
    required this.pro_id,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.img_name,
    required this.rsp,
    required this.freshness_taken,
    required this.activity_status,
    required this.upload_status,
  });

  Map<String, dynamic> toMap() {
    return {
      'pro_id': this.pro_id,
      'pro_en_name': this.pro_en_name,
      'pro_ar_name': this.pro_ar_name,
      'cat_en_name': this.cat_en_name,
      'cat_ar_name': this.cat_ar_name,
      'brand_en_name': this.brand_en_name,
      'brand_ar_name': this.brand_ar_name,
      'img_name': this.img_name,
      'rsp': this.rsp,
      'freshness_taken': this.freshness_taken,
      'act_status': this.activity_status,
      'upload_status': this.upload_status,
    };
  }

  factory FreshnessListShowModel.fromMap(Map<String, dynamic> map) {
    return FreshnessListShowModel(
      pro_id: map['pro_id'] as int,
      pro_en_name: map['pro_en_name'] as String,
      pro_ar_name: map['pro_ar_name'] as String,
      cat_en_name: map['cat_en_name'] as String,
      cat_ar_name: map['cat_ar_name'] as String,
      brand_en_name: map['brand_en_name'] as String,
      brand_ar_name: map['brand_ar_name'] as String,
      img_name: map['img_name'] as String,
      rsp: map['rsp'] as String,
      freshness_taken: map['freshness_taken'] as int,
      activity_status: map['act_status'] as int,
      upload_status: map['upload_status'] as int,
    );
  }
}
