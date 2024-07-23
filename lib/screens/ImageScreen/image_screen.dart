import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../widget/loading.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key,required this.imageUrl});

  final String imageUrl;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.fitHeight,
          imageBuilder: (context, imageProvider) {
            return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth)));
          },
          placeholder: (context, url) => const SizedBox(
              width: 20, height: 10, child: MyLoadingCircle()),
          errorWidget: (context, url, error) => Container(
              alignment: Alignment.center,
              child: const Icon(Icons.error)),
        ),
      ),
    );
  }
}
