import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/Model/response_model.dart/jp_response_model.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';

class JourneyPlan extends StatelessWidget {
  final JourneyPlanDetail jp;
  String imageBaseUrl;
  Function onStartClick;
  Function onDropClick;
  bool isDropLoading;
  String workingId;
  Function onLocationTap;

  JourneyPlan({
    super.key,
    required this.imageBaseUrl,
    required this.jp,
    required this.onStartClick,
    required this.onDropClick,
    required this.isDropLoading,
    required this.workingId,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.grey),
          // borderRadius: BorderRadius.circular(15),
          ),
      height: 100,
      child: (isDropLoading && workingId == jp.workingId.toString())
          ? const Center(
              child: MyLoadingCircle(),
            )
          : Card(
        color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight:
                                    Radius.circular(10.0)), // Image border
                            child: jp.startVisitPhoto.isNotEmpty && jp.startVisitPhoto != "null" ? CachedNetworkImage(
                              imageUrl: "https://storage.googleapis.com/pandaimage-bucket/visits/${jp.startVisitPhoto}",
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,),
                                ),
                              ),
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                            ) :Image.asset(
                              "assets/icons/cart_icon.jpg",
                              height: 120,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 15,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                                color: MyColors.visitTypeBg,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))),
                            child: Text(
                              jp.visitType,
                              // "Special",

                              style: const TextStyle(color: Colors.white,fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            // "Carrfour - 527 store Barka",
                            jp.enStoreName,overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround  ,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    disabledBackgroundColor: jp.visitStatus == "2" ? MyColors.greenColor : null,
                                    backgroundColor: jp.visitStatus == "2" ? MyColors.greenColor : MyColors.appMainColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),)),
                                    onPressed: jp.isDrop == 1 ? null : jp.visitStatus == "2" ? null : () {
                                           onStartClick();
                                          },
                                    child:jp.visitStatus == "1"? const Text("Resume",style: TextStyle(color: MyColors.whiteColor,fontSize: 11),) : jp.visitStatus == "2" ?
                                    const Text("Completed",style: TextStyle(color: MyColors.whiteColor,fontSize: 11),) : const Text("Start Visit",style: TextStyle(color: MyColors.whiteColor,fontSize: 11),)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              jp.visitStatus == "1" || jp.visitStatus == "2" ?
                              Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: MyColors.appMainColor)),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(jp.checkIn,maxLines:1,style: const TextStyle(color: MyColors.appMainColor),),
                                            const Text(" - ",style: TextStyle(color: MyColors.appMainColor),),
                                            Text(jp.checkOut.isEmpty ? "...." : jp.checkOut,maxLines:1,style: const TextStyle(color: MyColors.appMainColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : Expanded(
                                    child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:jp.isDrop == 0 ? MyColors.backbtnColor : MyColors.appMainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),)),
                                                                    // style:  ElevatedButton.styleFrom(backgroundColor: MyColors.backbtnColor) : ElevatedButton.styleFrom(backgroundColor: MyColors.appMainColor),
                                    onPressed: jp.visitStatus == "1" ? null : (){
                                      onDropClick();
                                    },
                                    child: Text(
                                        jp.isDrop == 0 ? "Drop Visit" : "UnDrop",style: const TextStyle(color: MyColors.whiteColor,fontSize: 11),)),
                                  )
                            ],
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        onLocationTap();
                      },
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.pin_drop,
                          color: MyColors.appMainColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );

  }
}
