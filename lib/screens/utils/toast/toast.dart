import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class ToastMessage {
  static void errorMessage(BuildContext context, String errMessage) {
    MotionToast.error(
      title: const Text("Error"),
      position: MotionToastPosition.top,
      description: Text(errMessage),
    ).show(context);
  }

  static void succesMessage(BuildContext context, String succMessage) {
    MotionToast.success(
      title: const Text("Success"),
      position: MotionToastPosition.top,
      description: Text(succMessage),
    ).show(context);
  }
}
