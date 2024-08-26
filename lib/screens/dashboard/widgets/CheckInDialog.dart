import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import '../../../Model/database_model/sys_osdc_type_model.dart';
import '../../utils/services/image_picker.dart';
import 'image_camera_selection_row.dart';

class CustomCheckListDialog extends StatefulWidget {
  final List<Sys_OSDCTypeModel> checkListData;
  final String userName;
  final List<String> selectedIds=[];
  final Function(File? imagesFiles, String imageName,String ids) onTakeImages;
  CustomCheckListDialog(
      {required this.checkListData,
        required this.userName,
        required this.onTakeImages,
      });

  @override
  _CustomCheckListDialogState createState() => _CustomCheckListDialogState();
}

class _CustomCheckListDialogState extends State<CustomCheckListDialog> {
  late List<bool> _isCheckedList;
  File? imageFile;
  var imageName = "";
  @override
  void initState() {
    super.initState();
    _isCheckedList = List<bool>.filled(widget.checkListData.length, false);
  }

  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        imageFile = value;
        final String extension = path.extension(imageFile!.path);
        imageName =
        "${widget.userName}_${DateTime.now().millisecondsSinceEpoch}$extension";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: screenHeight / 1.7,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Check List Data',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: MyColors.appMainColor),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.checkListData.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth / 1.9,
                        child: Text(
                          widget.checkListData[index].en_name,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Checkbox(
                        value: _isCheckedList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _isCheckedList[index] = value!;
                            if (value) {
                              widget.selectedIds.add(widget.checkListData[index].id.toString());
                            } else {
                              widget.selectedIds.remove(widget.checkListData[index].id.toString());
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            ImageRowButtonDialog(
                isRequired: false,
                imageFile: imageFile,
                onSelectImage: () {
                  getImage();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onTakeImages(imageFile,imageName,widget.selectedIds.join(", "));
                  },
                  child: const Text('OK'),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
