import '../../database/table_name.dart';

class sysSurveyQuestionOptionModel {
  late int id;
  late int questionId;
  late String en_name;
  late String ar_name;
  late String answer_type;

  sysSurveyQuestionOptionModel({
    required this.id,
    required this.questionId,
    required this.en_name,
    required this.ar_name,
    required this.answer_type,
  });
  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.SysSurveyOptQuestionId:  questionId,
      TableName.enName: en_name,
      TableName.arName: ar_name,
      TableName.SysSurveyQuestionType: answer_type,
    };
  }

  sysSurveyQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    questionId = json[TableName.SysSurveyOptQuestionId];
    en_name = json[TableName.enName] ?? "";
    ar_name = json[TableName.arName] ?? "";
    answer_type = json[TableName.SysSurveyQuestionType] ?? "";
  }
  Map<String, dynamic> toJson() => {
    TableName.sysId: id,
    TableName.SysSurveyOptQuestionId:  questionId,
    TableName.enName: en_name,
    TableName.arName: ar_name,
    TableName.SysSurveyQuestionType: answer_type,
  };

  @override
  String toString() {
    return 'sysSurveyQuestionOptionModel{id: $id, questionId: $questionId, en_name: $en_name, ar_name: $ar_name, type: $answer_type}';
  }
}


class TransSurveyModel {
  late int id;
  late int questionId;
  late String answerText;
  late String imageName;

  TransSurveyModel({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.imageName,
  });
  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.SysSurveyOptQuestionId:  questionId,
      TableName.transSurveyAnswer: answerText,
      TableName.trans_one_plus_one_image: imageName,
    };
  }

  TransSurveyModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    questionId = json[TableName.SysSurveyOptQuestionId];
    answerText = json[TableName.transSurveyAnswer] ?? "";
    imageName = json[TableName.trans_one_plus_one_image] ?? "";
  }
  Map<String, dynamic> toJson() => {
    TableName.sysId: id,
    TableName.SysSurveyOptQuestionId:  questionId,
    TableName.transSurveyAnswer: answerText,
    TableName.trans_one_plus_one_image: imageName,
  };

  @override
  String toString() {
    return 'sysSurveyQuestionOptionModel{id: $id, questionId: $questionId, answerText: $answerText, imageName: $imageName }';
  }
}
