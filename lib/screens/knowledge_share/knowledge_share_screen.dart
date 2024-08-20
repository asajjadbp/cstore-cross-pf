import 'dart:convert';
import 'dart:io';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/knowledgeShare_model.dart';
import '../../Model/database_model/show_trans_osdc_model.dart';
import '../ImageScreen/image_screen.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import 'widgets/knowledge_share_card.dart';
import 'widgets/knowledge_share_card.dart';

class ViewKnowledgeShare extends StatefulWidget {
  static const routename = "knowledgeShare";

  const ViewKnowledgeShare({super.key});

  @override
  State<ViewKnowledgeShare> createState() => _ViewKnowledgeShareState();
}

class _ViewKnowledgeShareState extends State<ViewKnowledgeShare> {
  List<KnowledgeShareModel> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeName = '';
  String clientId = '';
  String imageBaseUrl = '';
  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }
  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    getKnowledgeShareOne();
  }
  Future<void> getKnowledgeShareOne() async {
    await DatabaseHelper.getKnowledgeShareList(clientId).then((value) async {
      transData = value;
      print(jsonEncode(transData));
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor:MyColors.background,
        appBar: generalAppBar(context, storeName, "Knowledge Share", () {
          Navigator.of(context).pop();
        }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        }),
        body: ListView.builder(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
            shrinkWrap: true,
            itemCount: transData.length,
            itemBuilder: (ctx, i) {
              return KnowledgeShareCard(
                onTap: () {
                  print(transData[i].type);
                  print("${imageBaseUrl}knowledge_share/${transData[i].file_name}");
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PdfScreen(type: transData[i].type,pdfUrl: "${imageBaseUrl}knowledge_share/${transData[i].file_name}")));
                },
                  title: transData[i].title,
                  subtitle: transData[i].description,
                  pdf: transData[i].type,
                  date: transData[i].updated_at);
            }));
  }
}
