class PromoPlanListModel {
  bool? status;
  String? msg;
  List<PromoPlanItem>? data;

  PromoPlanListModel({this.status, this.msg, this.data});

  PromoPlanListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <PromoPlanItem>[];
      json['data'].forEach((v) {
        data!.add( PromoPlanItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromoPlanItem {
  int? id;
  int? bpProductCode;
  String? name;
  String? skuPicture;
  String? categoryName;
  String? brandName;
  String? from;
  String? to;
  String? osdType;
  int? qty;
  String? promoScope;
  int? promoPrice;
  String? leftOverAction;

  PromoPlanItem(
      {this.id,
        this.bpProductCode,
        this.name,
        this.skuPicture,
        this.categoryName,
        this.brandName,
        this.from,
        this.to,
        this.osdType,
        this.qty,
        this.promoScope,
        this.promoPrice,
        this.leftOverAction});

  PromoPlanItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bpProductCode = json['bp_product_code'];
    name = json['name'];
    skuPicture = json['sku_picture'];
    categoryName = json['category_name'];
    brandName = json['brand_name'];
    from = json['from'];
    to = json['to'];
    osdType = json['osd_type'];
    qty = json['qty'];
    promoScope = json['promo_scope'];
    promoPrice = json['promo_price'] ?? 0;
    leftOverAction = json['left_over_action'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bp_product_code'] = bpProductCode;
    data['name'] = name;
    data['sku_picture'] = skuPicture;
    data['category_name'] = categoryName;
    data['brand_name'] = brandName;
    data['from'] = from;
    data['to'] = to;
    data['osd_type'] = osdType;
    data['qty'] = qty;
    data['promo_scope'] = promoScope;
    data['promo_price'] = promoPrice;
    data['left_over_action'] = leftOverAction;
    return data;
  }
}