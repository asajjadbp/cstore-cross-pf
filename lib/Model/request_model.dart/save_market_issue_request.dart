class SaveMarketIssueData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveMarketIssueListData> marketIssueList;

  SaveMarketIssueData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.marketIssueList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'market_issues': marketIssueList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveMarketIssueListData {
  final int issueId;
  final int clientId;
  final String imageName;
  final String comment;

  SaveMarketIssueListData({
    required this.issueId,
    required this.clientId,
    required this.comment,
    required this.imageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'issue_id': issueId,
      'comment': comment,
      'image_name': imageName,
    };
  }
}