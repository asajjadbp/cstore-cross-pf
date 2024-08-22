
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../widget/app_bar_widgets.dart';

class NearestStoreGalleryScreen extends StatefulWidget {

  const NearestStoreGalleryScreen({super.key,required this.imagesList});

 final List<File> imagesList ;

  @override
  State<NearestStoreGalleryScreen> createState() =>
      _NearestStoreGalleryScreenState();
}

class _NearestStoreGalleryScreenState extends State<NearestStoreGalleryScreen> {
  int selectedIndex = 0;
  String storeName = '';
  String userName = '';

  updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    getUserData();

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      },  true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: widget.imagesList.isEmpty ? const Center(child: Text("No Data to Show"),) : Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.file(
                widget.imagesList[selectedIndex],
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 110,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.all(Radius.circular(10))),
            child: ListView.builder(
                itemCount: widget.imagesList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index) {
                  return InkWell(
                    onTap: (){
                      updateSelectedIndex(index);
                    },
                    child: Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 120,
                            height: 110,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                        Container(
                          width: 120,
                          height: 110,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child:  Image.file(
                              widget.imagesList[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if(selectedIndex == index)
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 120,
                            height: 110,
                            decoration:  BoxDecoration(
                                color:    Colors.grey.withOpacity(0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                            child: const Icon(Icons.check,color: MyColors.whiteColor,size: 40,),

                          ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
