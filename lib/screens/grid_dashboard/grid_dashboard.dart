import 'package:cstore/Model/response_model.dart/syncronise_response_model.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../Model/database_model/dashboard_model.dart';
import '../before_fixing/before_fixing.dart';
import 'card_widget.dart';

class GridDashBoard extends StatefulWidget {
  static const routeName = "/GridDashboard";
  const GridDashBoard({super.key});

  @override
  State<GridDashBoard> createState() => _PriceCheckState();
}

class _PriceCheckState extends State<GridDashBoard> {
  bool isLoading = false;
  bool isinit = true;
  List<AgencyDashboardModel> agencyData = [];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isinit) {
      setState(() {
        isLoading = true;
      });
      agencyData = await DatabaseHelper.getAgencyDashboard();
      setState(() {
        isLoading = false;
      });
    }
    isinit = false;
  }

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
      body: isLoading
          ? Container(
              height: 60,
              child: const MyLoadingCircle(),
            )
          : GridView.builder(
              itemCount: agencyData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 10.0),
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: CardWidget(
                      onTap: () {
                        Navigator.of(context).pushNamed(BeforeFixing.routeName);
                      },
                      imageUrl: agencyData[i].icon,
                      // "assets/images/camera.png",
                      cardName: agencyData[i].ar_name),
                );
              }),
    );
  }
}
