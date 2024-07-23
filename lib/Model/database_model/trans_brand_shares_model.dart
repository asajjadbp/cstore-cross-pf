class TransBransShareModel {
  late int id;
  late int cat_id;
  late int brand_id;
  late String cat_en_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String actual_faces;
  late String given_faces;
  late int client_id = -1;
  late int upload_status = 0;
  late int activity_status = 0;

  TransBransShareModel({
    required this.id,
    required this.cat_id,
    required this.brand_id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.actual_faces,
    required this.given_faces,
    required this.client_id,
    required this.upload_status,
    required this.activity_status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'cat_id': this.cat_id,
      'brand_id': this.brand_id,
      'cat_en_name': this.cat_en_name,
      'cat_ar_name': this.cat_ar_name,
      'brand_en_name': this.brand_en_name,
      'brand_ar_name': this.brand_ar_name,
      'actual_faces': this.actual_faces,
      'given_faces': this.given_faces,
      'client_id' : this.client_id,
      'upload_status' : this.upload_status,
      'activity_status' : this.activity_status,
    };
  }

  factory TransBransShareModel.fromMap(Map<String, dynamic> map) {
    return TransBransShareModel(
      id: map['id'] as int,
      cat_id: map['cat_id'] as int,
      brand_id: map['brand_id'] as int,
      cat_en_name: map['cat_en_name'] as String,
      cat_ar_name: map['cat_ar_name'] as String,
      brand_en_name: map['brand_en_name'] as String,
      brand_ar_name: map['brand_ar_name'] as String,
      actual_faces: map['actual_faces'] as String,
      given_faces: map['given_faces'] as String,
      client_id: map['client_id'] as int,
      upload_status: map['upload_status'] as int,
      activity_status: map['activity_status'] as int,
    );
  }
}
