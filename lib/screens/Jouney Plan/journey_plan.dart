import 'package:flutter/material.dart';

class JourneyPlan extends StatelessWidget {
  const JourneyPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.grey),
          // borderRadius: BorderRadius.circular(15),
          ),
      height: 120,
      child: Card(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5.0),
                child: Stack(
                  children: [
                    Positioned(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)), // Image border
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
                        child: const Text(
                          "Special",
                          style: TextStyle(color: Colors.white),
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
                  const Text(
                    "Carrfour - 527 store Barka",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                          onPressed: () {}, child: const Text("Start Visit")),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text("Drop Visit"))
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
