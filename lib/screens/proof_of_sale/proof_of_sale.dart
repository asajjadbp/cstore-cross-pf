import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class ProofOfSale extends StatefulWidget {
  const ProofOfSale({super.key});

  @override
  State<ProofOfSale> createState() => _ProofOfSaleState();
}

class _ProofOfSaleState extends State<ProofOfSale> {
  final dropData = ["Type1", "Type2"];

  Widget dropdownwidget(String hintText) {
    return DropdownButtonFormField2(
      decoration: const InputDecoration(
          isDense: true,
          filled: true,
          // fillColor: const Color.fromARGB(255, 226, 226, 226),
          contentPadding: EdgeInsets.zero,
          // // fillColor: Colors.white,
          border: InputBorder.none
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)
          // ),
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
        title: const Text("Proof Of Sale"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Customer Name",
                              filled: true,
                              fillColor: MyColors.lightgColor,
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            hintText: "Customer Email",
                            filled: true,
                            fillColor: MyColors.lightgColor,
                            border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        onSaved: (newValue) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phone",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: TextFormField(
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              hintText: "Phone Number",
                              filled: true,
                              fillColor: MyColors.lightgColor,
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Client",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      dropdownwidget("Select Client")
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      dropdownwidget("Select Category")
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: TextFormField(
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              hintText: "Enter Quantity",
                              filled: true,
                              fillColor: MyColors.lightgColor,
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SKU's",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      dropdownwidget("Select SKU's")
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.appMainColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: TextFormField(
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              hintText: "Enter Amount",
                              filled: true,
                              fillColor: MyColors.lightgColor,
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              width: screenWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)),
              child: const Center(child: Text("Image will show here")),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.appMainColor,
                  minimumSize: Size(screenWidth, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                // Navigator.of(context).pushNamed();
              },
              label: const Text(
                "Take Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
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
