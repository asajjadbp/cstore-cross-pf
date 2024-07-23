// class AdherenceModel {
//   late  int adhereCount;
//   late  int notAdhereCount;
//
//   AdherenceModel({
//     required this.adhereCount,
//     required this.notAdhereCount,
//   });
//
//   AdherenceModel.fromJson(Map<String, dynamic> json) {
//     adhereCount = json['total_adhere'] ?? 0;
//     notAdhereCount = json['total_not_adhere']?? 0;
//   }
//
// }

class AdherenceModel {
  int adhereCount;
  int notAdhereCount;

  AdherenceModel({required this.adhereCount, required this.notAdhereCount});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_adhere': adhereCount,
      'total_not_adhere': notAdhereCount,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory AdherenceModel.fromJson(Map<String, dynamic> json) {
    return AdherenceModel(
       adhereCount : json['total_adhere'],
        notAdhereCount : json['total_not_adhere'],
    );
  }
}

class AvailableCountModel {
  int totalAvl;
  int totalNotAvl;
  int totalProducts;

  AvailableCountModel({required this.totalAvl, required this.totalNotAvl,required this.totalProducts});

  // Method to convert an instance of AvailableCountModel to a map
  Map<String, dynamic> toJson() {
    return {
      'total_avl': totalAvl,
      'total_not_avl': totalNotAvl,
      'total_products' : totalProducts,
    };
  }

  // Factory method to create an instance of AvailableCountModel from a map
  factory AvailableCountModel.fromJson(Map<String, dynamic> json) {
    return AvailableCountModel(
      totalAvl: json['total_avl'],
      totalNotAvl: json['total_not_avl'],
        totalProducts: json['total_products'],
    );
  }
}