import 'package:flutter/material.dart';

class LicenseKeyTextField extends StatelessWidget {
  const LicenseKeyTextField({super.key,required this.licenseKey});

  final Function licenseKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.key),
          hintText: "Key",
          filled: true,
          fillColor:
          Color.fromARGB(255, 223, 218, 218),
          border: InputBorder.none),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your license key";
        }
        return null;
      },
      onSaved: (newValue) {
        licenseKey(newValue);
      },
    );
  }
}
