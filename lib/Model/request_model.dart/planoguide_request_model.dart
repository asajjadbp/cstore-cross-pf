class SavePlanoguide {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SavePlanoguideListData> pogs;

  SavePlanoguide({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.pogs,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'pogs': pogs.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePlanoguideListData {
  final String pogId;
  final String clientId;
  final String catId;
  final String pogText;
  final String adhStatus;
  final String pogImageName;

  SavePlanoguideListData({
    required this.pogId,
    required this.clientId,
    required this.catId,
    required this.pogText,
    required this.adhStatus,
    required this.pogImageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id':pogId,
      'client_id': clientId,
      'category_id': catId,
      'pog': pogText.toString(),
      'is_adh': adhStatus,
      'image_name': pogImageName.toString(),
    };
  }
}