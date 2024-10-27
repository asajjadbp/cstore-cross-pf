class AssignSpecialVisitRequest {
  final String username;
  final String clientIds;
  final int storeId;

  AssignSpecialVisitRequest({
    required this.username,
    required this.clientIds,
    required this.storeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'client_ids': clientIds,
      'store_id': storeId,
    };
  }
}