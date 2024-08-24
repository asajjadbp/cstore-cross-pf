import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appcolor.dart';

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({super.key,required this.userName});

  final Function userName;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration:  InputDecoration(
          prefixIcon:const Icon(Icons.person),
          focusColor: MyColors.appMainColor,
          hintText: "Username".tr,
          filled: true,
          fillColor:MyColors.dropBorderColor,
          border:const OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your username";
        }
        return null;
      },
      onSaved: (newValue) {
        userName(newValue);
      },
    );
  }
}
