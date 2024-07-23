import 'dart:math';

class ReadyPickList {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<ReadyPickListData> readyPickList;

  ReadyPickList({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.readyPickList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'ready_picklist': readyPickList.map((image) => image.toJson()).toList(),
    };
  }
}

class ReadyPickListData {
  final int pickListId;
  final int actualPicklist;
  final String picklistReason;

  ReadyPickListData({
    required this.pickListId,
    required this.actualPicklist,
    required this.picklistReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'picklist_id': pickListId,
      'act_picklist': actualPicklist,
      'picklist_reason':picklistReason,
    };
  }
}