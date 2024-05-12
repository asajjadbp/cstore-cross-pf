import 'package:cstore/database/table_name.dart';

class DropReasonModel {
  late int id = 1;
  late String en_name = "";
  late String ar_name = "";
  late int status = 1;

  DropReasonModel({
    required this.en_name,
    required this.ar_name,
    required this.status,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      TableName.drop_en_name: en_name,
      TableName.drop_ar_name: ar_name,
      TableName.drop_status: status,
    };
  }
}
