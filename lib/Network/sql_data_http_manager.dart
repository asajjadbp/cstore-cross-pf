

import 'dart:convert';

import 'package:cstore/Model/request_model.dart/jp_request_model.dart';
import 'package:cstore/Model/request_model.dart/other_images_end_Api_request.dart';
import 'package:cstore/Model/request_model.dart/save_db_file_request.dart';
import 'package:cstore/Network/response_handler.dart';

import '../Model/database_model/picklist_model.dart';
import '../Model/request_model.dart/assign_special_vsit.dart';
import '../Model/request_model.dart/availability_api_request_model.dart';
import '../Model/request_model.dart/brand_share_request.dart';
import '../Model/request_model.dart/get_tmr_pick_list_request.dart';
import '../Model/request_model.dart/osd_end_api_request_model.dart';
import '../Model/request_model.dart/planogram_end_api_request_model.dart';
import '../Model/request_model.dart/planoguide_request_model.dart';
import '../Model/request_model.dart/ready_pick_list_request.dart';
import '../Model/request_model.dart/save_api_pricing_data_request.dart';
import '../Model/request_model.dart/save_api_rtv_data_request.dart';
import '../Model/request_model.dart/save_freshness_request_model.dart';
import '../Model/request_model.dart/save_market_issue_request.dart';
import '../Model/request_model.dart/save_one_plus_one_request.dart';
import '../Model/request_model.dart/save_osd_request.dart';
import '../Model/request_model.dart/save_pos_request.dart';
import '../Model/request_model.dart/save_promo_plan_request_model.dart';
import '../Model/request_model.dart/save_replenishment_request.dart';
import '../Model/request_model.dart/save_stock_request_model.dart';
import '../Model/request_model.dart/sos_end_api_request_model.dart';
import '../Model/request_model.dart/survey_end_api_request.dart';
import '../Model/response_model.dart/tmr_pick_list_response_model.dart';
import 'api.dart';

class SqlHttpManager {
  final ResponseHandler _handler = ResponseHandler();

  Future<dynamic> saveBeforeFixingAndOtherPhotoTrans(String token, String baseUrl,SaveOtherPhoto saveOtherPhoto) async {
    final url = baseUrl + Api.sqlOtherPhotoTableSaving;
    print(url);
    print(jsonEncode(saveOtherPhoto));
    var response = await _handler.postWithJson(Uri.parse(url), saveOtherPhoto.toJson(), token);

    return response;
  }

  Future<dynamic> savePlanogramTrans(String token, String baseUrl,SavePlanogramPhoto savePlanogramPhoto) async {
    final url = baseUrl + Api.sqlPlanogramTableSaving;
    print(url);
    print(jsonEncode(savePlanogramPhoto));
    var response = await _handler.postWithJson(Uri.parse(url), savePlanogramPhoto.toJson(), token);

    return response;
  }

  Future<dynamic> saveSosTrans(String token, String baseUrl,SaveSosPhoto saveSosPhoto) async {
    final url = baseUrl + Api.sqlSosTableSaving;
    print(url);
    print(jsonEncode(saveSosPhoto));
    var response = await _handler.postWithJson(Uri.parse(url), saveSosPhoto.toJson(), token);

    return response;
  }

  Future<dynamic> saveOsdTrans(String token, String baseUrl,SaveOsdPhoto saveOsdPhoto) async {
    final url = baseUrl + Api.sqlOsdcTableSaving;
    print(url);
    print(jsonEncode(saveOsdPhoto));
    var response = await _handler.postWithJson(Uri.parse(url), saveOsdPhoto.toJson(), token);

    return response;
  }

  Future<bool> saveAvailabilityTrans(String token, String baseUrl,SaveAvailability saveAvailability) async {
    final url = baseUrl + Api.sqlAvailabilityTableSaving;
    print(url);
    print(jsonEncode(saveAvailability));
    var response = await _handler.postWithJson(Uri.parse(url), saveAvailability.toJson(), token);

    return true;
  }

  Future<bool> savePickListTrans(String token, String baseUrl,SavePickList savePickList) async {
    final url = baseUrl + Api.sqlPickListTableSaving;
    print(url);
    print(jsonEncode(savePickList));
    var response = await _handler.postWithJson(Uri.parse(url), savePickList.toJson(), token);

    return true;
  }

  Future<dynamic> savePlanoguide(String token, String baseUrl,SavePlanoguide savePlanoguide) async {
    final url = baseUrl + Api.sqlPlanoguideSaving;
    print(url);
    print(jsonEncode(savePlanoguide));
    var response = await _handler.postWithJson(Uri.parse(url), savePlanoguide.toJson(), token);

    return response;
  }

  Future<dynamic> saveBrandShare(String token, String baseUrl,SaveBrandShare saveBrandShare) async {
    final url = baseUrl + Api.sqlBrandShareSaving;
    print(url);
    print(jsonEncode(saveBrandShare));
    var response = await _handler.postWithJson(Uri.parse(url), saveBrandShare.toJson(), token);

    return response;
  }

  Future<dynamic> readyPickList(String token, String baseUrl,ReadyPickList readyPickList) async {
    final url = baseUrl + Api.makePickListReady;
    print(url);
    print(jsonEncode(readyPickList));
    var response = await _handler.postWithJson(Uri.parse(url), readyPickList.toJson(), token);

    return response;
  }

  Future<List<PickListModel>> getPickerPickList(String token, String baseUrl,JourneyPlanRequestModel journeyPlanRequestModel) async {
    final url = baseUrl + Api.getStockerPickList;
    print(url);
    print(jsonEncode(journeyPlanRequestModel));
    var response = await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson(), token);
    List pickList = response['data'];
    return List.generate(pickList.length, (index) {
      // print(transphoto[index]['id']);
      print(pickList[index]);
      return PickListModel(
        picklist_id: pickList[index]['picklist_id'].toString(),
        store_id: pickList[index]['store_id'].toString(),
        category_id: pickList[index]['category_id'].toString(),
        tmr_id: pickList[index]['tmr_id'].toString(),
        tmr_name: pickList[index]['tmr_name'].toString(),
        stocker_id: pickList[index]['stocker_id'].toString(),
        stocker_name: pickList[index]['stocker_name'].toString(),
        shift_time: pickList[index]['shift_time'].toString(),
        en_cat_name: pickList[index]['en_cat_name'].toString(),
        ar_cat_name: pickList[index]['ar_cat_name'].toString(),
        sku_picture: pickList[index]['sku_picture'].toString(),
        en_sku_name: pickList[index]['en_sku_name'].toString(),
        ar_sku_name: pickList[index]['ar_sku_name'].toString(),
        req_pickList: pickList[index]['req_picklist'].toString(),
        act_pickList: pickList[index]['act_picklist'].toString(),
        pickList_ready: pickList[index]['picklist_ready'].toString(),
        upload_status: pickList[index]['upload_status']??0,
        pick_list_send_time: pickList[index]['pick_list_send_time'] ?? "",
        pick_list_receive_time: pickList[index]['tmr_send_time'] ?? "",
        isReasonShow: true,
        reasonValue: [],
        pick_list_reason: pickList[index]['picklist_reason'] ?? ""
      );
    });
  }

  Future<TmrPickListResponseModel> getTmrPickList(String token, String baseUrl,TmrPickListRequestModel tmrPickListRequestModel) async {
    final url = baseUrl + Api.getTmrActualPickList;
    print(url);
    print(jsonEncode(tmrPickListRequestModel));
    var response = await _handler.post(Uri.parse(url), tmrPickListRequestModel.toJson(), token);
    TmrPickListResponseModel tmrPickListResponseModel = TmrPickListResponseModel.fromJson(response);
    return tmrPickListResponseModel;
  }

  Future<dynamic> saveRtvList(String token, String baseUrl,SaveRtvData saveRtvData) async {
    final url = baseUrl + Api.uploadRtvData;
    print(url);
    print(jsonEncode(saveRtvData));
    var response = await _handler.postWithJson(Uri.parse(url), saveRtvData.toJson(), token);
     return response;
  }

  Future<dynamic> savePricing(String token, String baseUrl,SavePricingData savePricingData) async {
    final url = baseUrl + Api.uploadPricingData;
    print(url);
    print(jsonEncode(savePricingData));
    var response = await _handler.postWithJson(Uri.parse(url), savePricingData.toJson(), token);
    return response;
  }

  Future<dynamic> saveFreshness(String token, String baseUrl,SaveFreshnessData saveFreshnessData) async {
    final url = baseUrl + Api.postFreshnessData;
    print(url);
    print(jsonEncode(saveFreshnessData));
    var response = await _handler.postWithJson(Uri.parse(url), saveFreshnessData.toJson(), token);
    return response;
  }

  Future<dynamic> savePromoPlan(String token, String baseUrl,SavePromoPlanData savePromoPlanData) async {
    final url = baseUrl + Api.postPromoPlanData;
    print(url);
    print(jsonEncode(savePromoPlanData));
    var response = await _handler.postWithJson(Uri.parse(url), savePromoPlanData.toJson(), token);
    return response;
  }

  Future<dynamic> saveStock(String token, String baseUrl,SaveStockData saveStockData) async {
    final url = baseUrl + Api.postStockData;
    print(url);
    print(jsonEncode(saveStockData));
    var response = await _handler.postWithJson(Uri.parse(url), saveStockData.toJson(), token);
    return response;
  }

  Future<dynamic> savePos(String token, String baseUrl,SavePosData savePosData) async {
    final url = baseUrl + Api.postPosData;
    print(url);
    print(jsonEncode(savePosData));
    var response = await _handler.postWithJson(Uri.parse(url), savePosData.toJson(), token);
    return response;
  }

  Future<dynamic> saveOnePlusOne(String token, String baseUrl,SaveOnePlusOneData saveOnePlusOneData) async {
    final url = baseUrl + Api.postOnePlusOneData;
    print(url);
    print(jsonEncode(saveOnePlusOneData));
    var response = await _handler.postWithJson(Uri.parse(url), saveOnePlusOneData.toJson(), token);
    return response;
  }

  Future<dynamic> saveMarketIssue(String token, String baseUrl,SaveMarketIssueData saveMarketIssueData) async {
    final url = baseUrl + Api.postMarketIssueData;
    print(url);
    print(jsonEncode(saveMarketIssueData));
    var response = await _handler.postWithJson(Uri.parse(url), saveMarketIssueData.toJson(), token);
    return response;
  }

  Future<dynamic> saveReplenishData(String token, String baseUrl,SaveReplenishData saveReplenishData) async {
    final url = baseUrl + Api.postReplenishData;
    print(url);
    print(jsonEncode(saveReplenishData));
    var response = await _handler.postWithJson(Uri.parse(url), saveReplenishData.toJson(), token);
    return response;
  }

  Future<dynamic> saveOsd(String token, String baseUrl,SaveOsdData saveOsdData) async {
    final url = baseUrl + Api.postOSDData;
    print(url);
    print(jsonEncode(saveOsdData));
    var response = await _handler.postWithJson(Uri.parse(url), saveOsdData.toJson(), token);
    return response;
  }

  Future<dynamic> saveDbFile(String token, String baseUrl,SaveDbFileRequest saveDbFileRequest) async {
    final url = baseUrl + Api.saveUserDbData;
    print(url);
    print(jsonEncode(saveDbFileRequest));
    var response = await _handler.post(Uri.parse(url), saveDbFileRequest.toJson(), token);
    return response;
  }


  Future<dynamic> assignUniverseStores(String token, String baseUrl,AssignSpecialVisitRequest assignSpecialVisitRequest) async {
    final url = baseUrl + Api.assignSpecialVisit;
    print(url);
    print(jsonEncode(assignSpecialVisitRequest));
    var response = await _handler.post(Uri.parse(url), assignSpecialVisitRequest.toJson(), token);
    return response;
  }

  Future<dynamic> saveSurvey(String token, String baseUrl,SaveSurvey saveSurvey) async {
    final url = baseUrl + Api.postSurveyData;
    print(url);
    print(jsonEncode(saveSurvey));
    var response = await _handler.postWithJson(Uri.parse(url), saveSurvey.toJson(), token);

    return response;
  }


}