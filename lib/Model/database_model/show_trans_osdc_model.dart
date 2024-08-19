import 'dart:io';

import 'package:cstore/database/table_name.dart';

class GetTransOSDCModel {
  late int id=1;
  late int quantity=1;
  late String img_name = "";
  late int gcs_status = 1;
  late int upload_status = 0;
  File? imageFile;
  late String brand_en_name = "";
  late String brand_ar_name = "";
  late String type_en_name = "";
  late String type_ar_name = "";
  late String reason_en_name = "";
  late String reason_ar_name = "";


  GetTransOSDCModel(
      {required this.id,
        required this.quantity,
        required this.img_name,
        required this.imageFile,
        required this.gcs_status,
        required this.upload_status,
        required this.brand_en_name,
        required this.brand_ar_name,
        required this.type_en_name,
        required this.type_ar_name,
        required this.reason_en_name,
        required this.reason_ar_name,
      });

  Map<String, Object?> toMap() {
    return {
      "osdc_id": id.toString(),
      "quantity": quantity.toString(),
      "image_name": img_name.toString(),
      "brand_en_name": brand_en_name.toString(),
      "brand_ar_name": brand_ar_name.toString(),
      "gcs_status": gcs_status,
      "imageFile":imageFile,
      "upload_status": upload_status,
      "type_en_name": type_en_name.toString(),
      "typ_ar_name": type_ar_name.toString(),
      "reason_en_name": reason_en_name.toString(),
      "reason_ar_name": reason_ar_name.toString(),
    };
  }

}

class GetTransImagesOSDCModel {
  late int id;
  late String imgName;


  GetTransImagesOSDCModel(
      {required this.id,
        required this.imgName,
      });

  Map<String, Object?> toMap() {
    return {
      TableName.trans_osdc_main_id: id.toString(),
      TableName.imageName: imgName.toString(),

    };
  }

}
