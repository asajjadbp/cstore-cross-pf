import 'package:cstore/Model/database_model/sys_survey_question_option_model.dart';

import '../../database/table_name.dart';

class sysSurveyQuestionModel {
  late int id;
  late String en_question;
  late String ar_question;
  late String answer_type;
  late List<sysSurveyQuestionOptionModel> answer_option;


  sysSurveyQuestionModel({
    required this.id,
    required this.en_question,
    required this.ar_question,
    required this.answer_type,
    required this.answer_option
  });
  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.SysSurveyEnQuestion:  en_question,
      TableName.SysSurveyArQuestion: ar_question,
      TableName.SysSurveyAnswerType: answer_type,
      TableName.SysSurveyAnswerOption: List<sysSurveyQuestionOptionModel>.from(answer_option.map((x) => x.toJson())),
    };
  }

  
  sysSurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    en_question = json[TableName.SysSurveyEnQuestion] ?? "";
    ar_question = json[TableName.SysSurveyArQuestion] ?? "" ;
    answer_type = json[TableName.SysSurveyAnswerType] ?? "";
    answer_option =  List<sysSurveyQuestionOptionModel>.from(
        json[TableName.SysSurveyAnswerOption].map((x) => sysSurveyQuestionOptionModel.fromJson(x)));
  }
  Map<String, dynamic> toJson() => {
    TableName.sysId: id,
    TableName.SysSurveyEnQuestion : en_question,
    TableName.SysSurveyArQuestion: ar_question,
    TableName.SysSurveyAnswerType: answer_type,
    TableName.SysSurveyAnswerOption:  List<dynamic>.from(answer_option.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'sysSurveyQuestionModel{id: $id, en_question: $en_question, ar_question: $ar_question, answer_type: $answer_type, answer_option: $answer_option}';
  }
}
