import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class JourneyPlanScreen2 extends StatefulWidget {
  const JourneyPlanScreen2({super.key});

  @override
  State<JourneyPlanScreen2> createState() => _JourneyPlanScreen2State();
}

class _JourneyPlanScreen2State extends State<JourneyPlanScreen2> {
  @override
  Widget build(BuildContext context) {
    var dropData = ["Type1", "Type2"];

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Pool2"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: dropdownwidget("Select Chain")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: dropdownwidget("Select Chain")),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(child: dropdownwidget("Select Store")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        filled: true,
                        fillColor: MyColors.lightgColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: GridView.builder(
                  itemCount: 10,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 10.0),
                  itemBuilder: (ctx, i) {
                    return Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      "assets/images/cardimg.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.pin_drop))),
                            ],
                          ),
                          // SizedBox(height: 10),
                          const Text(
                            "Jamia jamia -301",
                            style: TextStyle(color: MyColors.appMainColor),
                          ),
                          // SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(0, 77, 145, 1),
                                minimumSize: const Size(double.infinity, 35),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              child: const Text("Start"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
