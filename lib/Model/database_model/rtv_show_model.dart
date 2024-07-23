import 'dart:io';
class RTVShowModel {
  late int pro_id;
  late String pro_en_name;
  late String pro_ar_name;
  late String cat_en_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String img_name;
  File? imageFile;
  late String rsp;
  late int rtv_taken;
  late int pieces;
  late int act_status;
  RTVShowModel({
    required this.pro_id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.img_name,
    required this.imageFile,
    required this.rsp,
    required this.pieces,
    required this.rtv_taken,
    required this.act_status,
  });
  Map<String, Object?> toMap() {
    return {
      'sku_id': pro_id.toString(),
      'cat_en_name': cat_en_name.toString(),
      'cat_ar_name': cat_ar_name.toString(),
      'brand_en_name': brand_en_name.toString(),
      'brand_ar_name': brand_ar_name.toString(),
      'pro_en_name': pro_en_name.toString(),
      'pro_ar_name': pro_ar_name.toString(),
      'image': img_name.toString(),
      'rsp': rsp.toString(),
      'rtv_taken': rtv_taken.toString(),
      'pieces': pieces.toString(),
      'act_status': act_status,
    };
  }
  RTVShowModel.fromJson(Map<String, dynamic> json) {
    pro_id = json['sku_id'];
    cat_en_name = json['cat_en_name'] ?? "";
    cat_ar_name = json['cat_ar_name'] ?? "";
    brand_en_name = json['brand_en_name'] ?? "";
    brand_ar_name = json['brand_ar_name'] ?? "";
    pro_en_name = json['pro_en_name'] ?? "";
    pro_ar_name = json['pro_ar_name'] ?? "";
    img_name = json['image'] ?? "";
    rsp = json['rsp'] ?? "";
    rtv_taken = json['rtv_taken'] ?? 0;
    pieces = json['pieces'] ?? 0;
    act_status = json['act_status'] ?? 0;
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
    'rtv_taken' : rtv_taken.toString(),
    'pieces' : pieces.toString(),
    'act_status' : act_status.toString(),
  };
}
class RTVCountModel {
  late int total_rtv_pro;
  late int total_volume;
   late int total_value;

  RTVCountModel({required this.total_rtv_pro, required this.total_volume,required this.total_value});
  Map<String, dynamic> toJson() {
    return {
      'total_rtv_pro': total_rtv_pro,
      'total_volume': total_volume,
      'total_value' : total_value,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory RTVCountModel.fromJson(Map<String, dynamic> json) {
    return RTVCountModel(
      total_rtv_pro: json['total_rtv_pro'],
      total_volume: json['total_volume'],
      total_value: json['total_value'],
    );
  }
}