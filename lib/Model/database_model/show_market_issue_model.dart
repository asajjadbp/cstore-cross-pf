import 'dart:io';
class ShowMarketIssueModel {
  late int id;
  late String image;
  late String Issuetype;
  late int gcs_status;
  late int upload_status;
  late String comment;
  late String update_at;
  File? imageFile;
  ShowMarketIssueModel({
    required this.id,
    required this.image,
    required this.Issuetype,
    required this.gcs_status,
    required this.upload_status,
    required this.comment,
    required this.update_at,
    this.imageFile,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'image': this.image,
      'Issuetype': this.Issuetype,
      'gcs_status': this.gcs_status,
      'upload_status': this.upload_status,
      'comment': this.comment,
      'update_at': this.update_at,
      'imageFile': this.imageFile,
    };
  }
  factory ShowMarketIssueModel.fromMap(Map<String, dynamic> map) {
    return ShowMarketIssueModel(
      id: map['id'] as int,
      image: map['image'] as String,
      Issuetype: map['Issuetype'] as String,
      gcs_status: map['gcs_status'] as int,
      upload_status: map['upload_status'] as int,
      comment: map['comment'] as String,
      update_at: map['update_at'] as String,
      imageFile: map['imageFile'] as File,
    );
  }
  @override
  String toString() {
    return 'ShowMarketIssueModel{id: $id, image: $image, Issuetype: $Issuetype, gcs_status: $gcs_status, upload_status: $upload_status, comment: $comment, update_at: $update_at, imageFile: $imageFile}';
  }
}
