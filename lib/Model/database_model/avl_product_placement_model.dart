import '../../database/table_name.dart';

class AvlProductPlacementModel {
  late String shelfNo;
  late String buyNo;
  late String h_facing;
  late String v_facing;
  late String d_facing;
  late String pog;

  AvlProductPlacementModel({
    required this.shelfNo,
    required this.buyNo,
    required this.h_facing,
    required this.v_facing,
    required this.d_facing,
    required this.pog,
  });
  Map<String, Object?> toMap() {
    return {
      "shelfNo": shelfNo,
      "buyNo": buyNo,
      "h_facing": h_facing,
      "v_facing": v_facing,
      "d_facing": d_facing,
      "pog": pog,

    };
  }

  AvlProductPlacementModel.fromJson(Map<String, dynamic> json) {
    shelfNo = json["shelfNo"].toString();
    buyNo = json["buyNo"].toString();
    h_facing = json["h_facing"].toString();
    v_facing = json["v_facing"].toString();
    d_facing = json["d_facing"].toString();
    pog = json["pog"].toString();
  }

  Map<String, dynamic> toJson() => {
    "shelfNo": shelfNo,
    "buyNo": buyNo,
    "h_facing": h_facing,
    "v_facing": v_facing,
    "d_facing": d_facing,
    "pog": pog,
  };
}
