import '../../database/table_name.dart';

class ClientModel {
  late int client_id;
  late String client_name;
  // late final String logo;
  // late final int classification;
  // late final int chain_sku_code;
  // late final int day_freshness;
  // late final String is_geo_requried;
  // late final int order_avl;
  // late final int is_survey;


  ClientModel({
    required this.client_id,
    required this.client_name,
    // required this.logo,
    // required this.classification,
    // required this.chain_sku_code,
    // required this.day_freshness,
    // required this.is_geo_requried,
    // required this.order_avl,
    // required this.is_survey,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_client_id: client_id,
      TableName.sys_client_name: client_name ?? "",
      // TableName.sys_client_logo: logo ?? "",
      // TableName.sys_client_classification: classification,
      // TableName.sys_client_chainSku_code: chain_sku_code,
      // TableName.sys_client_is_dayFreshness: day_freshness,
      // TableName.sys_client_geo_requried: is_geo_requried ?? "",
      // TableName.sys_client_order_avl: order_avl,
      // TableName.sys_client_is_survey:is_survey,
    };
  }
}
