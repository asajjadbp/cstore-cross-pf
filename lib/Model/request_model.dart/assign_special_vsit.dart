
import 'dart:convert';

AssignSpecialVisitRequest assignSpecialVisitRequestFromJson(String str) =>
    AssignSpecialVisitRequest.fromJson(json.decode(str));

String assignSpecialVisitRequestToJson(AssignSpecialVisitRequest data) =>
    json.encode(data.toJson());

class AssignSpecialVisitRequest {
  final String username;
  final String clientIds;
  final String storeId;
  final String visitActivityType;

  AssignSpecialVisitRequest({
    required this.username,
    required this.clientIds,
    required this.storeId,
    required this.visitActivityType,
  });

  factory AssignSpecialVisitRequest.fromJson(Map<String, dynamic> json) =>
      AssignSpecialVisitRequest(
        username: json["username"],
        clientIds: json["client_ids"],
        storeId: json["store_id"],
        visitActivityType: json["visit_activity_type"],
      );

  Map<String, dynamic> toJson() => {
    'username': username,
    'client_ids': clientIds,
    'store_id': storeId,
    'visit_activity_type': visitActivityType,
  };
}