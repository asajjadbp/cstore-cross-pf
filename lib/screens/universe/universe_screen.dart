import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Database/db_helper.dart';
import '../../Model/database_model/sys_store_model.dart';
import '../Journey Plan/journey_plan.dart';
import '../utils/app_constants.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import '../widget/search_text_field.dart';

class UniverseList extends StatefulWidget {
  static const routename = "/universeScreen";
  const UniverseList({super.key});

  @override
  State<UniverseList> createState() => _UniverseListState();
}

class _UniverseListState extends State<UniverseList> {

  var userName = "";
  var token = "";
  var baseUrl = "";
  String imageBaseUrl = "";
  String bucketName = "";
  bool isLoading = false;
  List<SysStoreModel> universeStoresList = <SysStoreModel>[];

  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  final RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  void initState() {
    getUserData();
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        searchText = searchController.text;

        getUniverseDataFromSqlDb();

        print("Searching for: $searchText");
      });
    }
  }


  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userName = prefs.getString(AppConstants.userName)!;
    token = prefs.getString(AppConstants.tokenId)!;
    bucketName = prefs.getString(AppConstants.bucketName)!;
    imageBaseUrl = prefs.getString(AppConstants.imageBaseUrl)!;

    print(userName);
    print(prefs.getString(AppConstants.tokenId)!);
    print("jp screen");
    // print(urlData["data"][0]["base_url"]);
    baseUrl = prefs.getString(AppConstants.baseUrl)!;

    getUniverseDataFromSqlDb();
  }

  void _onRefresh() async {
    // await Future.delayed(const Duration(milliseconds: 1000));
    // DatabaseHelper.delete_table(TableName.tbl_user_dashboard);
    getUniverseDataFromSqlDb();
    _refreshController.refreshCompleted();
  }

  getUniverseDataFromSqlDb () async {
    setState(() {
      isLoading = true;
    });

    await DatabaseHelper.getUniverseStoreData(searchText).then((value) {
      universeStoresList = value;
      setState(() {
        isLoading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, userName, "Universe".tr, (){
        Navigator.of(context).pop();
      }, true, false, true,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: SearchTextField(searchController: searchController,hintText: "Search with store name..",)),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: _onRefresh,
                child: isLoading
                    ? const Center(
                  child: MyLoadingCircle(),
                ) : universeStoresList.isEmpty ?  Center(
                  child: Text("No journey plan found".tr),
                ) : ListView.builder(
                    itemCount: universeStoresList.length,
                    itemBuilder: (ctx, i) {
                      // print(
                      //     "https://storage.googleapis.com/$bucketName/visits/${jpData[i]
                      //         .startVisitPhoto}");
                      return UniverseStore(storeModel:universeStoresList[i],isCheckLoading: false, onStartClick: (){},  onLocationTap: (){
                        launchStoreUrl(universeStoresList[i].gcode);
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchStoreUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
