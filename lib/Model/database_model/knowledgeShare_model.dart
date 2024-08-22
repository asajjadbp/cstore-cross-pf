import 'package:cstore/database/table_name.dart';

class KnowledgeShareModel {
  late int id;
  late int client_id;
  late int chain_id;
  late String title;
  late String description;
  late String added_by;
  late String file_name;
  late String type;
  late String active;
  late String updated_at;
  KnowledgeShareModel({
    required this.id,
    required this.client_id,
    required this.chain_id,
    required this.title,
    required this.description,
    required this.added_by,
    required this.file_name,
    required this.type,
    required this.active,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      TableName.sysId: this.id,
      TableName.clientIds: this.client_id,
      TableName.chain_id: this.chain_id,
      TableName.sys_knowledge_title: this.title,
      TableName.sys_knowledge_des: this.description,
      TableName.sysKnowledgeAddedBy: this.added_by,
      TableName.sysKnowledgeFileName: this.file_name,
      TableName.sysKnowledgeType: this.type,
      TableName.sysKnowledgeActive: this.active,
      TableName.sysIssueUpdateAt: this.updated_at,
    };
  }
  KnowledgeShareModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId] ?? 0;
    client_id = json[TableName.clientIds] ?? 0;
    chain_id = json[TableName.chain_id] ?? 0;
    title = json[TableName.sys_knowledge_title] ?? "";
    description = json[TableName.sys_knowledge_des] ?? "";
    added_by = json[TableName.sysKnowledgeAddedBy].toString() == "null" ? "" : json[TableName.sysKnowledgeAddedBy].toString();
    file_name = json[TableName.sysKnowledgeFileName] ?? 0;
    type = json[TableName.sysKnowledgeType] ?? "";
    active = json[TableName.sysKnowledgeType] ?? 0;
    updated_at = json[TableName.sysIssueUpdateAt] ?? "";
  }

  Map<String, dynamic> toJson() => {
    TableName.sysId: this.id,
    TableName.clientIds: this.client_id,
    TableName.chain_id: this.chain_id,
    TableName.sys_knowledge_title: this.title,
    TableName.sys_knowledge_des: this.description,
    TableName.sysKnowledgeAddedBy: this.added_by,
    TableName.sysKnowledgeFileName: this.file_name,
    TableName.sysKnowledgeType: this.type,
    TableName.sysKnowledgeActive: this.active,
    TableName.sysIssueUpdateAt: this.updated_at,
  };
}
