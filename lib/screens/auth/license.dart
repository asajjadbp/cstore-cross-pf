import 'package:cstore/Network/http_manager.dart';
import 'package:cstore/screens/auth/login.dart';
import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class LicenseKey extends StatefulWidget {
  const LicenseKey({super.key});

  @override
  State<LicenseKey> createState() => _LicenseKeyState();
}

class _LicenseKeyState extends State<LicenseKey> {
  var licensekey = "";
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // print(licensekey);
    setState(() {
      isLoading = true;
    });
    await HTTPMANAGER().getLicense(licensekey).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status) {
        Navigator.of(context).pushReplacementNamed(Login.routeName);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                top: screenHeight * 0.1,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/logo2.png",
                        height: 150,
                        width: 150,
                      )
                      // CircleAvatar(
                      //   radius: 50,
                      //   backgroundColor: Colors.white,
                      //   backgroundImage: AssetImage("assets/images/logo2.png"),
                      // )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.32,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        // topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          const Text(
                            "License Key",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          // const SizedBox(
                          //   height: 6,
                          // ),
                          // const Text(
                          //   "Login with your credentials",
                          //   style: TextStyle(fontSize: 15),
                          // ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Column(
                            children: [
                              // SizedBox(
                              //   child: TextFormField(
                              //     textInputAction: TextInputAction.next,
                              //     decoration: const InputDecoration(
                              //         prefixIcon: Icon(Icons.person),
                              //         hintText: "username",
                              //         filled: true,
                              //         fillColor:
                              //             Color.fromARGB(255, 223, 218, 218),
                              //         border: InputBorder.none),
                              //     validator: (value) {
                              //       if (value!.isEmpty) {
                              //         return "Please enter your username";
                              //       }
                              //       return null;
                              //     },
                              //     onSaved: (newValue) {},
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              SizedBox(
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    // obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    initialValue: "BZ786",
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
                                      licensekey = newValue.toString();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color.fromRGBO(0, 77, 145, 1),
                                        minimumSize: Size(screenWidth, 45),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                      ),
                                      onPressed: submitForm,
                                      child: const Text(
                                        "Submit",
                                        style: TextStyle(),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
