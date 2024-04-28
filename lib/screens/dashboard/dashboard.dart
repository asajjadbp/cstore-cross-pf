import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../utils/appcolor.dart';

class DashBoard extends StatelessWidget {
  static const routeName = "/dashboard1";
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    Widget circularProgressCard(double percentValue, String cardName) {
      return Expanded(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(cardName),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CircularPercentIndicator(
                    radius: 28.0,
                    lineWidth: 5.0,
                    animation: true,
                    percent: 0.7,
                    center: Text(
                      "$percentValue%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: MyColors.appMainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget cardActivity(String label) {
      return Expanded(
        child: Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: MyColors.appMainColor, width: 1.0),
              borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Image.asset("assets/images/universe.png"),
              const SizedBox(
                width: 10,
              ),
              Text(label)
            ]),
          ),
        ),
      );
    }

    Widget cardActivity2(String label) {
      return Expanded(
        child: Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: MyColors.appMainColor, width: 1.0),
              borderRadius: BorderRadius.circular(4.0)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 10, top: 5),
                child: Row(children: [
                  Image.asset("assets/images/universe.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(label),
                      const Text(
                        "12:00 PM",
                        style: TextStyle(color: MyColors.appMainColor),
                      )
                    ],
                  )
                ]),
              ),
              // Align(alignment: Alignment.topRight, child: Text("12: 00 PM")),
            ],
          ),
        ),
      );
    }

    Widget linerProgressbar(String barname, double percentValue) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10, bottom: 5),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.75,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2500,
              percent: 0.8,
              center: Text(
                barname,
                style: const TextStyle(color: Colors.white),
              ),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: MyColors.appMainColor,
            ),
          ),
          Text("$percentValue%")
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 247, 253, 1),
      appBar: AppBar(
        title: const Text("Good Morning, Waqar"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Table(
                border: TableBorder.all(color: MyColors.appMainColor),
                children: const [
                  TableRow(
                      decoration: BoxDecoration(color: MyColors.appMainColor),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Visits",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Planned",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Finished",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Hours",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        'JP',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('15'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('16'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("8"),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text('Out Of Plan'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("15"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('9'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('22'),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text('Total'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("15"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('9'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('22'),
                    ),
                  ]),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  circularProgressCard(70.0, "JPC"),
                  circularProgressCard(90.0, "Productivity"),
                  circularProgressCard(30.0, "Efficiency"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Activity",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  cardActivity("Visit Pool"),
                  cardActivity("Universe")
                ],
              ),
              Row(
                children: [
                  cardActivity2("Visit Pool"),
                  cardActivity2("Universe")
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "MTD",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    linerProgressbar("Attendence", 80.0),
                    linerProgressbar("JPC", 70.0),
                    linerProgressbar("Productivity", 60.0),
                    const SizedBox(height: 5)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            const Text("Efficiency"),
                            Image.asset("assets/images/efficiency.png"),
                            const Text("90%")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            const Text("Efficiency"),
                            Image.asset("assets/images/efficiency.png"),
                            const Text(
                              "50 SAR",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            const Text("Incentives"),
                            Image.asset("assets/images/efficiency.png"),
                            const Text("50 SAR")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
