import 'dart:convert';

import 'package:cstore/Model/response_model.dart/syncronise_response_model.dart';
import 'package:cstore/Network/syncronise_http.dart';
import 'package:cstore/database/db_helper.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/response_model.dart/syncronise_response_model.dart';

class WelcomeScreen extends StatefulWidget {
  static const routename = "/welcome_route";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;
  var userName = "";
  var token = "";

  List<SyncroniseDetail> syncroniseData = [];

  bool isinit = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isinit) {
      getUserData();
    }
    isinit = false;
  }

  @override
  // void initState() async {
  //   // TODO: implement initState
  //   super.initState();
  //   await getUserData();
  // }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    final baseUrl =
        json.decode(prefs.getString('userLicense')!) as Map<String, dynamic>;
    // var user = GetUserDataAndUrl().getUserData.toString();
    userName = extractedUserData["data"][0]["username"].toString();
    token = extractedUserData["data"][0]["token_id"].toString();
    // extractedUserData["data"]["username"].toString()
    print(userName);
    print(extractedUserData["data"][0]["token_id"]);
    // print(baseUrl["data"][0]["base_url"]);
    // extractedUserData["data"]["token_id"].toString()
    await getSyncronise();
  }

  Future<void> getSyncronise() async {
    setState(() {
      isLoading = true;
    });
    // try {
    await SyncroniseHTTP().fetchSyncroniseData(userName, token).then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.status) {
        syncroniseData = value.data;
      }
    });
    // } catch (error) {
    setState(() {
      isLoading = false;
    });
    // ToastMessage.errorMessage(context, error.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset("assets/images/brandlogo.png"),
            const SizedBox(
              height: 50,
            ),
            const Text(
                "BrandPartners is a leading Merchandising, Brand Activation, and FieldForce Management company founded in 2006 in Saudi Arabia aiming to utilize best-in-class processes and technology along with solid human competencies to successfully deliver your brand execution pillars."),
            const SizedBox(
              height: 100,
            ),
            isLoading
                ? Center(
                    child:
                        Container(height: 60, child: const MyLoadingCircle()),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
                      minimumSize: Size(screenWidth, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(DashBoard.routeName);
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
