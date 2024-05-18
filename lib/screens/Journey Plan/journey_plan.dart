import 'package:cstore/Model/response_model.dart/jp_response_model.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';

class JourneyPlan extends StatelessWidget {
  final JourneyPlanDetail jp;
  Function takeImageFtn;
  Function dropFtn;
  bool isDropLoading;
  Function undropFtn;
  String workingId;

  JourneyPlan({
    super.key,
    required this.jp,
    required this.takeImageFtn,
    required this.dropFtn,
    required this.isDropLoading,
    required this.undropFtn,
    required this.workingId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.grey),
          // borderRadius: BorderRadius.circular(15),
          ),
      height: 120,
      child: (isDropLoading && workingId == jp.workingId.toString())
          ? const Center(
              child: MyLoadingCircle(),
            )
          : Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, top: 5, bottom: 5.0),
                      child: Stack(
                        children: [
                          Positioned(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomRight:
                                      Radius.circular(10.0)), // Image border
                              child: Image.asset(
                                "assets/images/cardimg.png",
                                height: 120,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10))),
                              child: Text(
                                jp.visitType,
                                // "Special",

                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          // "Carrfour - 527 store Barka",
                          jp.enStoreName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Jaddah albaraj",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Row(
                        //   children: [
                        //     Align(
                        //         alignment: Alignment.topRight,
                        //         child: Icon(Icons.pin_drop)),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: jp.isDrop == 0
                                    ? () {
                                        takeImageFtn(
                                            jp.clientIds, jp.workingId);
                                      }
                                    : null,
                                child: const Text("Start Visit")),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                onPressed: jp.visitStatus.toLowerCase() ==
                                        "pending"
                                    ? () {
                                        if (jp.isDrop == 0) {
                                          dropFtn(jp.workingId.toString());
                                        } else if (jp.isDrop == 1) {
                                          undropFtn(jp.workingId.toString());
                                        }
                                      }
                                    : null,
                                child: Text(
                                    jp.isDrop == 0 ? "Drop Visit" : "UnDrop"))
                          ],
                        )
                      ],
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
    //     Container(
    //   margin: EdgeInsets.only(top: 50),
    //   child: Card(
    //     elevation: 10,
    //     child: Row(
    //       children: [
    //         Image.asset(
    //           "assets/images/cardimg.png",
    //           height: 100,
    //           width: 100,
    //           fit: BoxFit.cover,
    //         ),
    //         Column(
    //           children: [
    //             Text("Carrfour -527 alhaj Jaddah store"),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 ElevatedButton(
    //                     onPressed: () {}, child: Text("Start Visi")),
    //                 ElevatedButton(
    //                     onPressed: () {}, child: Text("Drop Visit")),
    //               ],
    //             )
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // ),
  }
}
