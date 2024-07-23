import 'dart:io';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_before_fixing.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/loading.dart';

class ViewBeforeFixing extends StatefulWidget {
  static const routename = "view_before_route";

  const ViewBeforeFixing({super.key});

  @override
  State<ViewBeforeFixing> createState() => _ViewBeforeFixingState();
}

class _ViewBeforeFixingState extends State<ViewBeforeFixing> {
  List<File> _imageFiles = [];
  List<GetTransBeforeFixing> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeName = '';

  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    getTransBeforeFixingOne();
  }

  Future<void> getTransBeforeFixingOne() async {
    await DatabaseHelper.getTransBeforeFixing(workingId).then((value) async {
      transData = value.cast<GetTransBeforeFixing>();
      await _loadImages().then((value) {
        setTransPhoto();
      });
    });
  }

  void setTransPhoto() {
    for (var trans in transData) {
      String imageName = trans.img_name;

      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.img_name));
      }
    }
    print("TRANSASDJJJJJJJJJJJJJJJJ");
    print(transData);
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
      final String folderPath =
          '$dirPath/cstore/$workingId/${AppConstants.beforeFixing}';
      print("******************");
      print(folderPath);
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

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.camera.request();
    return permission;
  }

  Future<void> deleteImageFromLocal(String imgName) async {
    try {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore/$workingId/before_fixing';
        final file = File('$folderPath/$imgName');

        if (await file.exists()) {
          await file.delete();
          print("File deleted: $folderPath/$imgName");
        } else {
          print("File not found: $folderPath/$imgName");
        }
      } else {
        // print('Permission denied');
        ToastMessage.errorMessage(context, "Permissing denied");
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permissing denied");
    }
  }

  void deletePhoto(int recordId, String imgName) async {
    await DatabaseHelper.deleteOneRecord(
            TableName.tbl_trans_before_faxing, recordId)
        .then((_) async {
      // await deleteImageFromLocal(imgName).then((_) {
      //   _loadImages();
      //   getTransBeforeFixingOne();
      // });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Are you sure you want to delete this item Permanently",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  deleteImageFromLocal(imgName).then((_) {
                    _loadImages();
                    getTransBeforeFixingOne();
                    Navigator.of(context).pop(true);
                  });
                },
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              "View Before Fixing",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
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
                      color: MyColors.background,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: 120,
                      child: Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 96,
                              height: 100,
                              padding: const EdgeInsets.only(
                                left: 5,
                                top: 5,
                                bottom: 5.0,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6.0),
                                    bottomLeft: Radius.circular(6.0),
                                    topRight: Radius.circular(6.0),
                                    bottomRight: Radius.circular(6.0),
                                  ), // Image border
                                  child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: transData[i].imageFile != null
                                          ? Image.file(
                                              transData[i].imageFile as File)
                                          : Container())),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          "assets/icons/client_icon.png"),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: Text(
                                        transData[i].clientName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/Component 13.svg",
                                        width: 10,
                                        height: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: Text(
                                              transData[i].categoryEnName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    deletePhoto(
                                        transData[i].id, transData[i].img_name);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ))
                          ],
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
