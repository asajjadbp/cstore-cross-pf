
import 'dart:io';

import '../../Database/table_name.dart';

class TransPlanoGuideModel {
  late int id;
  late int cat_id;
  late String cat_en_name;
  late String cat_ar_name;
  late String pog;
  late String imageName;
  File? imageFile;
  late String isAdherence;
  late String skuImageName;
  late int gcs_status = 0;
  late int client_id = -1;
  late int upload_status = 0;
  late int activity_status = 0;

  TransPlanoGuideModel({
    required this.id,
    required this.cat_id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.pog,
    required this.imageFile,
    required this.imageName,
    required this.isAdherence,
    required this.skuImageName,
    required this.gcs_status,
    required this.client_id,
    required this.upload_status,
    required this.activity_status,
  });
  Map<String, Object?> toMap() {
    return {
      TableName.cat_en_name: cat_en_name.toString(),
      "cat_id": cat_id,
      TableName.cat_ar_name: cat_ar_name.toString(),
      TableName.trans_planoguide_pog: pog.toString(),
      TableName.trans_planoguide_imageName:imageName.toString(),
      TableName.trans_planoguide_isAdherence: isAdherence.toString(),
      "client_id": client_id,
      TableName.trans_planoguide_skuImageName: skuImageName,
      TableName.trans_planoguide_gcs_status: gcs_status,
      TableName.trans_planoguide_upload_status: upload_status,
      "activity_status": activity_status,
    };
  }


}
