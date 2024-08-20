class SaveOnePlusOneData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveOnePlusOneListData> onePlusOneList;

  SaveOnePlusOneData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.onePlusOneList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'one_plus_one': onePlusOneList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveOnePlusOneListData {

  final int skuId;
  final int pieces;
  final int type;
  final String imageName;
  final String docNumber;
  final String docImage;

  SaveOnePlusOneListData({
    required this.skuId,
    required this.pieces,
    required this.type,
    required this.imageName,
    required this.docNumber,
    required this.docImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'pieces': pieces,
      'type': type,
      'doc_no': docNumber,
      'image_name': imageName,
      'doc_image': docImage,
    };
  }
}