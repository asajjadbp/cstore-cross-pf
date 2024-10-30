
import 'dart:convert';

SaveDbFileRequest saveDbFileRequestFromJson(String str) =>
    SaveDbFileRequest.fromJson(json.decode(str));

String saveDbFileRequestToJson(SaveDbFileRequest data) =>
    json.encode(data.toJson());

class SaveDbFileRequest {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final String fileName;

  SaveDbFileRequest({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.fileName,
  });

  factory SaveDbFileRequest.fromJson(Map<String, dynamic> json) =>
      SaveDbFileRequest(
          username: json["username"],
          workingId: json["working_id"],
          storeId: json["store_id"],
          workingDate: json["working_date"],
          fileName: json["file_name"],
      );

  Map<String, dynamic> toJson() => {
    'username': username,
    'working_id': workingId,
    'store_id': storeId,
    'working_date':workingDate,
    'file_name':fileName,
  };
}