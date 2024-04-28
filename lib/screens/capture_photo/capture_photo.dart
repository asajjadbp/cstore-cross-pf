import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class CapturePhoto extends StatefulWidget {
  static const routename = "/capturePhotoroute";
  const CapturePhoto({super.key});

  @override
  State<CapturePhoto> createState() => _CapturePhotoState();
}

class _CapturePhotoState extends State<CapturePhoto> {
  var dropData = ["type A", "Type B"];
  Widget dropdownwidget(String hintText) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: dropData
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {},
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture Photo"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Company Name",
              style: TextStyle(
                  color: MyColors.appMainColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            dropdownwidget("Company Name"),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Category",
              style: TextStyle(
                  color: MyColors.appMainColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            dropdownwidget("Company Name"),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Category Type",
              style: TextStyle(
                  color: MyColors.appMainColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            dropdownwidget(
              "Company Name",
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Container(
            //   height: 100,
            //   width: screenWidth,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: Colors.grey)),
            //   child: Center(child: Text("Image will show here")),
            // ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Card(
                    elevation: 5,
                    child: Image.asset("assets/images/gallery1.png"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: Card(
                    elevation: 5,
                    child: Image.asset("assets/images/camera.png"),
                  ),
                ),
              ],
            ),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: MyColors.appMainColor,
            //       minimumSize: Size(screenWidth, 45),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10))),
            //   icon: const Icon(Icons.camera_alt),
            //   onPressed: () {
            //     // Navigator.of(context).pushNamed();
            //   },
            //   label: const Text(
            //     "Take Image",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.appMainColor,
                  minimumSize: Size(screenWidth, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                // Navigator.of(context).pushNamed();
              },
              child: const Text(
                "Save Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
