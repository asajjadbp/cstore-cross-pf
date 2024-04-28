import 'package:cstore/screens/Jouney%20Plan/journey_plan.dart';
import 'package:flutter/material.dart';

class JourneyPlanScreen extends StatelessWidget {
  const JourneyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Pool"),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (ctx, i) {
            return const JourneyPlan();
          }),
    );
  }
}
