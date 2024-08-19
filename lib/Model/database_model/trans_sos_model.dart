import '../../database/table_name.dart';

class TransSOSModel {
  late int id;
  late int client_id;
  late int cat_id;
  late int brand_id;
  late String category_space;
  late String actual_space;
  late String unit;
  late String date_time = "";
  late int working_id;
  late int uploadStatus;

  TransSOSModel({
    required this.client_id,
    required this.cat_id,
    required this.brand_id,
    required this.category_space,
    required this.actual_space,
    required this.unit,
    required this.date_time,
    required this.uploadStatus,
    required this.working_id,});

  Map<String, Object?> toMap() {
    return {
      TableName.clientIds: client_id,
      TableName.sysCategoryId: cat_id,
      TableName.brandId: brand_id,
      TableName.trans_sos_cat_space: category_space,
      TableName.trans_sos_actual_space: actual_space,
      TableName.trans_sos_unit: unit,
      TableName.dateTime: date_time,
      TableName.workingId:working_id,
      TableName.uploadStatus:uploadStatus,
    };
  }

  TransSOSModel.fromJson(Map<String, dynamic> json) {
    client_id = json[TableName.clientIds];
    cat_id = json[TableName.sysCategoryId];
    brand_id = json[TableName.brandId];
    category_space = json[TableName.trans_sos_cat_space];
    actual_space = json[TableName.trans_sos_actual_space];
    unit = json[TableName.trans_sos_unit];
    date_time = json[TableName.dateTime];
    working_id = json[TableName.workingId];
    uploadStatus = json[TableName.uploadStatus];

  }
}
