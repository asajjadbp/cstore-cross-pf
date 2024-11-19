import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class ToastMessage {
  static void errorMessage(BuildContext context, String errMessage) {
    MotionToast.error(
      toastDuration: const Duration(seconds: 2),
      title: Text("Error!".tr),
      position: MotionToastPosition.top,
      description: Text(errMessage),
    ).show(context);
  }

  static void succesMessage(BuildContext context, String succMessage) {
    MotionToast.success(
      toastDuration: const Duration(seconds: 2),
      title: Text("Success".tr),
      position: MotionToastPosition.top,
      description: Text(succMessage),
    ).show(context);
  }
}

showAnimatedToastMessage(String title,String message, bool isSuccess) {
  Get.snackbar(
    titleText: Text(title.tr,style:  const TextStyle(color: MyColors.whiteColor),),
    messageText: Text(message.tr,style:  const TextStyle(color: MyColors.whiteColor),),
    title.tr,message.tr,
    snackPosition: SnackPosition.TOP,
    backgroundColor: MyColors.whiteColor,
    backgroundGradient: isSuccess ? const LinearGradient(colors: [
      MyColors.greenColor,
      MyColors.greenColor
    ]) : const LinearGradient(
        colors: [
          MyColors.backbtnColor,
          MyColors.backbtnColor
        ]),
    borderRadius: 10,
    margin: const EdgeInsets.all(15),
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    snackStyle: SnackStyle.FLOATING,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
