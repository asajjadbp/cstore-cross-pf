import 'package:get/get.dart';

import '../../important_service/genral_checks_status.dart';

Future <GeneralChecksStatusController> generalControllerInitialization() async {
  GeneralChecksStatusController generalStatusController;
  generalStatusController = Get.put(GeneralChecksStatusController());

  await generalStatusController.getAppSetting();

  return generalStatusController;
}