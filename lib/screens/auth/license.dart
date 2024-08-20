
import 'package:cstore/Network/license_http_manager.dart';
import 'package:cstore/model/response_model.dart/license_response.dart';
import 'package:cstore/screens/auth/login.dart';
import 'package:cstore/screens/auth/widgets/license_key_text_field.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/appcolor.dart';
import '../widget/elevated_buttons.dart';


class LicenseKey extends StatefulWidget {
 static const routeName = "/RouteSplashScreen";
  const LicenseKey({super.key});

  @override
  State<LicenseKey> createState() => _LicenseKeyState();
}

class _LicenseKeyState extends State<LicenseKey> {
  var licensekey = "";
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

 late LicenseResponseModel licenseResponseData;

  Future<void> submitForm() async {
    SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    await LICENSEHTTPMANAGER().getLicense(licensekey).then((value) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        licenseResponseData = value;
      });

      sharedPreferences.setInt(AppConstants.licenseId, licenseResponseData.data[0].id);
      sharedPreferences.setString(AppConstants.licenseKey, licenseResponseData.data[0].licenseKey.toString());
      sharedPreferences.setString(AppConstants.licenseAgency, licenseResponseData.data[0].agency.toString());
      sharedPreferences.setString(AppConstants.bucketName, licenseResponseData.data[0].bucketName.toString());
      sharedPreferences.setString(AppConstants.baseUrl, licenseResponseData.data[0].baseUrl.toString());
      sharedPreferences.setString(AppConstants.imageBaseUrl, licenseResponseData.data[0].imageReadUrl.toString());
      sharedPreferences.setString(AppConstants.agencyPhoto, licenseResponseData.data[0].agencyPhoto.toString());

      if (value.status) {
        Navigator.of(context).pushReplacementNamed(Login.routeName);
      } else {
        ToastMessage.errorMessage(context, value.msg);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.whiteColor,
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
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Column(
                            children: [

                              Form(
                                key: _formKey,
                                child : LicenseKeyTextField(licenseKey: (value) {
                                  licensekey = value.toString();
                                })
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              isLoading
                                  ? const SizedBox(
                                      height: 60, child: MyLoadingCircle())
                                  : BigElevatedButton(
                                  isBlueColor: true,
                                  buttonName:  "Submit",
                                  submit: submitForm)
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
