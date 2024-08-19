import '../../database/table_name.dart';

class TransAvlModel {
  late int id;
  late int sku_id;
  late int avl_status;
  late int activity_status;
  late String req_picklist;
  late int actual_picklist;
  late int picklist_reason;
  late int picklist_ready;
  late int working_id;

  TransAvlModel({
    required this.sku_id,
    required this.avl_status,
    required this.activity_status,
    required this.req_picklist,
    required this.actual_picklist,
    required this.picklist_reason,
    required this.picklist_ready,
    required this.working_id,});


  Map<String, dynamic> toMap() => {
    TableName.skuId: sku_id,
    TableName.trans_avl_status: avl_status,
    TableName.activityStatus: activity_status,
    TableName.trans_avl_req_picklist: req_picklist,
    TableName.trans_avl_actual_picklist:actual_picklist,
    TableName.trans_avl_picklist_reason: picklist_reason,
    TableName.trans_avl_picklist_ready: picklist_ready,
    TableName.workingId:working_id,};


  TransAvlModel.fromJson(Map<String, dynamic> json) {
    sku_id = json[TableName.skuId];
    avl_status = json[TableName.trans_avl_status];
    activity_status = json[TableName.brandId];
    req_picklist = json[TableName.trans_avl_req_picklist];
    actual_picklist = json[TableName.trans_avl_actual_picklist];
    picklist_reason = json[TableName.trans_avl_picklist_reason];
    picklist_ready = json[TableName.trans_avl_picklist_ready];
    working_id = json[TableName.workingId];

  }
}
