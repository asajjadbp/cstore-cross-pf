class ReplenishShowModel {
  late int pro_id;
  late String pro_en_name;
  late String pro_ar_name;
  late String cat_en_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String img_name;
  late String reason;
  late int pricing_taken;
  late String promo_price;
  late String regular_price;
  late int upload_status;
  late int act_status;
  List<String>? reasonValue;


  ReplenishShowModel({
    required this.pro_id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.img_name,
    required this.reason,
    required this.pricing_taken,
    required this.promo_price,
    required this.regular_price,
    required this.upload_status,
    required this.act_status,
    required this.reasonValue,
  });

  Map<String, dynamic> toJson() => {
    'sku_id': pro_id.toString(),
    'cat_en_name': cat_en_name.toString(),
    'cat_ar_name': cat_ar_name.toString(),
    'brand_ar_name': brand_ar_name.toString(),
    'brand_en_name': brand_en_name.toString(),
    'pro_en_name': pro_ar_name.toString(),
    'pro_ar_name': pro_ar_name.toString(),
    'image': img_name.toString(),
    'reason': reason.toString(),
    'pricing_taken' : pricing_taken.toString(),
    'regular_price' : regular_price.toString(),
    'promo_price' : promo_price.toString(),
    'upload_status' : upload_status.toString(),
    'act_status' : act_status.toString(),
    'reason_value' : reasonValue,
  };

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
      'reason': this.reason,
      'pricing_taken': this.pricing_taken,
      'promo_price': this.promo_price,
      'regular_price': this.regular_price,
      'upload_status': this.upload_status,
      'act_status': this.act_status,
      'reason_value': this.reasonValue,
    };
  }

  factory ReplenishShowModel.fromMap(Map<String, dynamic> map) {
    return ReplenishShowModel(
      pro_id: map['pro_id'] as int,
      pro_en_name: map['pro_en_name'] ?? "",
      pro_ar_name: map['pro_ar_name'] ?? "",
      cat_en_name: map['cat_en_name'] ?? "",
      cat_ar_name: map['cat_ar_name'] ?? "",
      brand_en_name: map['brand_en_name'] ?? "",
      brand_ar_name: map['brand_ar_name'] ?? "",
      img_name: map['img_name'] ?? "",
      reason: map['reason'] ?? "",
      pricing_taken: map['pricing_taken'] ?? 0,
      promo_price: map['promo_price'],
      regular_price: map['regular_price'],
      upload_status: map['upload_status'] ??0,
      act_status: map['act_status'] ??0,
      reasonValue: map['reason_value'] ?? [],
    );
  }
}