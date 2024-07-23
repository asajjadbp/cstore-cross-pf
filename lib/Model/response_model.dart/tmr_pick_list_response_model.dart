import 'dart:math';

class TmrPickListResponseModel {
  bool? status;
  String? msg;
  List<TmrPickList>? data;

  TmrPickListResponseModel({this.status, this.msg, this.data});

  TmrPickListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TmrPickList>[];
      json['data'].forEach((v) {
        data!.add(TmrPickList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TmrPickList {
  int? workingId;
  int? skuId;
  int? actPicklist;
  String? pickerName;
  String? pickListReadyTime;

  TmrPickList({this.workingId, this.skuId, this.actPicklist, this.pickerName});

  TmrPickList.fromJson(Map<String, dynamic> json) {
    workingId = json['working_id'];
    skuId = json['sku_id'];
    actPicklist = json['act_picklist'];
    pickerName = json['picker_name'] ?? "";
    pickListReadyTime = json['picker_ready_time'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['working_id'] = workingId;
    data['sku_id'] = skuId;
    data['act_picklist'] = actPicklist;
    data['picker_name'] = pickerName;
    data['picker_ready_time'] = pickListReadyTime;
    return data;
  }
}