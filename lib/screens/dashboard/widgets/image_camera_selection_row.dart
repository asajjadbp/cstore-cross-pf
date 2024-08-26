import 'dart:io';

import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageRowButtonDialog extends StatelessWidget {
  const ImageRowButtonDialog({super.key,required this.imageFile,required this.onSelectImage,required this.isRequired});
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
              width: MediaQuery.of(context).size.width/3.2,
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
              width: MediaQuery.of(context).size.width/3.2,
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
        Container(
          width: MediaQuery.of(context).size.width/3.2,
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
        Container(
            width: MediaQuery.of(context).size.width/3.2,
            height: MediaQuery.of(context).size.height/5.4,
            child: InkWell(
              onTap: (){
                onGalleryList();
              },
              child: Stack(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 1,
                    child: imageFile.isNotEmpty ? ListView.builder(
                        itemCount: imageFile.length,
                        physics:const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                          return Image.file(File(imageFile[index].path),fit: BoxFit.fill,height: MediaQuery.of(context).size.height/4.4,);
                        }) :
                    Image.asset("assets/icons/gallery_icon.png"),
                  ),
                  Center(
                    child: Text("+${imageFile.length - 1 }",style: const TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w500,fontSize: 25),),
                  )
                ],
              ),
            )
        ),
      ],
    );
  }
}