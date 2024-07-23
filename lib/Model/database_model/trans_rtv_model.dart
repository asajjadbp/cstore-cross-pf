import 'package:cstore/database/table_name.dart';

class TransRtvModel {
  late int sku_id;
  late int pieces ;
  late int reason ;
  late String expire_date;
  late String image_name ;
  late int act_status = 1;
  late int gcs_status = 0;
  late String date_time;
  late int upload_status;
  late int working_id = 1;
  TransRtvModel({
    required this.sku_id,
    required this.pieces,
    required this.reason,
    required this.expire_date,
    required this.image_name,
    required this.act_status,
    required this.gcs_status,
    required this.date_time,
    required this.upload_status,
    required this.working_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'sku_id': this.sku_id,
      'pieces': this.pieces,
      'reason': this.reason,
      'expire_date': this.expire_date,
      'image_name': this.image_name,
      'act_status': this.act_status,
      'gcs_status': this.gcs_status,
      'date_time': this.date_time,
      'upload_status': this.upload_status,
      'working_id': this.working_id,
    };
  }

  factory TransRtvModel.fromMap(Map<String, dynamic> map) {
    return TransRtvModel(
      sku_id: map['sku_id'] as int,
      pieces: map['pieces'] as int,
      reason: map['reason'] as int,
      expire_date: map['expire_date'] as String,
      image_name: map['image_name'] as String,
      act_status: map['act_status'] as int,
      gcs_status: map['gcs_status'] as int,
      date_time: map['date_time'] as String,
      upload_status: map['upload_status'] as int,
      working_id: map['working_id'] as int,
    );
  }
}
