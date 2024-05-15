import 'dart:io';

import 'package:cstore/Model/database_model/get_trans_photo_model.dart';
import 'package:cstore/database/db_helper.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../database/table_name.dart';

class ViewBeforeFixing extends StatefulWidget {
  static const routename = "view_before_route";
  const ViewBeforeFixing({super.key});

  @override
  State<ViewBeforeFixing> createState() => _ViewBeforeFixingState();
}

class _ViewBeforeFixingState extends State<ViewBeforeFixing> {
  List<File> _imageFiles = [];
  List<GetTransPhotoModel> transData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getTransPhoto();
  }

  Future<void> getTransPhoto() async {
    // setState(() {
    //   isLoading = true;
    // });
    await DatabaseHelper.getTransPhoto().then((value) async {
      transData = value;
      await _loadImages().then((value) {
        setTransPhoto();
      });
    });
  }

  void setTransPhoto() {
    for (var trans in transData) {
      String imageName = trans.img_name;
      print(imageName);
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.img_name));
      }
      if (trans.imageFile != null) {
        print("hello world");
      }
      // File matchingImage = _imageFiles
      //     .firstWhere((file) => file.path.endsWith(imageName), orElse: null);

      // trans.imageFile = matchingImage;
      // print(trans.imageFile!.path);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath = '$dirPath/cstore';

      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();
      }
    } catch (e) {
      print('Error reading images: $e');
    }

    // setState(() {});
  }

  void deletePhoto(int recordId) async {
    // print(recordId);
    // return;
    await DatabaseHelper.deleteOneRecord(TableName.tbl_trans_photo, recordId)
        .then((_) {
      _loadImages();
      getTransPhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nahdi Al Hamra")),
      body: isLoading
          ? const Center(
              child: MyLoadingCircle(),
            )
          : transData.isEmpty
              ? const Center(
                  child: Text("No data found"),
                )
              : ListView.builder(
                  itemCount: transData.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: 120,
                      child:
                          // MyCardWidget(
                          //     image: transData[i].imageFile as File,
                          //     name: transData[i].img_name)
                          Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Stack(
                              //   children: [
                              //     Positioned(right: 0, child: Text("data")),
                              //     // Positioned(
                              //     //   right: 0,
                              //     //   child: Container(
                              //     //     padding: const EdgeInsets.all(5),
                              //     //     decoration: const BoxDecoration(
                              //     //         color: Colors.black,
                              //     //         borderRadius: BorderRadius.only(
                              //     //             topLeft: Radius.circular(10))),
                              //     //     child: Text(
                              //     //       // jp.visitType,
                              //     //       "Special",
                              //     //       style: const TextStyle(color: Colors.white),
                              //     //     ),
                              //     //   ),
                              //     // )
                              //   ],
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 5, bottom: 5.0),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ), // Image border
                                          child: Image.file(
                                              transData[i].imageFile as File)
                                          //   Image.asset(
                                          //     "assets/images/cardimg.png",
                                          //     height: 120,
                                          //     width: 100,
                                          //     fit: BoxFit.cover,
                                          //   ),
                                          ),
                                    ),
                                    // Positioned(
                                    //   right: 0,
                                    //   child: Container(
                                    //     padding: const EdgeInsets.all(5),
                                    //     decoration: const BoxDecoration(
                                    //         color: Colors.black,
                                    //         borderRadius: BorderRadius.only(
                                    //             topLeft: Radius.circular(10))),
                                    //     child: Text(
                                    //       // jp.visitType,
                                    //       "Special",
                                    //       style: const TextStyle(color: Colors.white),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Client"),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Nvedia")
                                ],
                              ),

                              // Column(
                              //   children: [
                              //     const SizedBox(
                              //       height: 10,
                              //     ),
                              //     Text(
                              //       "Carrfour - 527 store Barka",
                              //       style: const TextStyle(fontWeight: FontWeight.bold),
                              //     ),

                              //     // Row(
                              //     //   children: [
                              //     //     Align(
                              //     //         alignment: Alignment.topRight,
                              //     //         child: Icon(Icons.pin_drop)),
                              //     //   ],
                              //     // ),
                              //   ],
                              // ),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      deletePhoto(transData[i].id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                  // Icon(
                                  //   Icons.delete,
                                  //   color: Colors.red,
                                  // ),
                                  )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
    );
  }
}

class MyCardWidget extends StatelessWidget {
  final File image;
  final String name;
  // const MyCardWidget({super.key});
  MyCardWidget({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15),
          child: Card(
              elevation: 1,
              semanticContainer: false,
              child: Container(
                // width: 320,
                // height: 81,

                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(7)),
                margin: EdgeInsets.only(),
                child: Row(
                  children: [
                    Container(
                      height: 81,
                      width: 120,
                      // margin: EdgeInsets.only(left: 5),
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.file(
                            image,
                            height: 66,
                            width: 66,
                          )
                          // Image(
                          //   image: AssetImage("assets/images/shelf-photo.png"),
                          //   height: 66,
                          //   width: 66,
                          // ),
                          ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 00, left: 20),
                            child: Row(
                              children: [
                                Text(
                                  "client",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(17, 93, 144, 1)),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  "Nivea",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(17, 93, 144, 1)),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                // SvgPicture.asset("assets/svg_icons/delt.svg")
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5, left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "category",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromRGBO(68, 68, 68, 1)),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    "Body lotion",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromRGBO(68, 68, 68, 1)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            height: 18,
            width: 78,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Center(
                child: Text(
              " 11:30 PM",
              style: TextStyle(fontSize: 10, color: Colors.white),
            )),
          ),
        )
      ],
    );
  }
}
