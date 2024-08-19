import '../../database/table_name.dart';

class TransMarketIssueModel {
  late int issue_id;
  late String client_id;
  late String comment;
  late int gcs_status;
  late int upload_status;
  late String date_time;
  late String imageName;
  late int working_id;

  Map<String, Object?> toMap() {
    return {
      TableName.sys_issue_id: issue_id,
      TableName.client_id: client_id,
      TableName.trans_one_plus_one_comment: comment,
      TableName.gcs_status: gcs_status,
      TableName.upload_status: upload_status,
      TableName.trans_date_time: date_time,
      TableName.working_id:working_id,
      TableName.image_name:imageName,
    };
  }

  TransMarketIssueModel.fromJson(Map<String, dynamic> json) {
    issue_id = json[TableName.sys_issue_id];
    client_id = json[TableName.client_id];
    comment = json[TableName.trans_one_plus_one_comment];
    gcs_status = json[TableName.gcs_status];
    upload_status = json[TableName.upload_status];
    date_time = json[TableName.trans_date_time];
    working_id = json[TableName.working_id];
    imageName = json[TableName.image_name];

  }

  TransMarketIssueModel({
    required this.issue_id,
    required this.client_id,
    required this.comment,
    required this.gcs_status,
    required this.upload_status,
    required this.date_time,
    required this.working_id,
    required this.imageName,
  });
}
