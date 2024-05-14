import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cstore/Model/database_model/category_model.dart';
import 'package:cstore/Model/database_model/client_model.dart';
import 'package:cstore/database/db_helper.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gallery_saver/gallery_saver.dart';

import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/toast/toast.dart';

class BeforeFixing extends StatefulWidget {
  static const routeName = "/BeforeFixingroute";
  const BeforeFixing({super.key});

  @override
  State<BeforeFixing> createState() => _BeforeFixingState();
}

class _BeforeFixingState extends State<BeforeFixing> {
  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [];
  File? imageFile;
  int selectedClientId = -1;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientData();
  }

  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      imageFile = value;
      // _takePhoto(value);
      _takePicture();
    });
  }

  // void _takePhoto(File recordedImage) async {
  //   // if (recordedImage != null && recordedImage.path != null) {
  //   // setState(() {
  //   //   firstButtonText = 'saving in progress...';
  //   // });
  //   GallerySaver.saveImage(recordedImage.path).then((path) {
  //     // setState(() {
  //     //   firstButtonText = 'image saved!';
  //     // });
  //   });
  //   // }
  // }

  Future<void> _takePicture() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (imageFile != null) {
        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore';
        final String filePath =
            '$folderPath/${DateTime.now().millisecondsSinceEpoch}.jpg';
        print("middle");

        await Directory(folderPath).create(recursive: true);
        await File(imageFile!.path).copy(filePath).then((value) {
          ToastMessage.succesMessage(context, "Image store successfully");
        });

        // setState(() {
        //   imageFile = File(filePath);
        // });
      }
    } else {
      print('Permission denied');
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.camera.request();
    return permission;
  }

  void getClientData() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getClientList().then((value) {
      setState(() {
        isLoading = false;
      });
      clientData = value;
    });
    print(clientData[0].client_name);
  }

  void getCategoryData() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getCategoryList().then((value) {
      setState(() {
        isLoading = false;
      });
      categoryData = value;
    });
    print(categoryData[0].name);
  }

  var dropData = ["type A", "Type B"];
  Widget dropdownwidget(String hintText) {
    return DropdownButtonFormField2<CategoryModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: categoryData
          .map((item) => DropdownMenuItem<CategoryModel>(
                value: item,
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: selectedClientId == -1 ? null : (value) {},
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget clientDropDownWidget(String hintText) {
    return DropdownButtonFormField2<ClientModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: clientData
          .map((item) => DropdownMenuItem<ClientModel>(
                value: item,
                child: Text(
                  item.client_name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          selectedClientId = value!.client_id;
        });
        getCategoryData();
        print(selectedClientId);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture Photo"),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 60,
                child: const MyLoadingCircle(),
              ),
            )
          : Container(
              margin: const EdgeInsets.only(left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Client",
                    style: TextStyle(
                        color: MyColors.appMainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // dropdownwidget("Company Name"),
                  clientDropDownWidget("Client"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Category",
                    style: TextStyle(
                        color: MyColors.appMainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  dropdownwidget("Category"),
                  const SizedBox(
                    height: 20,
                  ),
                  // const Text(
                  //   "Category Type",
                  //   style: TextStyle(
                  //       color: MyColors.appMainColor, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // dropdownwidget(
                  //   "Company Name",
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //   height: 100,
                  //   width: screenWidth,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       border: Border.all(color: Colors.grey)),
                  //   child: Center(child: Text("Image will show here")),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: Card(
                          elevation: 5,
                          child: Image.asset("assets/images/gallery1.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Card(
                            elevation: 5,
                            child: Image.asset("assets/images/camera.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButton.icon(
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: MyColors.appMainColor,
                  //       minimumSize: Size(screenWidth, 45),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10))),
                  //   icon: const Icon(Icons.camera_alt),
                  //   onPressed: () {
                  //     // Navigator.of(context).pushNamed();
                  //   },
                  //   label: const Text(
                  //     "Take Image",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.appMainColor,
                        minimumSize: Size(screenWidth, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      // Navigator.of(context).pushNamed();
                    },
                    child: const Text(
                      "Save Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
