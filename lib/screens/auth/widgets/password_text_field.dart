import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appcolor.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key,required this.password});

  final Function password;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration:  InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: "Password".tr,
          filled: true,
          fillColor:MyColors.dropBorderColor,
          border: const OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your password".tr;
        }
        return null;
      },
      onSaved: (newValue) {
        password(newValue);
      },
    );
  }
}
