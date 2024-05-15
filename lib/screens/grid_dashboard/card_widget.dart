import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';

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
        semanticContainer: true,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        shadowColor: Colors.black12,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   imageUrl,
                //   fit: BoxFit.contain,
                // ),
                CachedNetworkSVGImage(
                  "https://storage.googleapis.com/catalisttest-bucket/dashboard/$imageUrl",
                  placeholder:
                      const CircularProgressIndicator(color: Colors.green),
                  errorWidget: const Icon(Icons.error, color: Colors.red),
                  width: 80.0,
                  height: 80.0,
                  fadeDuration: const Duration(milliseconds: 500),
                ),
                // Image.network(
                //     "https://storage.googleapis.com/catalisttest-bucket/dashboard/$imageUrl",
                //     fit: BoxFit.contain),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(cardName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
