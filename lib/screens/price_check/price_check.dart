import 'package:flutter/material.dart';

import '../capture_photo/capture_photo.dart';
import 'card_widget.dart';

class PriceCheck extends StatelessWidget {
  static const routeName = "/proofOfSaleRoute";
  const PriceCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final nameList = [
      "Capture Photo",
      "Planogram",
      "Proof of Sale",
      "Market issue",
      "Share of Shelf",
      "Price Check"
    ];
    // final iconName = [];
    return Scaffold(
      appBar: AppBar(title: const Text("Price Check")),
      body: GridView.builder(
          itemCount: 5,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 10.0),
          itemBuilder: (context, i) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CardWidget(
                  onTap: () {
                    Navigator.of(context).pushNamed(CapturePhoto.routename);
                  },
                  imageUrl: "assets/images/camera.png",
                  cardName: nameList[i]),
            );
          }),
    );
  }
}
