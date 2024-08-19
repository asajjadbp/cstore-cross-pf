import 'dart:io';
import '../../database/table_name.dart';

class TransOnePlusOneModel {
  late int id;
  late int pieces;
  late String pro_en_name;
  late String pro_ar_name;
  late String doc_no;
  late String comment;
  late String type;
  late String date_time;
  late String doc_image;
  late String image_name;
  File? imageFile;
  File? imageFileDoc;
  late int working_id;
  late int upload_status;
  late int act_status;
  late int gcs_status;
  TransOnePlusOneModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    pieces = json[TableName.pieces];
    pro_en_name = json[TableName.enName];
    pro_ar_name = json[TableName.arName];
    doc_no = json[TableName.trans_one_plus_one_doc_no];
    comment = json[TableName.trans_one_plus_one_comment];
    type = json[TableName.trans_one_plus_one_type];
    date_time = json[TableName.dateTime];
    doc_image = json[TableName.trans_one_plus_one_doc_image];
    image_name = json[TableName.imageName];
    working_id = json[TableName.workingId];
    upload_status = json[TableName.uploadStatus];
    gcs_status = json[TableName.gcsStatus];
    act_status = json[TableName.activityStatus];
    imageFile=null;
    imageFileDoc=null;

  }

  TransOnePlusOneModel({
    required this.id,
    required this.pieces,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.doc_no,
    required this.comment,
    required this.type,
    required this.date_time,
    required this.doc_image,
    required this.image_name,
    required this.imageFile,
    required this.imageFileDoc,
    required this.working_id,
    required this.upload_status,
    required this.gcs_status,
    required this.act_status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'pieces': this.pieces,
      'pro_en_name': this.pro_en_name,
      'pro_ar_name': this.pro_ar_name,
      'doc_no': this.doc_no,
      'comment': this.comment,
      'type': this.type,
      'date_time': this.date_time,
      'doc_image': this.doc_image,
      'image_name': this.image_name,
      'imageFile': this.imageFile,
      'imageFileDoc': this.imageFileDoc,
      'working_id': this.working_id,
      'upload_status': this.upload_status,
      'gcs_status': this.gcs_status,
      'act_status': this.act_status,
    };
  }
  factory TransOnePlusOneModel.fromMap(Map<String, dynamic> map) {
    return TransOnePlusOneModel(
      id: map['id'] as int,
      pieces: map['pieces'] as int,
      pro_en_name: map['pro_en_name'] as String,
      pro_ar_name: map['pro_ar_name'] as String,
      doc_no: map['doc_no'] as String,
      comment: map['comment'] as String,
      type: map['type'] as String,
      date_time: map['date_time'] as String,
      doc_image: map['doc_image'] as String,
      image_name: map['image_name'] as String,
      imageFile: map['imageFile'] as File,
      imageFileDoc: map['imageFileDoc'] as File,
      working_id: map['working_id'] as int,
      upload_status: map['upload_status'] as int,
      gcs_status: map['gcs_status'] as int,
      act_status: map['act_status'] as int,
    );
  }
}
