import 'dart:convert';
import 'dart:io';
import 'package:cstore/screens/grid_dashboard/grid_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/Network/jp_http.dart';
import '../utils/services/getting_gps.dart';
import '/screens/utils/toast/toast.dart';
import '/screens/widget/loading.dart';
import '/screens/widget/two_buttons_in_row.dart';

import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewJPPhoto extends StatefulWidget {
  static const routename = "/view_startJp_image";
  const ViewJPPhoto({super.key});

  @override
  State<ViewJPPhoto> createState() => _ViewJPPhotoState();
}

class _ViewJPPhotoState extends State<ViewJPPhoto> {
  var commentText = TextEditingController();
  bool isLoading = false;
  var userName = "";
  var token = "";
  var baseUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void submitStartVist(String workingId, String storeImage, String lat,
      String long, String clientId) async {
    await JourneyPlanHTTP()
        .startVisit(userName, workingId, storeImage, lat, long, clientId,
            commentText.text, token, baseUrl)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status) {
        ToastMessage.succesMessage(context, value.msg);
        Navigator.of(context).pushNamed(GridDashBoard.routeName);
      } else {
        ToastMessage.errorMessage(context, value.msg);
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, error.toString());
    });

    // print(commentText.text);
    // await LocationService.getLocation().then((value) {
    //   if (value["locationIsPicked"]) {

    //     JourneyPlanHTTP().startVisit(userName, workingId, storeImage,
    //         value["lat"], value["long"], "1,3,2", commentText.text, token);

    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     ToastMessage.errorMessage(context, value["msg"]);
    //   }
    // });
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userCred')!) as Map<String, dynamic>;
    final urlData =
        json.decode(prefs.getString('userLicense')!) as Map<String, dynamic>;
    // var user = GetUserDataAndUrl().getUserData.toString();
    userName = extractedUserData["data"][0]["username"].toString();
    token = extractedUserData["data"][0]["token_id"].toString();
    // extractedUserData["data"]["username"].toString()
    print(userName);
    print(extractedUserData["data"][0]["token_id"]);
    // print(baseUrl["data"][0]["base_url"]);
    baseUrl = urlData["data"][0]["base_url"];
    // extractedUserData["data"]["token_id"].toString()
  }

  void uploadImageToCloud(
      File imageFile, String workingId, String clientId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await LocationService.getLocation().then((value) async {
        if (value["locationIsPicked"]) {
          final credentials = ServiceAccountCredentials.fromJson(
            await rootBundle.loadString(
                'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
          );

          final httpClient = await clientViaServiceAccount(
              credentials, [StorageApi.devstorageReadWriteScope]);

          // Create a Storage client with the credentials
          final storage = StorageApi(httpClient);

          // Generate a unique filename and path
          final filename =
              '${userName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          const bucketName =
              "catalisttest-bucket"; // Replace with your bucket name
          final filePath = 'visits/$filename';

          final fileContent = await imageFile.readAsBytes();
          final bucketObject = Object(name: filePath);

          // Upload the image
          final resp = await storage.objects.insert(
            bucketObject,
            bucketName,
            predefinedAcl: 'publicRead',
            uploadMedia: Media(
              Stream<List<int>>.fromIterable([fileContent]),
              fileContent.length,
            ),
          );
          final downloadUrl =
              'https://storage.googleapis.com/$bucketName/$filePath';
          print(downloadUrl);
          submitStartVist(
              workingId, filename, value['lat'], value['long'], clientId);
        } else {
          setState(() {
            isLoading = false;
          });
          ToastMessage.errorMessage(context, value["msg"]);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any errors that occur during the upload
      print("Upload GCS Error $e");
      ToastMessage.errorMessage(context, e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("carrefour - 336"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: screenHeight * 0.3,
                    width: screenWidth,
                    child: Card(
                      elevation: 3,
                      child: Image.file(
                        routeArg["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Card(
                    child: TextField(
                        controller: commentText,
                        decoration: const InputDecoration(
                            hintText: "Comment",
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 218, 218),
                            border: InputBorder.none),
                        maxLines: 4),
                  )
                ],
              ),
              isLoading
                  ? Center(
                      child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          height: 60,
                          child: const MyLoadingCircle()),
                    )
                  : RowButtons(onSaveTap: () {
                      // submitStartVist(routeArg["workingId"].toString());
                      uploadImageToCloud(
                          routeArg["image"],
                          routeArg["workingId"].toString(),
                          routeArg["clientId"].toString());
                    }, onBackTap: () {
                      Navigator.of(context).pop();
                    }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
