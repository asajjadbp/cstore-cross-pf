class ClientModel {
  late final int id;
  late int client_id=0;
  late String client_name="";
  late final String logo;
  late final int classification;
  late final int chain_sku_code;
  late final int day_freshness;
  late final int order_avl;
  late final int is_survey;
  late final int geo_requried;


  ClientModel({
    required this.client_id,
    required this.client_name,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'client_id': client_id,
      'client_name': client_name,
    };
  }

  @override
  String toString() {
    return 'ClientModel{client_id: $client_id, client_name: $client_name}';
  }
}
