import 'dart:io';

import 'package:cstore/Model/database_model/sys_osdc_reason_model.dart';
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
  late String weekTitle;
  late String promoScope;
  late String promoPrice;
  late String imageName;
  File? imageFile;
  late String modalImage;
  late String leftOverAction;
  late int promoReasonId;
  late String promoStatus;
  late String osdType;
  late int actStatus;
  late int gcsStatus;
  late int uploadStatus;
  late Sys_OSDCReasonModel initialOsdcItem;

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
    required this.weekTitle,
    required this.promoPrice,
    required this.promoScope,
    required this.imageFile,
    required this.imageName,
    required this.modalImage,
    required this.leftOverAction,
    required this.promoReasonId,
    required this.promoStatus,
    required this.actStatus,
    required this.uploadStatus,
    required this.gcsStatus,
    required this.initialOsdcItem,
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
      'osd_type' :osdType.toString(),
      'sku_id': skuId,
      'promo_from': promoFrom.toString(),
      'promo_to': promoTo.toString(),
      'week_title': weekTitle.toString(),
      'promo_price': promoPrice.toString(),
      'promo_scope': promoScope.toString(),
      'image_name': imageName.toString(),
      'left_over_action': leftOverAction.toString(),
      'modal_image': modalImage.toString(),
      'promo_reason_id': promoReasonId.toString(),
      'promo_status': promoStatus.toString(),
      'act_status': actStatus,
      'upload_status': uploadStatus,
      'gcs_status': gcsStatus,
      'initial_osdc_item':initialOsdcItem,
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
    weekTitle = json['week_title'] ?? "";
    osdType = json['osd_type'] ?? "";
    promoPrice = json['promo_price'] ?? "0";
    promoScope = json['promo_scope'] ?? "";
    imageName = json['image_name'] ?? "";
    leftOverAction = json['left_over_action'] ?? "";
    modalImage = json['modal_image'] ?? "";
    promoReasonId = json['promo_reason_id'] ?? "";
    promoStatus = json['promo_status'] ?? "";
    actStatus = json['act_status'] ?? 0;
    uploadStatus = json['upload_status'] ?? 0;
    gcsStatus = json['gcs_status'] ?? 0;
    initialOsdcItem = json['initial_osdc_item'];
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
    'osd_type': osdType.toString(),
    'sku_id': skuId,
    'promo_from': promoFrom.toString(),
    'promo_to': promoTo.toString(),
    'week_title': weekTitle.toString(),
    'promo_price': promoPrice.toString(),
    'promo_scope' : promoScope.toString(),
    'image_name' : imageName.toString(),
    'left_over_action' : leftOverAction.toString(),
    'modal_image' : modalImage.toString(),
    'promo_reason_id' : promoReasonId.toString(),
    'promo_status' : promoStatus.toString(),
    'act_status':  actStatus,
    'upload_status': uploadStatus,
    'gcs_status':  gcsStatus,
    'initial_osdc_item':  initialOsdcItem,
  };
}