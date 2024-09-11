

import 'package:cstore/screens/widget/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';

generalAppBar(BuildContext context,String userName,String storeName, Function onBackTap,bool isBackButton,bool isFilterButton,bool isLogoutButton,final Function(int selectedClientId, int selectedCategoryId, int selectedSubCategoryId, int selectedBrandId) searchFilterData) {
  return AppBar(
    automaticallyImplyLeading: false,
    title:  Row(
      children: [
        if(isBackButton)
        IconButton(onPressed: (){
          onBackTap();
        }, icon: const Icon(Icons.arrow_back)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(userName ,overflow: TextOverflow.ellipsis,maxLines: 1,),
                  if(storeName.isEmpty)
                  Text(DateFormat("yyyy/MM/dd").format(DateTime.now())),
                ],
              ),
              if(storeName.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(storeName),
                  Text(DateFormat("yyyy/MM/dd").format(DateTime.now())),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      if(isLogoutButton)
      IconButton(onPressed: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logout'.tr),
              content: Text('Are you sure you want to logout?'.tr),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child:  Text('Cancel'.tr),
                ),
                TextButton(
                  onPressed: () async {
                    // Perform logout operation
                    Navigator.of(context).pop();
                    SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                    sharedPreferences.setBool(AppConstants.userLoggedIn, false);
                    Navigator.of(context).pushReplacementNamed(Login.routeName);
                    showAnimatedToastMessage("Success".tr, "Logged Out Successfully".tr, true);
                  },
                  child: Text('Logout'.tr),
                ),
              ],
            );
          },
        );
      }, icon: const Icon(Icons.logout_rounded)),
      if(isFilterButton)
        SearchBottomSheet(searchFilterData: searchFilterData)
    ],
  );
}