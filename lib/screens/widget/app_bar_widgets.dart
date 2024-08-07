

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';

generalAppBar(BuildContext context,String userName,String storeName, Function onBackTap,Function onFilterTap,bool isBackButton,bool isFilterButton,bool isLogoutButton ) {
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
                    sharedPreferences.setBool(AppConstants.userLoggedIn, false);
                    Navigator.of(context).pushReplacementNamed(Login.routeName);
                    ToastMessage.succesMessage(context, "Logged Out Successfully");
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      }, icon: const Icon(Icons.logout_rounded)),
      if(isFilterButton)
      IconButton(onPressed: (){
        onFilterTap();
      }, icon: const Icon(Icons.filter_alt_outlined)),
    ],
  );
}