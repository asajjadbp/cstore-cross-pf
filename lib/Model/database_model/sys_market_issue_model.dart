import '../../database/table_name.dart';

class sysMarketIssueModel {
  late int id;
  late String name;
  late int status;
  late String updated_at;

  Map<String, Object?> toMap() {
    return {
      TableName.col_id: id,
      TableName.sys_issue_name: name,
      TableName.drop_status: status,
      TableName.sys_issue_update_at: updated_at,
    };
  }

  Map<String, dynamic> toJson() => {
        TableName.col_id: id,
        TableName.sys_issue_name: name,
        TableName.drop_status: status,
        TableName.sys_issue_update_at: updated_at,
      };

  sysMarketIssueModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.col_id];
    name = json[TableName.sys_issue_name];
    status = json[TableName.drop_status];
    updated_at = json[TableName.sys_issue_update_at];
  }

  sysMarketIssueModel({
    required this.id,
    required this.name,
    required this.status,
    required this.updated_at,
  });
}
