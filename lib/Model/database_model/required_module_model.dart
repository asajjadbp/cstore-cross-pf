import '../../Database/table_name.dart';

class RequiredModuleModel{

  late int moduleId;
  late int visitActivityTypeId;

  RequiredModuleModel(
      {
        required this.moduleId,
        required this.visitActivityTypeId,
      });

  Map<String, Object?> toMap() {
    return {
      TableName.tblSysModuleId:moduleId,
      TableName.tblSysVisitActivityType:visitActivityTypeId,
    };
  }

  RequiredModuleModel.fromJson(Map<String, dynamic> json) {
    moduleId = json[TableName.tblSysModuleId];
    visitActivityTypeId = json[TableName.tblSysVisitActivityType];
  }

  Map<String, dynamic> toJson() => {
    TableName.tblSysModuleId: moduleId,
    TableName.tblSysVisitActivityType: visitActivityTypeId,
  };
}