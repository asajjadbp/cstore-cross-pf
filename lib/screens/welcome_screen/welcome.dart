
import 'package:cstore/Model/response_model.dart/syncronise_response_model.dart';
import 'package:cstore/Network/syncronise_http.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/table_name.dart';
import '../Language/localization_controller.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/elevated_buttons.dart';
import '../widget/loading.dart';

class WelcomeScreen extends StatefulWidget {
  static const routename = "/welcome_route";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin  {

  late AnimationController _controller;
  late Animation<double> _animation;
  final languageController = Get.put(LocalizationController());
  bool isLoading = false;
  var userName = "";
  var token = "";
  var baseUrl = "";
  String isSyncronize = "0";
  List<SyncroniseDetail> syncroniseData = [];
  double currentVersion = 0.0;
  double updatedVersion = 0.0;
  String agencyPhoto = "";
  String welcomeEnMessage = "";
  String welcomeArMessage = "";

  bool isinit = true;

  bool isError = false;
  String errorText = "";
  String currentLanguage = "en";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    startDbProcess();

  }

  startDbProcess() async {
    if (isinit) {
      getUserData();
      await DatabaseHelper.database;
    }
    isinit = false;
  }


  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userName = prefs.getString(AppConstants.userName)!;
    token = prefs.getString(AppConstants.tokenId)!;
    baseUrl = prefs.getString(AppConstants.baseUrl)!;
    isSyncronize = prefs.getString(AppConstants.isSyncronize)!;
    agencyPhoto = prefs.getString(AppConstants.agencyPhoto)!;
    welcomeEnMessage = prefs.getString(AppConstants.userEnMessage)!;
    welcomeArMessage = prefs.getString(AppConstants.userArMessage)!;


    if(prefs.containsKey(AppConstants.appCurrentVersion)) {
      currentVersion = prefs.getDouble(AppConstants.appCurrentVersion)!;
    } else {
      currentVersion = 0.0;
      prefs.setDouble(AppConstants.appCurrentVersion, currentVersion);
    }
    updatedVersion = prefs.getDouble(AppConstants.appUpdatedVersion)!;

    setState(() {

    });

    if(isSyncronize == "0") {
      await getSyncronise();
    }
  }

  Future<void> getSyncronise() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    ///DB Dropping
    if(currentVersion != updatedVersion) {
      bool isDbDrop = await DatabaseHelper.dropDb();
      if(isDbDrop) {
        prefs.setDouble(AppConstants.appCurrentVersion, updatedVersion);
      }
      await DatabaseHelper.database;

    }

    // try {
    await SyncroniseHTTP()
        .fetchSyncroniseData(userName, token, baseUrl)
        .then((value) async {

          isError = false;
          errorText = "";

        syncroniseData = value.data;

        // print("Product Placement List");
        // print(syncroniseData[0].sysProductPlacement.length);

        showAnimatedToastMessage("Success".tr, "Data synchronization started now".tr, true);

       ///Table Deletion
       DatabaseHelper.delete_table(TableName.tblSysAgencyDashboard);
       DatabaseHelper.delete_table(TableName.tblSysCategory);
       DatabaseHelper.delete_table(TableName.tblSysClient);
       DatabaseHelper.delete_table(TableName.tblSysDropReason);
       DatabaseHelper.delete_table(TableName.tblSysBrand);
       DatabaseHelper.delete_table(TableName.tblSysPlanogramReason);
       DatabaseHelper.delete_table(TableName.tblSysRtvReason);
       DatabaseHelper.delete_table(TableName.tblSysProduct);
       DatabaseHelper.delete_table(TableName.tblSysPhototype);
       DatabaseHelper.delete_table(TableName.tblSysOsdcType);
       DatabaseHelper.delete_table(TableName.tblSysOsdcReason);

       DatabaseHelper.delete_table(TableName.tblSysProductPlacement);
       DatabaseHelper.delete_table(TableName.tblSysBrandFaces);
       DatabaseHelper.delete_table(TableName.tblSysStorePog);
       DatabaseHelper.delete_table(TableName.tblSysAppSetting);
       DatabaseHelper.delete_table(TableName.tblSysDailyChecklist);
       DatabaseHelper.delete_table(TableName.tblSysSosUnits);
       DatabaseHelper.delete_table(TableName.tblSysVisitReqModules);
       DatabaseHelper.delete_table(TableName.tblSysPromoPlan);
       DatabaseHelper.delete_table(TableName.tblSysJourneyPlan);
       DatabaseHelper.delete_table(TableName.tblSysDashboard);
       DatabaseHelper.delete_table(TableName.tblSysPromoPlaneReason);
       DatabaseHelper.delete_table(TableName.tblSysStores);

       DatabaseHelper.delete_table(TableName.tblLondonDairySurveyQuestion);
       DatabaseHelper.delete_table(TableName.tblLondonDairySurveyQuesOpt);


       ///Table Insertion
       var isDashboardPlan = await DatabaseHelper.insertSysDashboardArray(syncroniseData[0].sysDashboard);
       var isJourneyPlan = await DatabaseHelper.insertSysJourneyPlanArray(syncroniseData[0].sysJourneyPlan);
        var isAgencyDash=await DatabaseHelper.insertAgencyDashArray(syncroniseData[0].sysAgencyDashboard);
        var isCategory=await DatabaseHelper.insertCategoryArray(syncroniseData[0].sysCategory);
        var isSubCategory=await DatabaseHelper.insertSubCategoryArray(syncroniseData[0].sysSubCategory);
        var isClinet=await  DatabaseHelper.insertClientArray(syncroniseData[0].sysClient);
        var isDropReason=await  DatabaseHelper.insertDropReasonArray(syncroniseData[0].sysDropReason);
        var isBrand=await  DatabaseHelper.insertBrandArray(syncroniseData[0].sysBrand);
        var isPlanoReason=await  DatabaseHelper.insertSysPlanoReasonArray(syncroniseData[0].sysPlanoReason);
       var isRtvReason=await  DatabaseHelper.insertSysRTVReasonArray(syncroniseData[0].sysRTVReason);
       var isProduct=await   DatabaseHelper.insertProductArray(syncroniseData[0].sysProduct);
        var isPhotoType=await  DatabaseHelper.insertSysPhotoTypeArray(syncroniseData[0].sysPhotoType);
        var isOSDCType=await DatabaseHelper.insertOSDCTypeArray(syncroniseData[0].sysOsdcType);
        var isOsdcReason=await DatabaseHelper.insertOSDCReasonArray(syncroniseData[0].sysOsdcReason);
        var isStorePog=await DatabaseHelper.insertStorePogArray(syncroniseData[0].sysStorePog);
        var isProductPlacement=await DatabaseHelper.insertProductPlacementArray(syncroniseData[0].sysProductPlacement);
        var isBrandFace=await  DatabaseHelper.insertBrandFacesArray(syncroniseData[0].sysBrandFaces);
        var isReqMod=await  DatabaseHelper.insertSysRequiredModuleArray(syncroniseData[0].sysReqModule);
        var isAppSetting=await  DatabaseHelper.insertAppSettingArray(syncroniseData[0].sysAppSetting);
        var isDailyCheckList=await  DatabaseHelper.insertDailyCheckListArray(syncroniseData[0].sysDailCheckList);
        var isSOSUnit=await  DatabaseHelper.insertSOSUnitArray(syncroniseData[0].sysSosUnit);
        var isPromoPlan = await DatabaseHelper.insertSysPromoPlanArray(syncroniseData[0].sysPromoPlan);
        await DatabaseHelper.insertSysKnowledgeShareArray(syncroniseData[0].knowledgeShareModel);
        await DatabaseHelper.insertMarketIssueArray(syncroniseData[0].sysMarketIssue);
        await DatabaseHelper.insertPromoPlaneReasonArray(syncroniseData[0].sysPromoPlanReason);
        await DatabaseHelper.insertSysStoreArray(syncroniseData[0].sysStores);
          var isSurveyUnit=await DatabaseHelper.insertSysSurveyQuestionArray(syncroniseData[0].surveyQuestion);

        setState(() {
          isLoading = isSurveyUnit && isJourneyPlan && isDashboardPlan && isAgencyDash && isCategory && isSubCategory
              && isClinet && isPlanoReason && isRtvReason && isProduct && isPhotoType
              && isOSDCType && isOsdcReason && isStorePog && isProductPlacement && isBrandFace && isPromoPlan;
          isSyncronize = "1";
          prefs.setString(AppConstants.isSyncronize, "1");

        });
    }).catchError((onError) {
      print(onError);
      print("################");
      isError = true;
      errorText = onError.toString();
      setState(() {
        isLoading = false;
      });
      showAnimatedToastMessage("Error!".tr, errorText.tr, false);
    });
    // } catch (error) {

    // }
  }

  @override
  void dispose() {
    print('Dispose called');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: generalAppBar(context, "${"Welcome".tr}, $userName", "", (){
      }, false, false, true,(int getClient, int getCat, int getSubCat, int getBrand) {
      }),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35,),
            Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.15,
                      child: Image.asset("assets/images/brandlogo.png")),
                  Container(
                      constraints:  BoxConstraints(maxHeight: MediaQuery.of(context).size.height/3.5),
                      margin: const EdgeInsets.symmetric(vertical: 10 ),
                      child:  SingleChildScrollView(child:
                      Text(languageController.isEnglish.value ? welcomeEnMessage : welcomeArMessage,style: const TextStyle(fontSize: 17),))),
                  Container(
                      width: MediaQuery.of(context).size.width/2,
                      margin:const EdgeInsets.symmetric(vertical: 20),
                      child: SvgPicture.network(agencyPhoto)),
              ],
            ),
                )),
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                height:MediaQuery.of(context).size.height/4,
                child: isLoading
                    ?  Center(
                  child: Column(
                    children: [
                      const SizedBox(width: 60,height: 60,child: MyLoadingCircle(),),
                      FadeTransition(opacity: _animation,child: Text("Synchronization in Progress...".tr,style: const TextStyle(fontSize: 16,color: MyColors.appMainColor),)),
                    ],
                  ),
                )
                    : isError ? SingleChildScrollView(
                      child: Column(
                  children: [
                      Text(errorText,style: const TextStyle(color: MyColors.backbtnColor,fontSize: 22),),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: () async {
                          await getSyncronise();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: MyColors.backbtnColor,width: 2)
                          ),
                          child:  Text("Retry".tr,style:const TextStyle(color: MyColors.backbtnColor,fontSize: 22),),
                        ),
                      )
                  ],
                ),
                    ) : BigElevatedButton(
                    isBlueColor: true,
                    buttonName: "Next".tr,
                    submit: (){
                      Navigator.of(context).popAndPushNamed(DashBoard.routeName);
                    })
              ),
            )
          ],
        ),
      ),
    );
  }
}
