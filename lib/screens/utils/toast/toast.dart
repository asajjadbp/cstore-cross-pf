import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class ToastMessage {
  static void errorMessage(BuildContext context, String errMessage) {
    MotionToast.error(
      title: Text("Error!".tr),
      position: MotionToastPosition.top,
      description: Text(errMessage),
    ).show(context);
  }

  static void succesMessage(BuildContext context, String succMessage) {
    MotionToast.success(
      title: Text("Success".tr),
      position: MotionToastPosition.top,
      description: Text(succMessage),
    ).show(context);
  }
}

showAnimatedToastMessage(String title,String message, bool isSuccess) {
  Get.snackbar(
    titleText: Text(title,style:  const TextStyle(color: MyColors.whiteColor),),
    messageText: Text(message,style:  const TextStyle(color: MyColors.whiteColor),),
    title,message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: MyColors.whiteColor,
    backgroundGradient: isSuccess ? const LinearGradient(colors: [
      MyColors.appMainColor,
      MyColors.appMainColor
    ]) : const LinearGradient(
        colors: [
          MyColors.backbtnColor,
          MyColors.backbtnColor
        ]),
    borderRadius: 10,
    margin: const EdgeInsets.all(15),
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
    snackStyle: SnackStyle.FLOATING,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
