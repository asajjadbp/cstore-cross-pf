import 'dart:math';

import '../../database/table_name.dart';

class TransOSDCImagesModel {
  late int id;
  late int main_osd_id;
  late int image_name;

  TransOSDCImagesModel({
    required this.main_osd_id,
    required this.image_name,});

  Map<String, Object?> toMap() {
    return {
      TableName.trans_osdc_brand_id: main_osd_id,
      TableName.trans_osdc_type_id: image_name,
    };
  }

  TransOSDCImagesModel.fromJson(Map<String, dynamic> json) {
    main_osd_id = json[TableName.trans_osdc_brand_id];
    image_name = json[TableName.trans_osdc_type_id];

  }
}
