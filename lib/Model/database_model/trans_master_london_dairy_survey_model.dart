import '../../database/table_name.dart';

class TransLondonSurveyModel {
  late int id;
  late int workingId;
  late int storeId;
  late int companyId;
  late int questionId;
  late String answer;
  late String image;
  late String isActive;
  late String userId;
  late String updateAt;

  Map<String, Object?> toMap() {
    return {
      TableName.workingId: workingId,
      TableName.storeId: storeId,
      TableName.companyId: companyId,
      TableName.SysSurveyOptQuestionId: questionId,
      TableName.transSurveyAnswer: answer,
      TableName.sys_product_image: image,
      TableName.SysSurveyIsActive:isActive,
      TableName.userId:userId,
      TableName.SysSurveyOptUpdatedAt:updateAt,
    };
  }

  TransLondonSurveyModel.fromJson(Map<String, dynamic> json) {
    workingId = json[TableName.workingId];
    storeId = json[TableName.storeId];
    companyId = json[TableName.companyId];
    questionId = json[TableName.SysSurveyOptQuestionId];
    answer = json[TableName.transSurveyAnswer];
    image = json[TableName.sys_product_image];
    isActive = json[TableName.SysSurveyIsActive];
    userId = json[TableName.userId];
    updateAt = json[TableName.SysSurveyOptUpdatedAt];

  }

  TransLondonSurveyModel({
    required this.workingId,
    required this.storeId,
    required this.companyId,
    required this.questionId,
    required this.answer,
    required this.image,
    required this.isActive,
    required this.userId,
    required this.updateAt,
  });
}
