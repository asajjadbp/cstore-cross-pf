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

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'file_name':fileName,
    };
  }
}