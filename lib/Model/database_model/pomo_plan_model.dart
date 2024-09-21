import '../../Database/table_name.dart';

class PromoPlanModel{

  late int skuId;
  late String productCode;
  late String skuEnName;
  late String skuArName;
  late String categoryEnName;
  late String categoryArName;
  late int storeId;
  late String from;
  late String to;
  late String promoScope;
  late String promoScopeOther;
  late String weekTitle;
  late String modalImage;
  late String osdType;
  late String leftOverAction;
  late String promoPrice;
  late int companyId;

  PromoPlanModel(
      {
        required this.skuId,
        required this.productCode,
        required this.skuEnName,
        required this.skuArName,
        required this.categoryEnName,
        required this.categoryArName,
        required this.storeId,
        required this.from,
        required this.to,
        required this.promoScope,
        required this.promoScopeOther,
        required this.weekTitle,
        required this.modalImage,
        required this.companyId,
        required this.osdType,
        required this.leftOverAction,
        required this.promoPrice,

      });

  Map<String, Object?> toMap() {
    return {
      "bp_product_code" : productCode,
      "sku_id" : skuId,
      "en_sku_name" : skuEnName,
      "ar_sku_name" : skuArName,
      "en_category_name" : categoryEnName,
      "ar_category_name" : categoryArName,
      "store_id" : storeId,
      "from" : from,
      "to" : to,
      "promo_scope" : promoScope,
      "promo_scope_other" : promoScopeOther,
      "week_title" : weekTitle,
      'modal_picture' : modalImage,
      "company_id" : companyId,
      "osd_type" : osdType,
      'left_over_action' : leftOverAction,
      "pricing_of_promo" : promoPrice.toString(),
    };
  }

  PromoPlanModel.fromJson(Map<String, dynamic> json) {

    skuId = json["sku_id"] ?? 0;
    productCode = json["bp_product_code"] ?? 0;
    skuEnName = json["en_sku_name"] ?? "";
    skuArName = json["ar_sku_name"] ?? "";
    categoryEnName = json["en_category_name"] ?? "";
    categoryArName = json["ar_category_name"] ?? "";
    storeId = json['store_id'] ?? 0;
    from = json["from"] ?? "";
    to = json["to"] ?? "";
    promoScope = json["promo_scope"] ?? "";
    promoScopeOther = json["promo_scope_other"] ?? "";
    weekTitle = json["week_title"] ?? "";
    modalImage = json['modal_picture'] ?? "";
    companyId = json["company_id"] ?? 0;
    osdType = json["osd_type"] ?? "";
    leftOverAction = json["left_over_action"] ?? "";
    promoPrice = json["pricing_of_promo"].toString() == "null" ? "0" : promoPrice = json["pricing_of_promo"].toString();

  }

  Map<String, dynamic> toJson() => {

    "sku_id" : skuId,
    "bp_product_code" : productCode,
    "en_sku_name" : skuEnName,
    "ar_sku_name" : skuArName,
    "en_category_name" : categoryEnName,
    "ar_category_name" : categoryArName,
    'modal_picture' : modalImage,
    "from" : from,
    "to" : to,
    "promo_scope" : promoScope,
    "promo_scope_other" : promoScopeOther,
    "week_title" : weekTitle,
    "store_id" : storeId,
    "company_id" : companyId,
    "osd_type" : osdType,
    'left_over_action' : leftOverAction,
    "pricing_of_promo" : promoPrice.toString(),
  };
}