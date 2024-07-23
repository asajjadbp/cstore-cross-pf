import '../../database/table_name.dart';

class TransPricingModel {
  late int id;
  late int sku_id;
  late String regular_price;
  late  String promo_price;
  late final int working_id;

  TransPricingModel({
    required this.sku_id,
    required this.regular_price,
    required this.promo_price,
    required this.working_id,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.trans_pricing_sku_id: sku_id,
      TableName.trans_pricing_regular: regular_price,
      TableName.trans_pricing_promo: promo_price,
      TableName.trans_pricing_working_id: working_id,
    };
  }
  TransPricingModel.fromJson(Map<String, dynamic> json) {
    sku_id = json[TableName.trans_pricing_sku_id];
    regular_price = json[TableName.trans_pricing_regular];
    promo_price = json[TableName.trans_pricing_promo];
    working_id = json[TableName.trans_pricing_working_id];

  }
}
