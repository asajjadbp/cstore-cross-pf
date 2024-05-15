import 'dart:convert';
import 'dart:io';

import 'package:cstore/Model/response_model.dart/jp_response_model.dart';
import 'package:cstore/Network/getUserData/base_url_and_user.dart';
import 'package:cstore/Network/jp_http.dart';
import 'package:cstore/screens/Journey%20Plan/journey_plan.dart';
import 'package:cstore/screens/Journey%20Plan/view_jp_photo.dart';
import 'package:cstore/screens/utils/services/image_picker.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JourneyPlanScreen extends StatefulWidget {
  static const routename = "/journeyPlanScreen";
  const JourneyPlanScreen({super.key});

  @override
  State<JourneyPlanScreen> createState() => _JourneyPlanScreenState();
}

class _JourneyPlanScreenState extends State<JourneyPlanScreen> {
  File? _pickedImage;
  var userName = "";
  var token = "";
  bool isLoading = false;
  bool isDropLoading = false;
  // This id is taking to recognize that card and start reloading
  var dropWorkingId = "";
  List<JourneyPlanDetail> jpData = [];

  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    final baseUrl =
        json.decode(prefs.getString('userLicense')!) as Map<String, dynamic>;
    userName = extractedUserData["data"][0]["username"].toString();
    token = extractedUserData["data"][0]["token_id"].toString();
    // extractedUserData["data"]["username"].toString()
    print(userName);
    print(extractedUserData["data"][0]["token_id"]);
    // print(baseUrl["data"][0]["base_url"]);
    // extractedUserData["data"]["token_id"].toString()
    callJp();
  }

  Future callJp() async {
    setState(() {
      isLoading = true;
    });
    try {
      await JourneyPlanHTTP().getJourneyPlan(userName, token).then((value) {
        setState(() {
          isLoading = false;
        });

        if (value.status) {
          jpData = value.data;
        }
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Pool"),
      ),
      body: isLoading
          ? const Center(
              child: MyLoadingCircle(),
            )
          : jpData.isEmpty
              ? const Center(
                  child: Text("No journey plan found"),
                )
              : ListView.builder(
                  itemCount: jpData.length,
                  itemBuilder: (ctx, i) {
                    return JourneyPlan(
                      jp: jpData[i],
                      takeImageFtn: getImage,
                      dropFtn: dropVisit,
                      undropFtn: undropVisit,
                      isDropLoading: isDropLoading,
                      workingId: dropWorkingId,
                    );
                  }),
    );
  }

  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        ToastMessage.errorMessage(context, "No Image Picked");
        return;
      }
      // _pickedImage = value;
      Navigator.of(context)
          .pushNamed(ViewJPPhoto.routename, arguments: {"image": value});
    });
  }

  Future<void> dropVisit(String workingId) async {
    setState(() {
      isDropLoading = true;
    });
    await JourneyPlanHTTP()
        .dropVisit(userName, workingId, "3", token)
        .then((value) {
      callJp();
      setState(() {
        isDropLoading = false;
        dropWorkingId = workingId;
      });
      if (value.status) {
        ToastMessage.succesMessage(context, value.msg);
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

  void undropVisit(String workingId) async {
    setState(() {
      isDropLoading = true;
      isLoading = true;
      dropWorkingId = "";
    });
    await JourneyPlanHTTP()
        .unDropVisit(userName, workingId, token)
        .then((value) {
      callJp();
      setState(() {
        isDropLoading = false;
      });
      if (value.status) {
        ToastMessage.succesMessage(context, value.msg);
      } else {
        ToastMessage.errorMessage(context, value.msg);
      }
    }).catchError((onError) {
      setState(() {
        isDropLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
    });
  }
}
