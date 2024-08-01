import 'dart:io';
class TransPromoPlanListModel {
  late String skuEnName;
  late String skuArName;
  late String skuImageName;
  late String catEnName;
  late String catArName;
  late String brandEnName;
  late String brandArName;
  late int promoId;
  late int skuId;
  late String promoFrom;
  late String promoTo;
  late String osdType;
  late int quantity;
  late String promoScope;
  late int promoPrice;
  late String imageName;
  File? imageFile;
  late String modalImage;
  late String leftOverAction;
  late String promoReason;
  late String promoStatus;
  late int actStatus;
  late int gcsStatus;
  late int uploadStatus;

  TransPromoPlanListModel({
    required this.promoId,
    required this.skuEnName,
    required this.skuArName,
    required this.skuImageName,
    required this.catEnName,
    required this.catArName,
    required this.brandEnName,
    required this.brandArName,
    required this.skuId,
    required this.promoFrom,
    required this.promoTo,
    required this.osdType,
    required this.quantity,
    required this.promoPrice,
    required this.promoScope,
    required this.imageFile,
    required this.imageName,
    required this.modalImage,
    required this.leftOverAction,
    required this.promoReason,
    required this.promoStatus,
    required this.actStatus,
    required this.uploadStatus,
    required this.gcsStatus,
  });
  Map<String, Object?> toMap() {
    return {
      'promo_id': promoId.toString(),
      'pro_en_name': skuEnName.toString(),
      'pro_ar_name': skuArName.toString(),
      'pro_image_name':skuImageName.toString(),
      'cat_en_name': catEnName.toString(),
      'cat_ar_name' : catArName.toString(),
      'brand_en_name' : brandEnName.toString(),
      'brand_ar_name' : brandArName.toString(),
      'sku_id': skuId,
      'promo_from': promoFrom.toString(),
      'promo_to': promoTo.toString(),
      'osd_type': osdType.toString(),
      'qty': quantity,
      'promo_price': promoPrice,
      'promo_scope': promoScope.toString(),
      'image_name': imageName.toString(),
      'left_over_action': leftOverAction.toString(),
      'modal_image': modalImage.toString(),
      'promo_reason': promoReason.toString(),
      'promo_status': promoStatus.toString(),
      'act_status': actStatus,
      'upload_status': uploadStatus,
      'gcs_status': gcsStatus,
    };
  }
  TransPromoPlanListModel.fromJson(Map<String, dynamic> json) {
    promoId = json['promo_id'];
    skuEnName = json['pro_en_name'] ?? "";
    skuArName = json['pro_ar_name'] ?? "";
    skuImageName = json['sku_image_name'] ?? "";
    catEnName = json['cat_en_name'] ?? "";
    catArName = json['car_ar_name'] ?? "";
    brandEnName = json['brand_en_name'] ?? "";
    brandArName = json['brand_ar_name'] ?? "";
    skuId = json['sku_id'] ?? 0;
    promoFrom = json['promo_from'] ?? "";
    promoTo = json['promo_to'] ?? "";
    osdType = json['osd_type'] ?? "";
    quantity = json['qty'] ?? "";
    promoPrice = json['promo_price'] ?? 0;
    promoScope = json['promo_scope'] ?? "";
    imageName = json['image_name'] ?? "";
    leftOverAction = json['left_over_action'] ?? "";
    modalImage = json['modal_image'] ?? "";
    promoReason = json['promo_reason'] ?? "";
    promoStatus = json['promo_status'] ?? "";
    actStatus = json['act_status'] ?? 0;
    uploadStatus = json['upload_status'] ?? 0;
    gcsStatus = json['gcs_status'] ?? 0;
  }
  Map<String, dynamic> toJson() => {
    'promo_id': promoId.toString(),
    'pro_en_name': skuEnName.toString(),
    'pro_ar_name': skuArName.toString(),
    'pro_image_name':skuImageName.toString(),
    'cat_en_name': catEnName.toString(),
    'cat_ar_name' : catArName.toString(),
    'brand_en_name' : brandEnName.toString(),
    'brand_ar_name' : brandArName.toString(),
    'sku_id': skuId,
    'promo_from': promoFrom.toString(),
    'promo_to': promoTo.toString(),
    'osd_type': osdType.toString(),
    'qty':  quantity,
    'promo_price': promoPrice,
    'promo_scope' : promoScope.toString(),
    'image_name' : imageName.toString(),
    'left_over_action' : leftOverAction.toString(),
    'modal_image' : modalImage.toString(),
    'promo_reason' : promoReason.toString(),
    'promo_status' : promoStatus.toString(),
    'act_status':  actStatus,
    'upload_status': uploadStatus,
    'gcs_status':  gcsStatus,
  };
}