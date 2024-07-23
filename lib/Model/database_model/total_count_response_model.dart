class AvailabilityCountModel {
  int totalSku;
  int totalAvl;
  int totalNotAvl;
  int totalNotUploaded;
  int totalUploaded;
  int totalNotMarked;

  AvailabilityCountModel({required this.totalSku,required this.totalAvl ,required this.totalNotAvl,required this.totalNotUploaded,required this.totalUploaded,required this.totalNotMarked});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_sku': totalSku,
      'total_avl': totalAvl,
      'total_not_avl' : totalNotAvl,
      'total_not_uploaded': totalNotUploaded,
      'total_uploaded' : totalUploaded,
      'total_not_marked' : totalNotMarked,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory AvailabilityCountModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityCountModel(
      totalSku: json['total_sku'],
      totalAvl: json['total_avl'],
      totalNotAvl: json['total_not_avl'],
      totalNotUploaded: json['total_not_uploaded'],
      totalUploaded: json['total_uploaded'],
      totalNotMarked: json['total_not_marked'],
    );
  }
}

class PlanoguideCountModel {
  int totalPlano;
  int totalAdhere;
  int totalNotAdhere;
  int totalNotUploaded;
  int totalUploaded;
  int totalImagesNotUploaded;
  int totalImagesUploaded;
  int totalNotMarkedPlano;

  PlanoguideCountModel({required this.totalPlano,required this.totalAdhere ,required this.totalNotAdhere,required this.totalNotUploaded,required this.totalUploaded,required this.totalImagesNotUploaded,required this.totalImagesUploaded,required this.totalNotMarkedPlano});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_plano': totalPlano,
      'total_adhere': totalAdhere,
      'total_not_adhere' : totalNotAdhere,
      'total_not_uploaded': totalNotUploaded,
      'total_uploaded' : totalUploaded,
      'total_images_not_uploaded': totalImagesNotUploaded,
      'total_images_uploaded' : totalImagesUploaded,
      'total_not_marked' : totalNotMarkedPlano,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory PlanoguideCountModel.fromJson(Map<String, dynamic> json) {
    return PlanoguideCountModel(
      totalPlano: json['total_plano'],
      totalAdhere: json['total_adhere'],
      totalNotAdhere: json['total_not_adhere'],
      totalNotUploaded: json['total_not_uploaded'],
      totalUploaded: json['total_uploaded'],
      totalImagesNotUploaded: json['total_images_not_uploaded'],
      totalImagesUploaded: json['total_images_uploaded'],
      totalNotMarkedPlano: json['total_not_marked'],
    );
  }
}

class BrandShareCountModel {
  int totalBrandShare;
  int totalNotUpload;
  int totalUpload;
  int totalReadyBrands;
  int totalNotReadyBrands;

  BrandShareCountModel({required this.totalBrandShare,required this.totalNotUpload ,required this.totalUpload,required this.totalReadyBrands,required this.totalNotReadyBrands});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_brand_share': totalBrandShare,
      'total_not_uploaded': totalNotUpload,
      'total_uploaded' : totalUpload,
      'total_ready_brand' : totalReadyBrands,
      'total_not_ready_brand':totalNotReadyBrands,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory BrandShareCountModel.fromJson(Map<String, dynamic> json) {
    return BrandShareCountModel(
      totalBrandShare: json['total_brand_share'],
      totalNotUpload: json['total_not_uploaded'],
      totalUpload: json['total_uploaded'],
      totalReadyBrands: json['total_ready_brand'],
      totalNotReadyBrands: json['total_not_ready_brand'],
    );
  }
}

class PickListCountModel {
  int totalPickListItems;
  int totalNotUpload;
  int totalUpload;
  int totalPickReady;
  int totalPickNotReady;

  PickListCountModel({required this.totalPickListItems,required this.totalNotUpload ,required this.totalUpload,required this.totalPickReady,required this.totalPickNotReady});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_picklist_items': totalPickListItems,
      'total_not_uploaded': totalNotUpload,
      'total_uploaded' : totalUpload,
      'total_pick_ready' : totalPickReady,
      'total_pick_not_ready' : totalPickNotReady,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory PickListCountModel.fromJson(Map<String, dynamic> json) {
    return PickListCountModel(
      totalPickListItems: json['total_picklist_items'],
      totalNotUpload: json['total_not_uploaded'],
      totalUpload: json['total_uploaded'],
      totalPickReady: json['total_pick_ready'],
      totalPickNotReady: json['total_pick_not_ready'],
    );
  }
}

class TmrPickListCountModel {
  int totalPickListItems;
  int totalPickNotUpload;
  int totalPickUpload;
  int totalPickReady;
  int totalPickNotReady;

  TmrPickListCountModel({required this.totalPickListItems,required this.totalPickNotUpload ,required this.totalPickUpload,required this.totalPickReady,required this.totalPickNotReady});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_sku': totalPickListItems,
      'total_pick_not_uploaded': totalPickNotUpload,
      'total_pick_uploaded' : totalPickUpload,
      'total_pick_ready' : totalPickReady,
      'total_pick_not_ready' : totalPickNotReady,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory TmrPickListCountModel.fromJson(Map<String, dynamic> json) {
    return TmrPickListCountModel(
      totalPickListItems: json['total_sku'],
      totalPickNotUpload: json['total_pick_not_uploaded'],
      totalPickUpload: json['total_pick_uploaded'],
      totalPickReady: json['total_pick_ready'],
      totalPickNotReady: json['total_pick_not_ready'],
    );
  }
}

class RtvCountModel {
  int totalRtv;
  int totalNotUpload;
  int totalUpload;

  RtvCountModel({required this.totalRtv,required this.totalNotUpload ,required this.totalUpload});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_rtv': totalRtv,
      'total_not_uploaded': totalNotUpload,
      'total_uploaded' : totalUpload,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory RtvCountModel.fromJson(Map<String, dynamic> json) {
    return RtvCountModel(
      totalRtv: json['total_rtv'],
      totalNotUpload: json['total_not_uploaded'],
      totalUpload: json['total_uploaded'],
    );
  }
}

class PriceCheckCountModel {
  int totalPriceCheck;
  int totalNotUpload;
  int totalUpload;

  PriceCheckCountModel({required this.totalPriceCheck,required this.totalNotUpload ,required this.totalUpload});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_price_check': totalPriceCheck,
      'total_not_uploaded': totalNotUpload,
      'total_uploaded' : totalUpload,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory PriceCheckCountModel.fromJson(Map<String, dynamic> json) {
    return PriceCheckCountModel(
      totalPriceCheck: json['total_price_check'],
      totalNotUpload: json['total_not_uploaded'],
      totalUpload: json['total_uploaded'],
    );
  }
}