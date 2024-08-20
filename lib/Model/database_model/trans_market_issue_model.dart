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
      TableName.clientIds: client_id,
      TableName.trans_one_plus_one_comment: comment,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.dateTime: date_time,
      TableName.workingId:working_id,
      TableName.imageName:imageName,
    };
  }

  TransMarketIssueModel.fromJson(Map<String, dynamic> json) {
    issue_id = json[TableName.sys_issue_id];
    client_id = json[TableName.clientIds];
    comment = json[TableName.trans_one_plus_one_comment];
    gcs_status = json[TableName.gcsStatus];
    upload_status = json[TableName.uploadStatus];
    date_time = json[TableName.dateTime];
    working_id = json[TableName.workingId];
    imageName = json[TableName.imageName];

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
