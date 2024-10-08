import 'dart:math';

import '../../database/table_name.dart';

class TransPromoPlanModel {
  late int id;
  late int db_id;
  late int promo_plane_id;
  late int status;
  late String reason;
  late String image_name;
  late int working_id;

  TransPromoPlanModel({
    required this.db_id,
    required this.promo_plane_id,
    required this.status,
    required this.reason,
    required this.image_name,
    required this.working_id,});

  Map<String, Object?> toMap() {
    return {
      TableName.trans_promo_db_id: db_id,
      TableName.trans_promo_plan_id: promo_plane_id,
      TableName.status: status,
      TableName.trans_promo_reason: reason,
      TableName.imageName: image_name,
      TableName.workingId:working_id,
    };
  }

  TransPromoPlanModel.fromJson(Map<String, dynamic> json) {
    db_id = json[TableName.trans_promo_db_id];
    promo_plane_id = json[TableName.trans_promo_plan_id];
    status = json[TableName.status];
    reason = json[TableName.trans_promo_reason];
    image_name = json[TableName.imageName];
    working_id = json[TableName.workingId];

  }
}
