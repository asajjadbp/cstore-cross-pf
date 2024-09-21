import '../../database/table_name.dart';

class SysAppSettingModel {
  late int id;
  late String isBgServices;
  late String isBgMinute;
  late String isPicklistService;
  late String isPicklistTime;
  late String isAutoTimeEnabled;
  late String isLocationEnabled;
  late String isGeoLocationEnabled;
  late String isFakeLocationEnabled;
  late String isVpnEnabled;

  SysAppSettingModel({
    required this.isBgServices,
    required this.isBgMinute,
    required this.isPicklistService,
    required this.isPicklistTime,
    required this.isAutoTimeEnabled,
    required this.isLocationEnabled,
    required this.isGeoLocationEnabled,
    required this.isFakeLocationEnabled,
    required this.isVpnEnabled,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_app_settingBgServices: isBgServices.toString(),
      TableName.sys_app_settingBgServiceMinute: isBgMinute.toString(),
      TableName.sys_app_settingPicklisService: isPicklistService.toString(),
      TableName.sys_app_settingPicklisTime: isPicklistTime.toString(),
      TableName.sys_app_auto_time: isAutoTimeEnabled.toString(),
      TableName.sys_app_location: isLocationEnabled.toString(),
      "is_geo_fence": isGeoLocationEnabled.toString(),
      TableName.sys_app_fake_location_check: isFakeLocationEnabled.toString(),
      TableName.sys_app_vpn_check: isVpnEnabled.toString(),
    };
  }

  SysAppSettingModel.fromJson(Map<String, dynamic> json) {
    isBgServices = json[TableName.sys_app_settingBgServices].toString();
    isBgMinute = json[TableName.sys_app_settingBgServiceMinute].toString();
    isPicklistService = json[TableName.sys_app_settingPicklisService].toString();
    isPicklistTime = json[TableName.sys_app_settingPicklisTime].toString();
    isAutoTimeEnabled = json[TableName.sys_app_auto_time].toString();
    isLocationEnabled = json[TableName.sys_app_location].toString();
    isGeoLocationEnabled = json["is_geo_fence"].toString();
    isFakeLocationEnabled = json[TableName.sys_app_fake_location_check].toString();
    isVpnEnabled = json[TableName.sys_app_vpn_check].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_app_settingBgServices: isBgServices.toString(),
    TableName.sys_app_settingBgServiceMinute: isBgMinute.toString(),
    TableName.sys_app_settingPicklisService: isPicklistService.toString(),
    TableName.sys_app_settingPicklisTime: isPicklistTime.toString(),
    TableName.sys_app_auto_time: isAutoTimeEnabled.toString(),
    TableName.sys_app_location: isLocationEnabled.toString(),
    "is_geo_fence": isGeoLocationEnabled.toString(),
    TableName.sys_app_fake_location_check: isFakeLocationEnabled.toString(),
    TableName.sys_app_vpn_check: isVpnEnabled.toString(),
  };
}
