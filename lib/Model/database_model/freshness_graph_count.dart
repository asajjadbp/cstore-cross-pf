
class FreshnessGraphCountShowModel {
  late int totalFreshnessTaken;
  late int totalVolume;
  late int totalNotUploadCount;
  late int totalUploadCount;

  FreshnessGraphCountShowModel.fromJson(Map<String, dynamic> json) {
    totalFreshnessTaken = json['total_freshness_taken'] ?? 0;
    totalVolume = json['total_volume'] ?? 0;
    totalNotUploadCount = json['total_not_upload'];
    totalUploadCount = json['total_upload'];
  }

  Map<String, dynamic> toJson() => {
    'total_freshness_taken': totalFreshnessTaken,
    'total_volume': totalVolume,
    'total_not_upload' : totalNotUploadCount,
    'total_upload' : totalUploadCount,
  };

  FreshnessGraphCountShowModel({
    required this.totalFreshnessTaken,
    required this.totalVolume,
    required this.totalUploadCount,
    required this.totalNotUploadCount
  });

  Map<String, dynamic> toMap() {
    return {
      'total_freshness_taken': this.totalFreshnessTaken,
      'total_volume': this.totalVolume,
      'total_upload' : this.totalUploadCount,
      'total_not_upload': this.totalNotUploadCount,
    };
  }

  factory FreshnessGraphCountShowModel.fromMap(Map<String, dynamic> map) {
    return FreshnessGraphCountShowModel(
      totalFreshnessTaken: map['total_freshness_taken'] ?? 0,
      totalVolume: map['total_volume'] ?? 0,
      totalNotUploadCount: map['total_not_upload'] ?? 0,
      totalUploadCount: map['total_upload'] ?? 0,
    );
  }
}
