import 'dart:convert';


import 'package:cstore/screens/auth/widgets/password_text_field.dart';
import 'package:cstore/screens/auth/widgets/user_name_text_field.dart';
import 'package:cstore/screens/widget/elevated_buttons.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Language/localization_controller.dart';
import 'package:upgrader/upgrader.dart';
import '../utils/appcolor.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  static const routeName = "/loginRoute";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final languageController = Get.put(LocalizationController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return UpgradeAlert(
      upgrader: Upgrader(
        canDismissDialog: false,
        showLater: false,
        showIgnore: false,
        showReleaseNotes: true,
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: MyColors.appMainColor,
            child: Text('lang'.tr),
            onPressed: () {
              languageController.changeLanguage();
                  setState(() {
                  });
        }),
        body: Obx(() => SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                left: 0,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.99,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Form(
                      key: loginController.formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Center(
                            child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.asset("assets/images/logo.png")),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Align(
                                alignment:languageController.languageCheck() ? Alignment.topLeft : Alignment.topRight ,
                                child: Text(
                                  'LOGIN'.tr,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              )),

                          Container(
                              margin:const EdgeInsets.symmetric(horizontal: 5,vertical: 6),
                              child:  Align(
                                alignment: languageController.languageCheck() ? Alignment.topLeft : Alignment.topRight ,
                                child: Text(
                                  'Please Login to continue'.tr,
                                  style:const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,

                                  ),
                                ),
                              )),
                          Column(
                            children: [
                              UserNameTextField(userName: (value) {
                                loginController.userName = value.toString();
                              }),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: PasswordTextField(password: (value) {
                                  loginController.password = value.toString();
                                }),
                              ),
                              loginController.isLoading.value
                                  ? const Center(
                                  child: SizedBox(
                                      height: 60, child: MyLoadingCircle()))
                                  :  BigElevatedButton(
                                  isBlueColor: true,
                                  buttonName:  "Login".tr,
                                  submit: loginController.submitForm)
                            ],
                          ),

                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      child: SvgPicture.network(loginController.agencyPhoto)),

                                  Container(
                                    margin:const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(loginController.agencyName),),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Text("Version: ${loginController.currentVersion}",style: const TextStyle(color: MyColors.appMainColor),),)
                                ],
                              )),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),)
      ),
    );
  }
}
