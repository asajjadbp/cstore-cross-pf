import '../../database/table_name.dart';

class SysProductPlacementModel {
  late int skuId;
  late int storeId;
  late int catId;
  late String pog;
  late String h_facing;
  late String v_facing;
  late String d_facing;
  late String total_facing;
  late String bay_no;
  late String shelf_no;
  late String rank_x;

  SysProductPlacementModel({
    required this.skuId,
    required this.storeId,
    required this.catId,
    required this.pog,
    required this.h_facing,
    required this.v_facing,
    required this.d_facing,
    required this.total_facing,
    required this.bay_no,
    required this.shelf_no,
    required this.rank_x
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_product_placement_id: skuId.toString(),
      TableName.sys_product_placement_storeId: storeId.toString(),
      TableName.sys_product_placement_cat_id: catId.toString(),
      TableName.sys_product_placement_pog: pog.toString(),
      TableName.sys_product_placement_h_facing:h_facing.toString(),
      TableName.sys_product_placement_h_facing:v_facing.toString(),
      TableName.sys_product_placement_h_facing:d_facing.toString(),
      TableName.sys_product_placement_h_facing:total_facing.toString(),
      TableName.sys_product_placement_h_facing:bay_no.toString(),
      TableName.sys_product_placement_h_facing:shelf_no.toString(),
      TableName.sys_product_placement_h_facing:rank_x.toString(),
    };
  }

  SysProductPlacementModel.fromJson(Map<String, dynamic> json) {
    skuId = json[TableName.sys_product_placement_id];
    storeId = json[TableName.sys_product_placement_storeId];
    catId = json[TableName.sys_product_placement_cat_id];
    pog = json[TableName.sys_store_pog].toString();
    h_facing = json[TableName.sys_product_placement_h_facing].toString();
    v_facing = json[TableName.sys_product_placement_v_facing].toString();
    d_facing = json[TableName.sys_product_placement_d_facing].toString();
    total_facing = json[TableName.sys_product_placement_total_facing].toString();
    bay_no = json[TableName.sys_product_placement_bay_no].toString();
    shelf_no = json[TableName.sys_product_placement_shelf_no].toString();
    rank_x = json[TableName.sys_product_placement_rank_x].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_product_placement_id: skuId.toString(),
    TableName.sys_product_placement_storeId: storeId.toString(),
    TableName.sys_product_placement_cat_id: catId.toString(),
    TableName.sys_store_pog: pog.toString(),
    TableName.sys_product_placement_h_facing: h_facing.toString(),
    TableName.sys_product_placement_v_facing: h_facing.toString(),
    TableName.sys_product_placement_d_facing: h_facing.toString(),
    TableName.sys_product_placement_total_facing: h_facing.toString(),
    TableName.sys_product_placement_bay_no: h_facing.toString(),
    TableName.sys_product_placement_shelf_no: h_facing.toString(),
    TableName.sys_product_placement_rank_x: h_facing.toString(),
  };

  @override
  String toString() {
    return 'SysProductPlacementModel{skuId: $skuId, storeId: $storeId, catId: $catId, pog: $pog, h_facing: $h_facing, v_facing: $v_facing, d_facing: $d_facing, total_facing: $total_facing, bay_no: $bay_no, shelf_no: $shelf_no, rank_x: $rank_x}';
  }
}
