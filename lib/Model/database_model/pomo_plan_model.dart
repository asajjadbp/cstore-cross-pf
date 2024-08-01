import '../../Database/table_name.dart';

class PromoPlanModel{

  late int promoId;
  late int skuId;
  late int storeId;
  late String from;
  late String to;
  late String osdType;
  late int quantity;
  late String promoScope;
  late int promoPrice;
  late String modalImage;
  late String leftOverAction;

  PromoPlanModel(
      {
        required this.promoId,
        required this.skuId,
        required this.storeId,
        required this.from,
        required this.to,
        required this.osdType,
        required this.quantity,
        required this.promoScope,
        required this.promoPrice,
        required this.modalImage,
        required this.leftOverAction,
      });

  Map<String, Object?> toMap() {
    return {
      "promo_id" : promoId,
      "sku_id" : skuId,
      "store_id" : storeId,
      "from" : from,
      "to" : to,
      "osd_type" : osdType,
      "qty" : quantity,
      "promo_scope" : promoScope,
      "promo_price" : promoPrice,
      'modal_image' : modalImage,
      "left_over_action" : leftOverAction,
    };
  }

  PromoPlanModel.fromJson(Map<String, dynamic> json) {
    promoId = json["promo_id"] ?? 0;
    skuId = json["sku_id"] ?? 0;
    storeId = json['store_id'] ?? 0;
    from = json["from"] ?? "";
    to = json["to"] ?? "";
    osdType = json["osd_type"] ?? "";
    quantity = json["qty"] ?? 0;
    promoScope = json["promo_scope"] ?? "";
    promoPrice = json["promo_price"] ?? 0;
    modalImage = json['modal_image'] ?? "";
    leftOverAction = json["left_over_action"] ?? "";
  }

  Map<String, dynamic> toJson() => {
    "promo_id" : promoId,
    "sku_id" : skuId,
    "store_id" : storeId,
    "from" : from,
    "to" : to,
    "osd_type" : osdType,
    "qty" : quantity,
    "promo_scope" : promoScope,
    "promo_price" : promoPrice,
    'modal_image' : modalImage,
    "left_over_action" : leftOverAction,
  };
}