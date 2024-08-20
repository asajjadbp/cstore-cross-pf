class SavePosData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SavePosListData> posList;

  SavePosData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.posList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'proof_of_sales': posList.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePosListData {
  final int clientId;
  final int skuId;
  final String name;
  final String email;
  final String phoneNo;
  final String imageName;
  final int amount;
  final int quantity;

  SavePosListData({
    required this.clientId,
    required this.skuId,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.imageName,
    required this.amount,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'name': name,
      'email': email,
      'phone': phoneNo,
      'amount': amount,
      'image_name': imageName,
      'qty': quantity,
    };
  }
}