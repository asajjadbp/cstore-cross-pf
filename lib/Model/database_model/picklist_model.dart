import 'dart:io';

import '../../database/table_name.dart';

class PickListModel {
  late String picklist_id;
  late String store_id;
  late String category_id;
  late String tmr_id;
  late String tmr_name;
  late String stocker_id;
  late String stocker_name;
  late String shift_time;
  late String en_cat_name;
  late String ar_cat_name;
  late String sku_picture;
  late String en_sku_name;
  late String ar_sku_name;
  late String req_pickList;
  late String act_pickList;
  late String pickList_ready;
  late int upload_status;
  late String pick_list_send_time;
  late String pick_list_receive_time;
  late String pick_list_reason;
  bool? isReasonShow;
  List<String>? reasonValue;

  PickListModel.fromJson(Map<String, dynamic> json) {
    picklist_id = json[TableName.picklist_id].toString();
    store_id = json[TableName.storeId].toString();
    category_id = json[TableName.sysCategoryId].toString();
    tmr_id = json[TableName.picklist_tmr_id].toString();
    tmr_name = json[TableName.picklist_tmr_name].toString();
    stocker_id = json[TableName.picklist_stocker_id].toString();
    stocker_name = json[TableName.picklist_stocker_name].toString();
    shift_time = json[TableName.picklist_shift_time].toString();
    en_cat_name = json[TableName.enName].toString();
    ar_cat_name = json[TableName.arName].toString();
    sku_picture = json[TableName.picklist_sku_picture].toString();
    en_sku_name = json[TableName.picklist_en_sku_name].toString();
    ar_sku_name = json[TableName.picklist_ar_sku_name].toString();
    req_pickList = json[TableName.picklist_req_picklist].toString();
    act_pickList = json[TableName.picklist_act_picklist].toString();
    pickList_ready = json[TableName.picklist_picklist_ready].toString();
    upload_status = json[TableName.uploadStatus];
    pick_list_send_time = json[TableName.trans_avl_receive_time] ?? "";
    pick_list_receive_time = json['tmr_send_time'] ?? "";
    pick_list_reason = json['picklist_reason'] ?? "";
  }
  Map<String, dynamic> toJson() => {
    'picklist_id': this.picklist_id,
    'store_id': this.store_id,
    'category_id': this.category_id,
    'tmr_id': this.tmr_id,
    'tmr_name': this.tmr_name,
    'stocker_id': this.stocker_id,
    'stocker_name': this.stocker_name,
    'shift_time': this.shift_time,
    'en_cat_name': this.en_cat_name,
    'ar_cat_name': this.ar_cat_name,
    'sku_picture': this.sku_picture,
    'en_sku_name': this.en_sku_name,
    'ar_sku_name': this.ar_sku_name,
    'req_picklist': this.req_pickList,
    'act_picklist': this.act_pickList,
    'picklist_ready': this.pickList_ready,
    'upload_status': this.upload_status,
    'pick_list_receive_time' : this.pick_list_send_time,
    'tmr_send_time' : this.pick_list_receive_time,
    'picklist_reason' : this.pick_list_reason,
  };

  PickListModel({
    required this.picklist_id,
    required this.store_id,
    required this.category_id,
    required this.tmr_id,
    required this.tmr_name,
    required this.stocker_id,
    required this.stocker_name,
    required this.shift_time,
    required this.en_cat_name,
    required this.ar_cat_name,
    required this.sku_picture,
    required this.en_sku_name,
    required this.ar_sku_name,
    required this.req_pickList,
    required this.act_pickList,
    required this.pickList_ready,
    required this.upload_status,
    required this.pick_list_send_time,
    required this.pick_list_receive_time,
    required this.isReasonShow,
    required this.reasonValue,
    required this.pick_list_reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'picklist_id': this.picklist_id,
      'store_id': this.store_id,
      'category_id': this.category_id,
      'tmr_id': this.tmr_id,
      'tmr_name': this.tmr_name,
      'stocker_id': this.stocker_id,
      'stocker_name': this.stocker_name,
      'shift_time': this.shift_time,
      'en_cat_name': this.en_cat_name,
      'ar_cat_name': this.ar_cat_name,
      'sku_picture': this.sku_picture,
      'en_sku_name': this.en_sku_name,
      'ar_sku_name': this.ar_sku_name,
      'req_pickList': this.req_pickList,
      'act_pickList': this.act_pickList,
      'pickList_ready': this.pickList_ready,
      'upload_status': this.upload_status,
      'pick_list_receive_time': this.pick_list_send_time,
      'tmr_send_time' : this.pick_list_receive_time,
      'picklist_reason' : this.pick_list_reason,
    };
  }

  factory PickListModel.fromMap(Map<String, dynamic> map) {
    return PickListModel(
      picklist_id: map['picklist_id'].toString(),
      store_id: map['store_id'].toString(),
      category_id: map['category_id'].toString(),
      tmr_id: map['tmr_id'].toString(),
      tmr_name: map['tmr_name'].toString(),
      stocker_id: map['stocker_id'].toString(),
      stocker_name: map['stocker_name'].toString(),
      shift_time: map['shift_time'].toString(),
      en_cat_name: map['en_cat_name'].toString(),
      ar_cat_name: map['ar_cat_name'].toString(),
      sku_picture: map['sku_picture'].toString(),
      en_sku_name: map['en_sku_name'].toString(),
      ar_sku_name: map['ar_sku_name'].toString(),
      req_pickList: map['req_pickList'].toString(),
      act_pickList: map['act_pickList'].toString(),
      pickList_ready: map['pickList_ready'].toString(),
      upload_status:map['upload_status'],
      pick_list_send_time: map['pick_list_send_time'] ?? "",
      pick_list_receive_time: map['tmr_send_time']  ?? "",
      isReasonShow: true,
      reasonValue:[],
      pick_list_reason: map['picklist_reason'] ?? "",
    );
  }
}
