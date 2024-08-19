import 'dart:convert';

import '../../database/table_name.dart';

class AgencyDashboardModel {
  late int id;
  late String en_name;
  late String ar_name;
  late String icon;
  late String start_date;
  late String end_date;
  late int status;
  late String accessTo;

  AgencyDashboardModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
    required this.icon,
    required this.start_date,
    required this.end_date,
    required this.status,
    required this.accessTo,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.enName: en_name,
      TableName.arName: ar_name,
      TableName.agency_dash_icon: icon,
      TableName.agency_dash_start_date: start_date,
      TableName.agency_dash_end_date: end_date,
      TableName.status: status,
      TableName.agency_dash_accessTo: accessTo,
    };
  }

  factory AgencyDashboardModel.fromJson(Map<String, dynamic> json) =>
      AgencyDashboardModel(
          id: json[TableName.sysId],
          en_name: json[TableName.enName],
          ar_name: json[TableName.arName],
          icon: json[TableName.agency_dash_icon],
          start_date: json[TableName.agency_dash_start_date],
          end_date: json[TableName.agency_dash_end_date],
          status: json[TableName.status],
          accessTo: json[TableName.agency_dash_accessTo],
      );
}
