import '../../database/table_name.dart';

class UserDashboardListResponseModel {
  bool? status;
  String? msg;
  List<UserDashboardModel>? data;

  UserDashboardListResponseModel({this.status, this.msg, this.data});

  UserDashboardListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <UserDashboardModel>[];
      json['data'].forEach((v) {
        data!.add(UserDashboardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDashboardModel {
  late int user_id;
  late int jp_planned;
  late int jp_visited;
  late int out_of_planned;
  late int out_of_planned_visited;
  late int jpc;
  late int pro;
  late int working_hrs;
  late int eff;
  late int monthly_attend;
  late int monthly_pro;
  late int monthly_eff;
  late int monthly_incentives;
  late int monthly_deduction;

  UserDashboardModel({
    required this.user_id,
    required this.jp_planned,
    required this.jp_visited,
    required this.out_of_planned,
    required this.out_of_planned_visited,
    required this.jpc,
    required this.pro,
    required this.working_hrs,
    required this.eff,
    required this.monthly_attend,
    required this.monthly_pro,
    required this.monthly_eff,
    required this.monthly_incentives,
    required this.monthly_deduction,
  });


  UserDashboardModel.fromJson(Map<String, dynamic> json) {
    user_id= json['user_id']??0;
    jp_planned= json['jp_planned']??0;
    jp_visited=json['jp_visited']??0;
    out_of_planned= json['out_of_planned']??0;
    out_of_planned_visited=json['out_of_plan_visited']??0;
    jpc= json['jpc'] ??0;
    pro= json['pro']??0;
    working_hrs= json['working_hrs']??0;
    eff= json['eff']??0;
    monthly_attend= json['monthly_attend']??0;
    monthly_pro= json['monthly_pro']??0;
    monthly_eff= json['monthly_eff']??0;
    monthly_incentives= json['monthly_incentives']??0;
    monthly_deduction= json['monthly_deduction']??0;

  }
  Map<String, dynamic> toJson() => {
    'user_id': user_id ,
    'jp_planned': jp_planned ,
    'jp_visited': jp_visited ,
    'out_of_planned': out_of_planned ,
    'out_of_plan_visited': out_of_planned_visited ,
    'jpc': jpc ,
    'pro': pro ,
    'working_hrs': working_hrs ,
    'eff': eff ,
    'monthly_attend': monthly_attend ,
    'monthly_pro': monthly_pro ,
    'monthly_eff': monthly_eff ,
    'monthly_incentives': monthly_incentives ,
    'monthly_deduction': monthly_deduction ,
  };
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id ,
      'jp_planned': jp_planned ,
      'jp_visited': jp_visited ,
      'out_of_planned': out_of_planned ,
      'out_of_plan_visited': out_of_planned_visited ,
      'jpc': jpc ,
      'pro': pro ,
      'working_hrs': working_hrs ,
      'eff': eff ,
      'monthly_attend': monthly_attend ,
      'monthly_pro': monthly_pro ,
      'monthly_eff': monthly_eff ,
      'monthly_incentives': monthly_incentives ,
      'monthly_deduction': monthly_deduction ,
    };
  }

  factory UserDashboardModel.fromMap(Map<String, dynamic> map) {
    return UserDashboardModel(
      user_id: map['user_id'] as int,
      jp_planned: map['jp_planned'] as int,
      jp_visited: map['jp_visited'] as int,
      out_of_planned: map['out_of_planned'] as int,
      out_of_planned_visited: map['out_of_plan_visited'] as int,
      jpc: map['jpc'] as int,
      pro: map['pro'] as int,
      working_hrs: map['working_hrs'] as int,
      eff: map['eff'] as int,
      monthly_attend: map['monthly_attend'] as int,
      monthly_pro: map['monthly_pro'] as int,
      monthly_eff: map['monthly_eff'] as int,
      monthly_incentives: map['monthly_incentives'] as int,
      monthly_deduction: map['monthly_deduction'] as int,
    );
  }
}
