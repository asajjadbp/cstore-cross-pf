import '../../database/table_name.dart';

class SysAppSettingModel {
  late int id;
  late String isBgServices;
  late String isBgMinute;
  late String isPicklistService;
  late String isPicklistTime;

  SysAppSettingModel({
    required this.isBgServices,
    required this.isBgMinute,
    required this.isPicklistService,
    required this.isPicklistTime,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_app_settingBgServices: isBgServices.toString(),
      TableName.sys_app_settingBgServiceMinute: isBgMinute.toString(),
      TableName.sys_app_settingPicklisService: isPicklistService.toString(),
      TableName.sys_app_settingPicklisTime: isPicklistTime.toString(),
    };
  }

  SysAppSettingModel.fromJson(Map<String, dynamic> json) {
    isBgServices = json[TableName.sys_app_settingBgServices].toString();
    isBgMinute = json[TableName.sys_app_settingBgServiceMinute].toString();
    isPicklistService = json[TableName.sys_app_settingPicklisService].toString();
    isPicklistTime = json[TableName.sys_app_settingPicklisTime].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_app_settingBgServices: isBgServices.toString(),
    TableName.sys_app_settingBgServiceMinute: isBgMinute.toString(),
    TableName.sys_app_settingPicklisService: isPicklistService.toString(),
    TableName.sys_app_settingPicklisTime: isPicklistTime.toString(),
  };
}
