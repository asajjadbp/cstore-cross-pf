import 'dart:math';

import '../../database/table_name.dart';

class TransOSDCImagesModel {
  late String main_osd_id;
  late String image_name;
  late int working_id;

  TransOSDCImagesModel({
    required this.main_osd_id,
    required this.image_name,
    required this.working_id,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.trans_osdc_main_id: main_osd_id,
      TableName.imageName: image_name,
      TableName.workingId:working_id,
    };
  }

  TransOSDCImagesModel.fromJson(Map<String, dynamic> json) {
    main_osd_id = json[TableName.trans_osdc_main_id];
    image_name = json[TableName.imageName];
    working_id = json[TableName.workingId];
  }
}
