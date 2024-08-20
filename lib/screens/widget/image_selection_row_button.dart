import 'dart:io';

import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageRowButton extends StatelessWidget {
  const ImageRowButton({super.key,required this.imageFile,required this.onSelectImage,required this.isRequired});
final File? imageFile;
final Function onSelectImage;
final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
             Row(
              children: [
                const Text("Take Photo "),
                if(isRequired)
                const Text("*", style: TextStyle(
                    color: MyColors.backbtnColor,
                    fontWeight: FontWeight.bold,fontSize: 14),)
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width/2.2,
              height: MediaQuery.of(context).size.height/5.4,
              child: InkWell(
                onTap: () {
                  onSelectImage();
                },
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Image.asset("assets/icons/camera_icon.png"),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Text("View Photo"),
            Container(
              width: MediaQuery.of(context).size.width/2.2,
              height: MediaQuery.of(context).size.height/5.4,
              child: Card(
                color: Colors.white,
                elevation: 1,
                child: imageFile != null ? Image.file(File(imageFile!.path),fit: BoxFit.fill,) :
                Image.asset("assets/icons/gallery_icon.png"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
class ImageListButton extends StatelessWidget {
  const ImageListButton({super.key,required this.imageFile,required this.onSelectImage,required this.onGalleryList});
  final List<File> imageFile;
  final Function onSelectImage;
  final Function onGalleryList;
  @override
  Widget build(BuildContext context) {
    print(imageFile.length);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              onSelectImage();
            },
            child: Column(
              children: [
                const Text("Take Photo "),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/6,
                    width: MediaQuery.of(context).size.width/2.2,
                    child: Image.asset("assets/icons/camera_icon.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: (){
              onGalleryList();
            },
            child: Column(
              children: [
                const Text("View Photo "),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Container(
                      height: MediaQuery.of(context).size.height/6,
                      width: MediaQuery.of(context).size.width/2.2,
                      color: Colors.white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        imageFile.isNotEmpty ? ListView.builder(
                            itemCount: imageFile.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index) {
                              return Container(
                                  margin:const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5
                                  ),
                                  child: Image.file(File(imageFile[index].path),fit: BoxFit.fill,height: MediaQuery.of(context).size.height/4.4,));
                            }) : Image.asset("assets/icons/gallery_icon.png"),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}