import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({super.key,required this.userName});

  final Function userName;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          focusColor: MyColors.appMainColor,
          hintText: "username",
          filled: true,
          fillColor:MyColors.dropBorderColor,
          border: OutlineInputBorder()),
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
