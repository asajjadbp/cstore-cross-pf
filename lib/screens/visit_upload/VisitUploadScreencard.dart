import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widget/loading.dart';

class VisitAvlUploadScreenCard extends StatelessWidget {
  const VisitAvlUploadScreenCard({
    super.key,
    required this.storeName,
    required this.screenName,
    required this.checkinTime,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalSkus,
    required this.avlSkus,
    required this.notAvlSkus,
    required this.notMarkedSkus,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String storeName;
  final String screenName;
  final String checkinTime;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalSkus;
  final int avlSkus;
  final int notAvlSkus;
  final int notMarkedSkus;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
          margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth / 1.7,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 3),
                  child: Text(
                    storeName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth /3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 3),
                  child: Text(
                    "CheckIn : $checkinTime",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:MyColors.darkGreyColor),
                  ),
                ),
              )
            ],

          ),
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.check_box_sharp,color: MyColors.greenColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.cancel,color: MyColors.backbtnColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /5,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.pending,color: MyColors.darkGreyColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalSkus.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Center(
                              child: Text(
                                avlSkus.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notAvlSkus.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /5.5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notMarkedSkus.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitPickListUploadScreenCard extends StatelessWidget {
  const VisitPickListUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalPickList,
    required this.readyPickList,
    required this.notReadyPickList,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalPickList;
  final int readyPickList;
  final int notReadyPickList;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.check_box_sharp,color: MyColors.greenColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.cancel,color: MyColors.backbtnColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalPickList.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Center(
                              child: Text(
                                readyPickList.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notReadyPickList.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitBrandShareUploadScreenCard extends StatelessWidget {
  const VisitBrandShareUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalBrands,
    required this.readyBrandList,
    required this.notReadyBrandList,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalBrands;
  final int readyBrandList;
  final int notReadyBrandList;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.check_box_sharp,color: MyColors.greenColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.pending,color: MyColors.warningColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalBrands.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Center(
                              child: Text(
                                readyBrandList.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notReadyBrandList.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitPlanoguideUploadScreenCard extends StatelessWidget {
  const VisitPlanoguideUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalPlanoguide,
    required this.totalAdhere,
    required this.totalNotAdhere,
    required this.notMarkedPlanoguide,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalPlanoguide;
  final int totalAdhere;
  final int totalNotAdhere;
  final int notMarkedPlanoguide;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.check_box_sharp,color: MyColors.greenColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.warning_amber_rounded,color: MyColors.backbtnColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /5,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: Icon(Icons.pending,color: MyColors.warningColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalPlanoguide.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Center(
                              child: Text(
                                totalAdhere.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalNotAdhere.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /5.5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notMarkedPlanoguide.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitRtvUploadScreenCard extends StatelessWidget {
  const VisitRtvUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalRtv,
    required this.uploadedData,
    required this.notUploadedData,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalRtv;
  final int uploadedData;
  final int notUploadedData;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: FaIcon(FontAwesomeIcons.cubesStacked,color: MyColors.savebtnColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: FaIcon(FontAwesomeIcons.circleDollarToSlot,color: MyColors.savebtnColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalRtv.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Center(
                              child: Text(
                                uploadedData.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notUploadedData.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitPriceCheckUploadScreenCard extends StatelessWidget {
  const VisitPriceCheckUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalPriceCheck,
    required this.uploadedData,
    required this.notUploadedData,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalPriceCheck;
  final int uploadedData;
  final int notUploadedData;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: FaIcon(FontAwesomeIcons.circleDollarToSlot,color: MyColors.savebtnColor,),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12, top: 3),
                              child: FaIcon(FontAwesomeIcons.bullhorn,color: MyColors.savebtnColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalPriceCheck.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Center(
                              child: Text(
                                uploadedData.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth /8,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  notUploadedData.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitFreshnessUploadScreenCard extends StatelessWidget {
  const VisitFreshnessUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalRtv,
    required this.uploadedData,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalRtv;
  final int uploadedData;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  moduleName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const FaIcon(FontAwesomeIcons.cubesStacked,color: MyColors.savebtnColor,),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth /5,
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 7, top: 8),
                              child: Center(
                                child: Text(
                                  totalRtv.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.darkGreyColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.only(left: 7, top: 8),
                            child: Text(
                              uploadedData.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.darkGreyColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,)
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class VisitStockUploadScreenCard extends StatelessWidget {
  const VisitStockUploadScreenCard({
    super.key,
    required this.screenName,
    required this.moduleName,
    required this.onUploadTap,
    required this.totalStock,
    required this.totalCases,
    required this.totalOuters,
    required this.totalPieces,
    required this.isUploadData,
    required this.isUploaded,
  });

  final String screenName;
  final String moduleName;
  final Function onUploadTap;
  final bool isUploadData;
  final int totalStock;
  final int totalCases;
  final int totalOuters;
  final int totalPieces;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12,top: 8),
            child: Text(
              screenName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:MyColors.appMainColor),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth/1.48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MyColors.appMainColor, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                              child: Text(
                                moduleName,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   child: Padding(
                          //     padding: EdgeInsets.only(left: 12, top: 3),
                          //     child:  FaIcon(FontAwesomeIcons.layerGroup,color: MyColors.savebtnColor,),
                          //   ),
                          // ),
                           Expanded(
                            child: Container(
                                margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                                child:const FaIcon(FontAwesomeIcons.box,color: MyColors.savebtnColor,)),
                          ),
                           Expanded(
                            child: Container(
                                margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                                child:const FaIcon(FontAwesomeIcons.boxesStacked,color: MyColors.savebtnColor,)),
                          ),
                           Expanded(
                            child: Container(
                                margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                                child: const FaIcon(FontAwesomeIcons.cubesStacked,color: MyColors.savebtnColor,)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: MyColors.appMainColor,height: 2,),
                    Container(
                      color: MyColors.rowGreyishColor,
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                              child: Text(
                                totalStock.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                              child: Text(
                                totalCases.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                              child: Text(
                                totalOuters.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                              child: Text(
                                totalPieces.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.darkGreyColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isUploadData ? const Center(child: CircularProgressIndicator(),) :  InkWell(
                onTap: isUploaded ? null : (){
                  onUploadTap();
                },
                child: Container(
                  width: screenWidth/5.3,
                  height: screenHeight/11.1,
                  decoration: BoxDecoration(
                      color: MyColors.appMainColor,
                      border: Border.all(color: MyColors.appMainColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Icon( isUploaded ? Icons.check : Icons.cloud_upload_outlined,color: Colors.white,size: 39,),
                      Padding(
                        padding: EdgeInsets.only(left: 7, top: 8),
                        child: Center(
                          child: Text(
                            isUploaded ? "Done" : "Upload",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}