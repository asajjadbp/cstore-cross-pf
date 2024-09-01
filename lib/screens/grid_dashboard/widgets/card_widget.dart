import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardWidget extends StatelessWidget {
  CardWidget({
    Key? key,
    required this.onTap,
    required this.imageUrl,
    required this.cardName,
  }) : super(key: key);

  final String cardName;
  final String imageUrl;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        color: Colors.white,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/grid_dashboard_icons/$imageUrl.svg",
                  // placeholder:
                  //     const CircularProgressIndicator(color: Colors.green),
                  // errorWidget: const Icon(Icons.error, color: Colors.red),
                  width: 60.0,
                  height: 60.0,
                  // fadeDuration: const Duration(milliseconds: 500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(cardName,style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
