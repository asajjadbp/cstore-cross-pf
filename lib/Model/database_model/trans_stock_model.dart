import '../../database/table_name.dart';

class TransStockModel {
  late int pro_id;
  late int cases;
  late int outer;
  late int pieces;
  late String client_id="";
  late String pro_en_name;
  late String pro_ar_name;
  late String cat_en_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String img_name;
  late String rsp;
  late int upload_status;
  late int act_status;


  Map<String, dynamic> toMap() {
    return {
      'pro_id': this.pro_id,
      'cases': this.cases,
      'outer': this.outer,
      'pieces': this.pieces,
      'client_id': this.client_id,
      'pro_ar_name': this.pro_ar_name,
      'cat_en_name': this.cat_en_name,
      'cat_ar_name': this.cat_ar_name,
      'brand_en_name': this.brand_en_name,
      'brand_ar_name': this.brand_ar_name,
      'img_name': this.img_name,
      'rsp': this.rsp,
      'upload_status': this.upload_status,
      'act_status': this.act_status,
    };
  }

  factory TransStockModel.fromMap(Map<String, dynamic> map) {
    return TransStockModel(
      pro_id: map['pro_id']??0,
      cases: map['cases']??0,
      outer: map['outer']??0,
      pieces: map['pieces']??0,
      client_id: map['client_id'] ??"",
      pro_en_name: map['pro_en_name'] ??"",
      pro_ar_name: map['pro_ar_name'] ??"",
      cat_en_name: map['cat_en_name'] ??"",
      cat_ar_name: map['cat_ar_name'] ??"",
      brand_en_name: map['brand_en_name'] ??"",
      brand_ar_name: map['brand_ar_name'] ??"",
      img_name: map['img_name'] ??"",
      rsp: map['rsp'] ??"",
      upload_status: map['upload_status']??0,
      act_status: map['act_status']??0,
    );
  }

  TransStockModel({
    required this.pro_id,
    required this.cases,
    required this.outer,
    required this.pieces,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.img_name,
    required this.rsp,
    required this.upload_status,
    required this.act_status,
    required client_id,
  });
}


class TotalStockCountData{

  late int total_stock_taken;
  late int total_not_upload;
  late int total_uploaded;
  late int total_cases;
  late int total_outers;
  late int total_pieces;

  TotalStockCountData({
    required this.total_stock_taken,
    required this.total_not_upload,
    required this.total_uploaded,
    required this.total_cases,
    required this.total_outers,
    required this.total_pieces,
  });

  Map<String, dynamic> toMap() {
    return {
      'total_stock_taken': this.total_stock_taken,
      'total_not_upload': this.total_not_upload,
      'total_uploaded': this.total_uploaded,
      'total_cases': this.total_cases,
      'total_outer': this.total_outers,
      'total_pieces': this.total_pieces,
    };
  }

  factory TotalStockCountData.fromMap(Map<String, dynamic> map) {
    return TotalStockCountData(
      total_stock_taken: map['total_stock_taken'] as int,
      total_not_upload: map['total_not_upload'] as int,
      total_uploaded: map['total_uploaded'] as int,
      total_cases: map['total_cases'] as int,
      total_outers: map['total_outer'] as int,
      total_pieces: map['total_pieces'] as int,
    );
  }
}
