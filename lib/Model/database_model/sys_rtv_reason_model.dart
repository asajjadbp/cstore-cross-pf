import '../../database/table_name.dart';

class Sys_RTVReasonModel {
  late int id;
  late String en_name;
  late String ar_name;
  late String calendar;
  late int status;

  Sys_RTVReasonModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
    required this.calendar,
    required this.status,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_rtv_reason_id: id,
      TableName.sys_rtv_reason_en_name: en_name,
      TableName.sys_rtv_reason_ar_name: ar_name,
      TableName.sys_rtv_reason_calendar: calendar,
      TableName.sys_rtv_reason_status: status,
    };
  }

  Sys_RTVReasonModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sys_rtv_reason_id];
    en_name = json[TableName.sys_rtv_reason_en_name].toString();
    ar_name = json[TableName.sys_rtv_reason_ar_name].toString();
    calendar = json[TableName.sys_rtv_reason_calendar].toString();
    status = json[TableName.sys_rtv_reason_status];
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_rtv_reason_id: id,
    TableName.sys_rtv_reason_en_name: en_name,
    TableName.sys_rtv_reason_ar_name: ar_name,
    TableName.sys_rtv_reason_calendar: calendar,
    TableName.sys_rtv_reason_status: status,
  };
}
