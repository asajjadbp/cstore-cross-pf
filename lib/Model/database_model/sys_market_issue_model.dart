import '../../database/table_name.dart';

class sysMarketIssueModel {
  late int id;
  late String name;
  late int status;
  late String updated_at;

  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.trans_pos_name: name,
      TableName.status: status,
      TableName.sysIssueUpdateAt: updated_at,
    };
  }

  Map<String, dynamic> toJson() => {
        TableName.sysId: id,
        TableName.trans_pos_name: name,
        TableName.status: status,
        TableName.sysIssueUpdateAt: updated_at,
      };

  sysMarketIssueModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    name = json[TableName.trans_pos_name];
    status = json[TableName.status];
    updated_at = json[TableName.sysIssueUpdateAt];
  }

  sysMarketIssueModel({
    required this.id,
    required this.name,
    required this.status,
    required this.updated_at,
  });
}
