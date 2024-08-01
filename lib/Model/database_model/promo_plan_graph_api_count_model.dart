class PromoPlanGraphAndApiCountShowModel {
  late int totalPromoPLan;
  late int totalDeployed;
  late int totalNotDeployed;
  late int totalPending;
  late int totalNotUploadCount;
  late int totalUploadCount;

  PromoPlanGraphAndApiCountShowModel.fromJson(Map<String, dynamic> json) {
    totalPromoPLan = json['total_promo'] ?? 0;
    totalDeployed = json['total_deployed'] ?? 0;
    totalNotDeployed = json['total_not_deployed'] ?? 0;
    totalPending = json['total_pending'] ?? 0;
    totalNotUploadCount = json['total_not_upload'];
    totalUploadCount = json['total_upload'];
  }

  Map<String, dynamic> toJson() => {
    'total_promo': totalPromoPLan,
    'total_deployed': totalDeployed,
    'total_not_deployed': totalNotDeployed,
    'total_pending': totalPending,
    'total_not_upload' : totalNotUploadCount,
    'total_upload' : totalUploadCount,
  };

  PromoPlanGraphAndApiCountShowModel({
    required this.totalPromoPLan,
    required this.totalDeployed,
    required this.totalNotDeployed,
    required this.totalPending,
    required this.totalUploadCount,
    required this.totalNotUploadCount
  });

  Map<String, dynamic> toMap() {
    return {
      'total_promo': this.totalPromoPLan,
      'total_deployed': this.totalDeployed,
      'total_not_deployed': this.totalNotDeployed,
      'total_pending': this.totalPending,
      'total_upload' : this.totalUploadCount,
      'total_not_upload': this.totalNotUploadCount,
    };
  }

  factory PromoPlanGraphAndApiCountShowModel.fromMap(Map<String, dynamic> map) {
    return PromoPlanGraphAndApiCountShowModel(
      totalPromoPLan: map['total_promo'] ?? 0,
      totalDeployed: map['total_deployed'] ?? 0,
      totalNotDeployed: map['total_not_deployed'] ?? 0,
      totalPending: map['total_pending'] ?? 0,
      totalNotUploadCount: map['total_not_upload'] ?? 0,
      totalUploadCount: map['total_upload'] ?? 0,
    );
  }
}