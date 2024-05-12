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
  AgencyDashboardModel({
    required this.en_name,
    required this.ar_name,
    required this.icon,
    required this.start_date,
    required this.end_date,
    required this.status,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.agency_dash_en_name: en_name,
      TableName.agency_dash_ar_name: ar_name,
      TableName.agency_dash_icon: icon,
      TableName.agency_dash_start_date: start_date,
      TableName.agency_dash_end_date: end_date,
      TableName.agency_dash_status: status,
    };
  }

  factory AgencyDashboardModel.fromJson(Map<String, dynamic> json) =>
      AgencyDashboardModel(
          en_name: json[TableName.agency_dash_en_name],
          ar_name: json[TableName.agency_dash_ar_name],
          icon: json[TableName.agency_dash_icon],
          start_date: json[TableName.agency_dash_start_date],
          end_date: json[TableName.agency_dash_end_date],
          status: json[TableName.agency_dash_status]);
}
