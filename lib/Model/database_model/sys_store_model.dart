import '../../database/table_name.dart';

class SysStoreModel {
  late int id;
  late String en_name;
  late String ar_name;
  late String gcode;
  late int region_id;
  late String region_name;
  late int city_id;
  late String city_name;
  late int chain_id;
  late String chain_name;
  late int channel_id;
  late int channel_id6;
  late int channel_id7;
  late int type_id;

  SysStoreModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId]??0;
    en_name = json[TableName.enName]??"";
    ar_name = json[TableName.arName]??"";
    gcode = json[TableName.sysStoreGcode]??"";
    region_id = json[TableName.sysStoreRegionId]??0;
    region_name = json[TableName.sysStoreRegionName]??"";
    city_id = json[TableName.sysStoreCityId]??0;
    city_name = json[TableName.sysStoreCityName]??"";
    chain_id = json[TableName.chain_id]??0;
    chain_name = json[TableName.sysStoreChainName]??"";
    channel_id = json[TableName.sysStoreChannelId]??0;
    channel_id6 = json[TableName.sysStoreChannelId6]??0;
    channel_id7 = json[TableName.sysStoreChannelId7]??0;
    type_id = json[TableName.type_id]??0;
  }
  Map<String, dynamic> toJson() => {
    TableName.sysId: this.id,
    TableName.enName: this.en_name,
    TableName.arName: this.ar_name,
    TableName.sysStoreGcode: this.gcode,
    TableName.reason_id: this.region_id,
    TableName.sysStoreRegionName: this.region_name,
    TableName.sysStoreCityId: this.city_id,
    TableName.sysStoreCityName: this.city_name,
    TableName.chain_id: this.chain_id,
    TableName.sysStoreChainName: this.chain_name,
    TableName.sysStoreChannelId: this.channel_id,
    TableName.sysStoreChannelId6: this.channel_id6,
    TableName.sysStoreChannelId7: this.channel_id7,
    TableName.type_id: this.type_id,
  };


  SysStoreModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
    required this.gcode,
    required this.region_id,
    required this.region_name,
    required this.city_id,
    required this.city_name,
    required this.chain_id,
    required this.chain_name,
    required this.channel_id,
    required this.channel_id6,
    required this.channel_id7,
    required this.type_id,
  });

  Map<String, dynamic> toMap() {
    return {
      TableName.sysId: this.id,
      TableName.enName: this.en_name,
      TableName.arName: this.ar_name,
      TableName.sysStoreGcode: this.gcode,
      TableName.reason_id: this.region_id,
      TableName.sysStoreRegionName: this.region_name,
      TableName.sysStoreCityId: this.city_id,
      TableName.sysStoreCityName: this.city_name,
      TableName.chain_id: this.chain_id,
      TableName.sysStoreChainName: this.chain_name,
      TableName.sysStoreChannelId: this.channel_id,
      TableName.sysStoreChannelId6: this.channel_id6,
      TableName.sysStoreChannelId7: this.channel_id7,
      TableName.type_id: this.type_id,
    };
  }

}
