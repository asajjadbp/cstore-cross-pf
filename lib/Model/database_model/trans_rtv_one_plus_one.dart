import 'package:cstore/database/table_name.dart';

class TransRtvOnePlusOneModel {
  late int sku_id;
  late int pieces ;
  late int act_status = 1;
  late int gcs_status = 0;
  late String date_time;
  late int upload_status;
  late int working_id = 1;
  late String image_name ;
  late String comment ;
  late String type ;
  late String doc_no ;

  TransRtvOnePlusOneModel({
    required this.sku_id,
    required this.pieces,
    required this.act_status,
    required this.gcs_status,
    required this.date_time,
    required this.upload_status,
    required this.working_id,
    required this.image_name,
    required this.comment,
    required this.type,
    required this.doc_no,
  });

  Map<String, dynamic> toMap() {
    return {
      'sku_id': this.sku_id,
      'pieces': this.pieces,
      'act_status': this.act_status,
      'gcs_status': this.gcs_status,
      'date_time': this.date_time,
      'upload_status': this.upload_status,
      'working_id': this.working_id,
      'image_name': this.image_name,
      'comment': this.comment,
      'type': this.type,
      'doc_no': this.doc_no,
    };
  }
  factory TransRtvOnePlusOneModel.fromMap(Map<String, dynamic> map) {
    return TransRtvOnePlusOneModel(
      sku_id: map['sku_id'] as int,
      pieces: map['pieces'] as int,
      act_status: map['act_status'] as int,
      gcs_status: map['gcs_status'] as int,
      date_time: map['date_time'] as String,
      upload_status: map['upload_status'] as int,
      working_id: map['working_id'] as int,
      image_name: map['image_name'] as String,
      comment: map['comment'] as String,
      type: map['type'] as String,
      doc_no: map['doc_no'] as String,
    );
  }
}
