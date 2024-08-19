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
      TableName.sysId: id,
      TableName.enName: en_name,
      TableName.arName: ar_name,
      TableName.sys_rtv_reason_calendar: calendar,
      TableName.status: status,
    };
  }

  Sys_RTVReasonModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    en_name = json[TableName.enName].toString();
    ar_name = json[TableName.arName].toString();
    calendar = json[TableName.sys_rtv_reason_calendar].toString();
    status = json[TableName.status];
  }
  Map<String, dynamic> toJson() => {
    TableName.sysId: id,
    TableName.enName: en_name,
    TableName.arName: ar_name,
    TableName.sys_rtv_reason_calendar: calendar,
    TableName.status: status,
  };
}
