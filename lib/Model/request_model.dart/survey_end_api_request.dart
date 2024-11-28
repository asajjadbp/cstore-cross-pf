
class SaveSurvey {
  final String username;
  final String workingId;
  final String workingDate;
  final String storeId;
  final List<SaveSurveyData> surveyList;

  SaveSurvey({
    required this.username,
    required this.workingId,
    required this.workingDate,
    required this.storeId,
    required this.surveyList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'working_date':workingDate,
      'store_id': storeId,
      'survey': surveyList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveSurveyData {
  final String clientId;
  final int questionId;
  final String answer;
  final String imageNames;

  SaveSurveyData({
    required this.clientId,
    required this.questionId,
    required this.answer,
    required this.imageNames,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'question_id': questionId,
      'answer': answer,
      'image': imageNames,
    };
  }
}