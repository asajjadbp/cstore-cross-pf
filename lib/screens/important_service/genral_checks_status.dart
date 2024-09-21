import 'dart:async';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/utils/services/geo_fencing_caculation.dart';
import 'package:cstore/screens/utils/services/getting_gps.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

import '../../Model/database_model/app_setting_model.dart';
import '../utils/app_constants.dart';

class GeneralChecksStatusController extends GetxController {

  late SysAppSettingModel sysAppSettingModel;
  RxBool isMockLocation = false.obs;
  RxBool isVpnStatus = false.obs;
  RxBool isAutoTimeStatus = true.obs;
  RxDouble isGeoFenceDistance = 0.0.obs;
  RxBool isLocationStatus = true.obs;
  RxBool isGeoLocation = true.obs;
  RxString isLat = "".obs;
  RxString isLong = "".obs;
  RxString isLatLong = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit

    checkLicenseKey();

    super.onInit();
  }

  checkLicenseKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.containsKey(AppConstants.baseUrl)) {
      getAppSetting();
    }
  }

  getAppSetting() async {
    try {
    await DatabaseHelper.getTransSysAppSetting().then((value) async {
      sysAppSettingModel = value;

     await checkAppServiceSetup();
    }); } catch (e) {
      print("Error in getAppSetting: $e");
    }
  }

 Future<bool> checkAppServiceSetup() async {

    if(sysAppSettingModel.isAutoTimeEnabled == "0") {
       isAutoTimeStatus.value = true;
    } else {
      await getAutoTimeEnableStatus();
    }

    if(sysAppSettingModel.isVpnEnabled == "0") {
      isVpnStatus.value = false;
    } else {
      await checkVpnStatus();
    }

    if(sysAppSettingModel.isFakeLocationEnabled == "0") {
      isMockLocation.value = false;
    } else {
        await checkFakeLocation();
    }

    if(sysAppSettingModel.isGeoLocationEnabled == "0") {
      isGeoLocation.value = true;
    } else {
      isGeoLocation.value = false;
    }

    if(sysAppSettingModel.isLocationEnabled == "0") {
      isLocationStatus.value = true;
    } else {
      await getLocationEnableStatus();
    }


    print("AUTO TIME STATUS");
    print(isAutoTimeStatus.value);
    print("VPN STATUS");
    print(isVpnStatus.value);
    print("Mock Location");
    print(isMockLocation.value);
    print("Location Permission");
    print(isLocationStatus.value);



    return true;

  }


  Future<bool> getLocationEnableStatus() async {

   await LocationService.getLocation().then((value) => {
      isLocationStatus.value = value['locationIsPicked'],

    if(isLocationStatus.value) {
      isLat.value = value['lat'],
      isLong.value = value['long'],
      isLatLong.value = value['lat'] +","+ value['long'],

    }
    });

    return true;
  }

  getGeoLocationDistance(double startLat,double startLong,double storeLat,double storeLong) async {

    isGeoFenceDistance.value = calculateDistance(startLat, startLong, storeLat, storeLong);
  }

  Future<void> getAutoTimeEnableStatus() async {
    final bool? status = await AutoTimeEnable.getAutoTimeEnableStatus();

    isAutoTimeStatus.value = status!;

  }

  checkVpnStatus() async {
    isVpnStatus.value  = await vpnDetector();

  }


  Future<bool> vpnDetector() async {
    bool isConnected = await VpnConnectionDetector.isVpnActive();
    return isConnected;
  }

  Future<bool> checkFakeLocation() async {
    isMockLocation.value = await DetectFakeLocation().detectFakeLocation();

    return isMockLocation.value;
  }

}

class AutoTimeEnable {
  static const platform = MethodChannel('auto_time_enable');

  static Future<bool?> getAutoTimeEnableStatus() async {
    final bool? status = await platform.invokeMethod('getAutoTimeEnableStatus');
    return status;
  }
}