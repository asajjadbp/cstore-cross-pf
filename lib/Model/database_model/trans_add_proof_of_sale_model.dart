import '../../database/table_name.dart';

class TransAddProfOfSale {
  late int id;
  late String name;
  late String email;
  late String phone;
  late int client_id;
  late int category_id;
  late int qty;
  late int sku_id;
  late String Amount;
  late String image_name;
  late int upload_status;
  late int gcs_status;
  late String date_time;
  late int working_id;
  TransAddProfOfSale.fromJson(Map<String, dynamic> json) {
    name = json[TableName.trans_pos_name];
    email = json[TableName.trans_pos_email];
    phone = json[TableName.trans_pos_phone];
    client_id = json[TableName.clientIds];
    category_id = json[TableName.sysCategoryId];
    qty = json[TableName.col_quantity];
    sku_id = json[TableName.skuId];
    Amount = json[TableName.trans_pos_amount];
    upload_status = json[TableName.uploadStatus];
    gcs_status = json[TableName.gcsStatus];
    working_id = json[TableName.workingId];
    image_name = json[TableName.imageName];
    date_time = json[TableName.dateTime];

  }

  TransAddProfOfSale({
    required this.name,
    required this.email,
    required this.phone,
    required this.client_id,
    required this.category_id,
    required this.qty,
    required this.sku_id,
    required this.Amount,
    required this.image_name,
    required this.upload_status,
    required this.gcs_status,
    required this.date_time,
    required this.working_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'client_id': this.client_id,
      'category_id': this.category_id,
      'qty': this.qty,
      'sku_id': this.sku_id,
      'Amount': this.Amount,
      'image_name': this.image_name,
      'upload_status': this.upload_status,
      'gcs_status': this.gcs_status,
      'date_time': this.date_time,
      'working_id': this.working_id,
    };
  }

  factory TransAddProfOfSale.fromMap(Map<String, dynamic> map) {
    return TransAddProfOfSale(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      client_id: map['client_id'] as int,
      category_id: map['category_id'] as int,
      qty: map['qty'] as int,
      sku_id: map['sku_id'] as int,
      Amount: map['Amount'] as String,
      image_name: map['image_name'] as String,
      upload_status: map['upload_status'] as int,
      gcs_status: map['gcs_status'] as int,
      date_time: map['date_time'] as String,
      working_id: map['working_id'] as int,
    );
  }
}
