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
