import 'package:cstore/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const routename = "/welcome_route";
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset("assets/images/brandlogo.png"),
            const SizedBox(
              height: 50,
            ),
            const Text(
                "BrandPartners is a leading Merchandising, Brand Activation, and FieldForce Management company founded in 2006 in Saudi Arabia aiming to utilize best-in-class processes and technology along with solid human competencies to successfully deliver your brand execution pillars."),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
                minimumSize: Size(screenWidth, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(DashBoard.routeName);
              },
              child: const Text(
                "Next",
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
