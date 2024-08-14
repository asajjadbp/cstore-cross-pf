
import 'package:cstore/Model/response_model.dart/syncronise_response_model.dart';
import 'package:cstore/Network/syncronise_http.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/table_name.dart';
import '../auth/login.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class WelcomeScreen extends StatefulWidget {
  static const routename = "/welcome_route";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  bool isLoading = false;
  var userName = "";
  var token = "";
  var baseUrl = "";
  String isSyncronize = "0";
  List<SyncroniseDetail> syncroniseData = [];
  double currentVersion = 0.0;
  double updatedVersion = 0.0;
  String agencyPhoto = "";
  String welcomeMessage = "";

  bool isinit = true;

  bool isError = false;
  String errorText = "";

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

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

    if (isinit) {
      getUserData();
      await DatabaseHelper.database;
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

    userName = prefs.getString(AppConstants.userName)!;
    token = prefs.getString(AppConstants.tokenId)!;
    baseUrl = prefs.getString(AppConstants.baseUrl)!;
    isSyncronize = prefs.getString(AppConstants.isSyncronize)!;
    agencyPhoto = prefs.getString(AppConstants.agencyPhoto)!;
    welcomeMessage = prefs.getString(AppConstants.userEnMessage)!;

    if(prefs.containsKey(AppConstants.appCurrentVersion)) {
      currentVersion = prefs.getDouble(AppConstants.appCurrentVersion)!;
    } else {
      currentVersion = 0.0;
      prefs.setDouble(AppConstants.appCurrentVersion, currentVersion);
    }
    updatedVersion = prefs.getDouble(AppConstants.appUpdatedVersion)!;

    setState(() {

    });
    print(userName);
    print(currentVersion);
    print(updatedVersion);
    print(isSyncronize);

    if(isSyncronize == "0") {
      await getSyncronise();
    }
  }

  Future<void> getSyncronise() async {
    setState(() {
      isLoading = true;
    });
    // try {
    await SyncroniseHTTP()
        .fetchSyncroniseData(userName, token, baseUrl)
        .then((value) async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
          isError = false;
          errorText = "";

       ///DB Dropping
       if(currentVersion != updatedVersion) {
         bool isDbDrop = await DatabaseHelper.dropDb();
         if(isDbDrop) {
           prefs.setDouble(AppConstants.appCurrentVersion, updatedVersion);
         }
         await DatabaseHelper.database;

       }

        syncroniseData = value.data;
        ToastMessage.succesMessage(context, "Data synchronization started now");

        ///Table Deletion
        DatabaseHelper.delete_table(TableName.tbl_sys_agency_dashboard);
        DatabaseHelper.delete_table(TableName.tbl_sys_category);
        DatabaseHelper.delete_table(TableName.tbl_sys_client);
        DatabaseHelper.delete_table(TableName.tbl_sys_drop_reason);
        DatabaseHelper.delete_table(TableName.tbl_sys_brand);
        DatabaseHelper.delete_table(TableName.tbl_sys_planogram_reason);
        DatabaseHelper.delete_table(TableName.tbl_sys_rtv_reason);
        DatabaseHelper.delete_table(TableName.tbl_sys_product);
        DatabaseHelper.delete_table(TableName.tbl_sys_photo_type);
        DatabaseHelper.delete_table(TableName.tbl_sys_osdc_type);
        DatabaseHelper.delete_table(TableName.tbl_sys_osdc_reason);

        DatabaseHelper.delete_table(TableName.tbl_sys_product_placement);
        DatabaseHelper.delete_table(TableName.tbl_sys_brand_faces);
        DatabaseHelper.delete_table(TableName.tbl_sys_store_pog);
        DatabaseHelper.delete_table(TableName.tbl_sys_app_setting);
        DatabaseHelper.delete_table(TableName.tbl_sys_daily_checklist);
        DatabaseHelper.delete_table(TableName.tbl_sys_sos_units);
        DatabaseHelper.delete_table(TableName.tblSysVisitReqModules);
        DatabaseHelper.delete_table(TableName.tblSysPromoPlan);
        DatabaseHelper.delete_table(TableName.tblSysJourneyPlan);
        DatabaseHelper.delete_table(TableName.tblSysDashboard);

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

        setState(() {
          isLoading = isJourneyPlan && isDashboardPlan && isAgencyDash && isCategory && isSubCategory
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
      ToastMessage.errorMessage(context, onError.toString());
    });
    // } catch (error) {

    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: generalAppBar(context, "Welcome, $userName", "", (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Perform logout operation
                    Navigator.of(context).pop();
                    SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                    sharedPreferences.setBool(
                        AppConstants.userLoggedIn, false);
                    Navigator.of(context).pushReplacementNamed(Login.routeName);
                    ToastMessage.succesMessage(context, "Logged Out Successfully");
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      }, (){print("filter Click");}, false, false, true),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
                    child:  SingleChildScrollView(child: Text(welcomeMessage,style: const TextStyle(fontSize: 17),))),
                Container(
                    margin:const EdgeInsets.symmetric(vertical: 20),
                    child: SvgPicture.network(agencyPhoto)),
              ],
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
                      FadeTransition(opacity: _animation,child: const Text("Synchronization in Progress...",style: TextStyle(fontSize: 16,color: MyColors.appMainColor),)),
                    ],
                  ),
                )
                    : isError ? Column(
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
                        child: const Text("Retry",style: TextStyle(color: MyColors.backbtnColor,fontSize: 22),),
                      ),
                    )
                  ],
                ) : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
                    minimumSize: Size(screenWidth, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(DashBoard.routeName);
                  },
                  child: const Text(
                    "Next",style: TextStyle(color: MyColors.whiteColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
