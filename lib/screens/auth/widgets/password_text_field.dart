import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key,required this.password});

  final Function password;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          hintText: "password",
          filled: true,
          fillColor:MyColors.dropBorderColor,
          border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      onSaved: (newValue) {
        password(newValue);
      },
    );
  }
}
