import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class ViewCapturePhoto extends StatelessWidget {
  const ViewCapturePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Capture Photo")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 12,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    // decoration: BoxDecoration(
                    //     border: Border(bottom: BorderSide(color: Colors.black)),
                    //     ),
                    child: Card(
                      // shape: Border(
                      //   bottom: BorderSide(color: Colors.black),
                      // ),
                      // shape: RoundedRectangleBorder(side: BorderSide()),

                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3))),
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: MyColors.appMainColor, width: 7))),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Image.asset("assets/images/dslr.png"),
                              const Divider(
                                color: MyColors.appMainColor,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Client"),
                                  Text(
                                    "Competition",
                                  )
                                ],
                              ),
                              const Divider(
                                color: MyColors.appMainColor,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [Text("Category"), Text("Check app")],
                              ),
                              const Divider(
                                color: MyColors.appMainColor,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [Text("Photo Type"), Text("Canon")],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                color: MyColors.appMainColor,
                                height: 0,
                                indent: 0,
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
