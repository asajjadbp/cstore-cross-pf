class AvailabilityShowModel {
  late int pro_id;
  late int client_id;
  late String cat_en_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String pro_en_name;
  late String pro_ar_name;
  late String picker_name;
  late String image;
  late int actual_picklist;
  late int avl_status;
  late int upload_status;
  late int activity_status;
  late int requried_picklist;
  late int picklist_reason;
  late int picklist_ready;
  late int pick_upload_status;
  late String pick_list_send_time;
  late String pick_list_receive_time;

  AvailabilityShowModel({
    required this.pro_id,
    required this.client_id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.image,
    required this.actual_picklist,
    required this.avl_status,
    required this.upload_status,
    required this.activity_status,
    required this.requried_picklist,
    required this.picklist_reason,
    required this.picklist_ready,
    required this.picker_name,
    required this.pick_upload_status,
    required this.pick_list_send_time,
    required this.pick_list_receive_time,
  });

  Map<String, Object?> toMap() {
    return {
      'sku_id': pro_id,
      'client_id' : client_id,
      'cat_en_name': cat_en_name,
      'cat_ar_name': cat_ar_name,
      'brand_en_name': brand_en_name,
      'brand_ar_name': brand_ar_name,
      'pro_en_name': pro_en_name,
      'pro_ar_name': pro_ar_name,
      'image': image,
      'avl_status': avl_status,
      'upload_status':upload_status,
      'activity_status': activity_status,
      'actual_picklist': actual_picklist,
      'req_picklist': requried_picklist,
      'picklist_reason': picklist_reason,
      'picklist_ready' : picklist_ready,
      'picker_name':picker_name,
      'pick_upload_status':pick_upload_status,
      'pick_list_send_time': pick_list_send_time,
      'pick_list_receive_time': pick_list_receive_time
    };
  }

  AvailabilityShowModel.fromJson(Map<String, dynamic> json) {
    pro_id = json['sku_id'];
    client_id = json['client_id'];
    cat_en_name = json['cat_en_name'] ?? "";
    cat_ar_name = json['cat_ar_name'] ?? "";
    brand_en_name = json['brand_en_name'] ?? "";
    brand_ar_name = json['brand_ar_name'] ?? "";
    pro_en_name = json['pro_en_name'] ?? "";
    pro_ar_name = json['pro_ar_name'] ?? "";
    image = json['image'] ?? "";
    avl_status = json['avl_status'] ?? -1;
    activity_status = json['activity_status'] ?? 0;
    upload_status = json['upload_status'] ?? 0;
    actual_picklist = json['actual_picklist'] ?? -1;
    requried_picklist = json['req_picklist'] ?? -1;
    picklist_reason = json['picklist_reason'] ?? -1;
    picklist_ready= json['picklist_ready'] ?? 0;
    picker_name=json['picker_name'] ?? "";
    pick_upload_status= json['pick_upload_status'] ?? 0;
    pick_list_send_time = json['pick_list_send_time'] ?? "";
    pick_list_receive_time = json['pick_list_receive_time'] ?? "";

  }

  Map<String, dynamic> toJson() => {
    'sku_id': pro_id,
    'client_id' : client_id,
    'cat_en_name': cat_en_name,
    'cat_ar_name': cat_ar_name,
    'brand_ar_name': brand_ar_name,
    'brand_en_name': brand_en_name,
    'pro_en_name': pro_ar_name,
    'pro_ar_name': pro_ar_name,
    'image': image,
    'avl_status': avl_status,
    'upload_status' : upload_status,
    'activity_status' : activity_status,
    'actual_picklist' : actual_picklist,
    'req_picklist' : requried_picklist,
    'picklist_reason' : picklist_reason,
    'picklist_ready' : picklist_ready,
    'picker_name' : picker_name,
    'pick_upload_status': pick_upload_status,
    'pick_list_send_time' : pick_list_send_time,
    'pick_list_receive_time' : pick_list_receive_time,
  };
}
