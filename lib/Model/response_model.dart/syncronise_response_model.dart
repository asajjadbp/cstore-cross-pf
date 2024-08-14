// To parse this JSON data, do
//
//     final syncroniseResponseModel = syncroniseResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:cstore/Model/response_model.dart/jp_response_model.dart';
import 'package:cstore/Model/response_model.dart/user_dashboard_model.dart';

import '../database_model/PlanogramReasonModel.dart';
import '../database_model/app_setting_model.dart';
import '../database_model/knowledgeShare_model.dart';
import '../database_model/pomo_plan_model.dart';
import '../database_model/required_module_model.dart';
import '../database_model/sys_brand_faces_model.dart';
import '../database_model/sys_osdc_reason_model.dart';
import '../database_model/sys_osdc_type_model.dart';
import '../database_model/sys_photo_type.dart';
import '../database_model/sys_product_model.dart';
import '../database_model/sys_product_placement_model.dart';
import '../database_model/sys_rtv_reason_model.dart';
import '../database_model/sys_store_pog_model.dart';

SyncroniseResponseModel syncroniseResponseModelFromJson(String str) =>
    SyncroniseResponseModel.fromJson(json.decode(str));

String syncroniseResponseModelToJson(SyncroniseResponseModel data) =>
    json.encode(data.toJson());

class SyncroniseResponseModel {
  bool status;
  String msg;
  List<SyncroniseDetail> data;

  SyncroniseResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SyncroniseResponseModel.fromJson(Map<String, dynamic> json) =>
      SyncroniseResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<SyncroniseDetail>.from(
            json["data"].map((x) => SyncroniseDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SyncroniseDetail {
  List<Sys> sysDropReason;
  List<SysAgencyDashboard> sysAgencyDashboard;
  List<SysClient> sysClient;
  List<CategoryResModel> sysCategory;
  List<CategoryResModel> sysSubCategory;
  List<CategoryResModel> sysBrand;
  List<PlanogramReasonModel> sysPlanoReason;
  List<Sys_RTVReasonModel> sysRTVReason;
  List<Sys_ProductModel> sysProduct;
  List<Sys_PhotoTypeModel> sysPhotoType;
  List<Sys_OSDCTypeModel> sysOsdcType;
  List<Sys_OSDCReasonModel> sysOsdcReason;

  List<SysProductPlacementModel> sysProductPlacement;
  List<SysStorePogModel> sysStorePog;
  List<SysBrandFacesModel> sysBrandFaces;
  List<SysAppSettingModel> sysAppSetting;
  List<Sys_OSDCTypeModel> sysDailCheckList;
  List<Sys_OSDCTypeModel> sysSosUnit;
  List<RequiredModuleModel> sysReqModule;
  List<PromoPlanModel> sysPromoPlan;
  List<JourneyPlanDetail> sysJourneyPlan;
  List<UserDashboardModel> sysDashboard;
  List<KnowledgeShareModel> knowledgeShareModel;

  SyncroniseDetail({
    required this.sysDropReason,
    required this.sysAgencyDashboard,
    required this.sysClient,
    required this.sysCategory,
    required this.sysSubCategory,
    required this.sysBrand,
    required this.sysPlanoReason,
    required this.sysRTVReason,
    required this.sysProduct,
    required this.sysPhotoType,
    required this.sysOsdcType,
    required this.sysOsdcReason,
    required this.sysProductPlacement,
    required this.sysStorePog,
    required this.sysBrandFaces,
    required this.sysAppSetting,
    required this.sysDailCheckList,
    required this.sysSosUnit,
    required this.sysReqModule,
    required this.sysPromoPlan,
    required this.sysJourneyPlan,
    required this.sysDashboard,
    required this.knowledgeShareModel,
  });

  factory SyncroniseDetail.fromJson(Map<String, dynamic> json) =>
      SyncroniseDetail(
        sysDropReason:
            List<Sys>.from(json["sys_drop_reason"].map((x) => Sys.fromJson(x))),
        sysAgencyDashboard: List<SysAgencyDashboard>.from(
            json["sys_agency_dashboard"]
                .map((x) => SysAgencyDashboard.fromJson(x))),
        sysClient: List<SysClient>.from(
            json["sys_client"].map((x) => SysClient.fromJson(x))),
        sysCategory: List<CategoryResModel>.from(
            json["sys_category"].map((x) => CategoryResModel.fromJson(x))),
        sysSubCategory: List<CategoryResModel>.from(
            json["sys_subcategory"].map((x) => CategoryResModel.fromJson(x))),
        sysBrand: List<CategoryResModel>.from(
            json["sys_brand"].map((x) => CategoryResModel.fromJson(x))),
        sysPlanoReason: List<PlanogramReasonModel>.from(
            json["sys_planogram_reason"].map((x) => PlanogramReasonModel.fromJson(x))),
        sysRTVReason: List<Sys_RTVReasonModel>.from(
            json["sys_rtv_reason"].map((x) => Sys_RTVReasonModel.fromJson(x))),
        sysProduct: List<Sys_ProductModel>.from(
            json["sys_product"].map((x) => Sys_ProductModel.fromJson(x))),
        sysPhotoType: List<Sys_PhotoTypeModel>.from(
            json["sys_photo_type"].map((x) => Sys_PhotoTypeModel.fromJson(x))),
        sysOsdcType: List<Sys_OSDCTypeModel>.from(
            json["sys_osdc_type"].map((x) => Sys_OSDCTypeModel.fromJson(x))),
        sysOsdcReason: List<Sys_OSDCReasonModel>.from(
            json["sys_osdc_reason"].map((x) => Sys_OSDCReasonModel.fromJson(x))),

        sysStorePog: List<SysStorePogModel>.from(
            json["sys_store_pog"].map((x) => SysStorePogModel.fromJson(x))),
        sysProductPlacement: List<SysProductPlacementModel>.from(
            json["sys_product_placement"].map((x) => SysProductPlacementModel.fromJson(x))),
        sysBrandFaces: List<SysBrandFacesModel>.from(
            json["sys_brand_faces"].map((x) => SysBrandFacesModel.fromJson(x))),
        sysAppSetting: List<SysAppSettingModel>.from(
            json["sys_app_setting"].map((x) => SysAppSettingModel.fromJson(x))),
        sysDailCheckList: List<Sys_OSDCTypeModel>.from(
            json["sys_daily_checklist"]
                .map((x) => Sys_OSDCTypeModel.fromJson(x))),
        sysSosUnit: List<Sys_OSDCTypeModel>.from(
            json["sys_sos_units"].map((x) => Sys_OSDCTypeModel.fromJson(x))),
          sysReqModule: List<RequiredModuleModel>.from(
              json["sys_visit_required_modules"].map((x) => RequiredModuleModel.fromJson(x))),
        sysPromoPlan: List<PromoPlanModel>.from(
            json["sys_promo_plan"].map((x) => PromoPlanModel.fromJson(x))),
        sysJourneyPlan: List<JourneyPlanDetail>.from(
            json["sys_jp"].map((x) => JourneyPlanDetail.fromJson(x))),
        sysDashboard: List<UserDashboardModel>.from(
            json["sys_dashboard"].map((x) => UserDashboardModel.fromJson(x))),
        knowledgeShareModel: List<KnowledgeShareModel>.from(
            json["sys_knowledge_share"].map((x) => KnowledgeShareModel.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
      "sys_drop_reason": List<dynamic>.from(sysDropReason.map((x) => x.toJson())),
      "sys_agency_dashboard": List<dynamic>.from(sysAgencyDashboard.map((x) => x.toJson())),
      "sys_client": List<dynamic>.from(sysClient.map((x) => x.toJson())),
      "sys_category": List<dynamic>.from(sysCategory.map((x) => x.toJson())),
      "sys_brand": List<dynamic>.from(sysBrand.map((x) => x.toJson())),
      "sys_planogram_reason": List<dynamic>.from(sysPlanoReason.map((x) => x.toJson())),
      "sys_rtv_reason": List<dynamic>.from(sysRTVReason.map((x) => x.toJson())),
      "sys_product": List<dynamic>.from(sysProduct.map((x) => x.toJson())),
      "sys_photo_type": List<dynamic>.from(sysPhotoType.map((x) => x.toJson())),
      "sys_osdc_type": List<dynamic>.from(sysOsdcType.map((x) => x.toJson())),
      "sys_osdc_reason": List<dynamic>.from(sysOsdcReason.map((x) => x.toJson())),
      "sys_app_setting": List<dynamic>.from(sysOsdcType.map((x) => x.toJson())),
      "sys_daily_checklist": List<dynamic>.from(sysOsdcType.map((x) => x.toJson())),
      "sys_sos_units": List<dynamic>.from(sysOsdcType.map((x) => x.toJson())),
      "sys_store_pog": List<dynamic>.from(sysStorePog.map((x) => x.toJson())),
      "sys_product_placement": List<dynamic>.from(sysProductPlacement.map((x) => x.toJson())),
      "sys_brand_faces": List<dynamic>.from(sysBrandFaces.map((x) => x.toJson())),
      "sys_visit_required_modules": List<dynamic>.from(sysReqModule.map((x) => x.toJson())),
      "sys_promo_plan":  List<dynamic>.from(sysPromoPlan.map((x) => x.toJson())),
      "sys_jp":  List<dynamic>.from(sysJourneyPlan.map((x) => x.toJson())),
      "sys_dashboard":  List<dynamic>.from(sysDashboard.map((x) => x.toJson())),
      "sys_knowledge_share":  List<dynamic>.from(knowledgeShareModel.map((x) => x.toJson())),
  };
}

class SysAgencyDashboard {
  int? id;
  String enName;
  String arName;
  String iconSvg;
  String? startDate;
  String? endDate;
  String accessTo;
  int status;
  int orderBy;

  SysAgencyDashboard({
    required this.id,
    required this.enName,
    required this.arName,
    required this.iconSvg,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.accessTo,
    required this.orderBy,
  });

  factory SysAgencyDashboard.fromJson(Map<String, dynamic> json) =>
      SysAgencyDashboard(
        id: json["id"] ?? 0,
        enName: json["en_name"].toString(),
        arName: json["ar_name"].toString(),
        iconSvg: json["icon_svg"].toString(),
        startDate: json["start_date"].toString(),
        endDate: json["end_date"].toString(),
        status: json["status"],
        accessTo: json["access_to"].toString(),
        orderBy: json['order_by'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "ar_name": arName,
        "icon_svg": iconSvg,
        "start_date": startDate,
        "end_date": endDate,
        "status": status,
        "access_to": accessTo,
        "order_by": orderBy,
      };
}

class Sys {
  int id;
  String enName;
  String? arName;
  int? clientId;
  int? status;

  Sys({
    required this.id,
    required this.enName,
    required this.arName,
    this.clientId,
    this.status,
  });

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
        id: json["id"],
        enName: json["en_name"].toString(),
        arName: json["ar_name"].toString(),
        clientId: json["client_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "ar_name": arName,
        "client_id": clientId,
        "status": status,
      };
}

class CategoryResModel {
  int id;
  String enName;
  String? arName;
  int? clientId;
  // int? status;

  CategoryResModel({
    required this.id,
    required this.enName,
    required this.arName,
    this.clientId,
    // this.status,
  });

  factory CategoryResModel.fromJson(Map<String, dynamic> json) =>
      CategoryResModel(
        id: json["id"],
        enName: json["en_name"].toString(),
        arName: json["ar_name"].toString(),
        clientId: json["client_id"],
        // status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "ar_name": arName,
        "client_id": clientId,
        // "status": status,
      };
}

class SysClient {
  int clientId;
  String clientName;
  String logo;
  String? isClassification;
  String? isChainSkuCodes;
  String? isDayFreshness;
  String? isGeoRequired;
  String? isSuggetedOrderAvl;
  String? isSurvey;

  SysClient({
    required this.clientId,
    required this.clientName,
    required this.logo,
    required this.isClassification,
    required this.isChainSkuCodes,
    required this.isDayFreshness,
    required this.isGeoRequired,
    required this.isSuggetedOrderAvl,
    required this.isSurvey,
  });

  factory SysClient.fromJson(Map<String, dynamic> json) => SysClient(
        clientId: json["client_id"],
        clientName: json["client_name"].toString(),
        logo: json["logo"].toString(),
        isClassification: json["is_classification"].toString(),
        isChainSkuCodes: json["is_chain_sku_codes"].toString(),
        isDayFreshness: json["is_day_freshness"].toString(),
        isGeoRequired: json["is_geo_required"].toString(),
        isSuggetedOrderAvl: json["is_suggeted_order_avl"].toString(),
        isSurvey: json["is_survey"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_name": clientName,
        "logo": logo,
        "is_classification": isClassification,
        "is_chain_sku_codes": isChainSkuCodes,
        "is_day_freshness": isDayFreshness,
        "is_geo_required": isGeoRequired,
        "is_suggeted_order_avl": isSuggetedOrderAvl,
        "is_survey": isSurvey,
      };
}
