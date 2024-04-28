import 'package:flutter/material.dart';

class ClockwiseAnticlockwiseRotation extends StatefulWidget {
  @override
  _ClockwiseAnticlockwiseRotationState createState() =>
      _ClockwiseAnticlockwiseRotationState();
}

class _ClockwiseAnticlockwiseRotationState
    extends State<ClockwiseAnticlockwiseRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6), // Total animation duration
    );

    _animation = Tween<double>(begin: 0, end: 6.283) // 6.283 = 2 * pi
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clockwise & Anticlockwise Rotation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double angle = _animation.value < 3
                ? _animation.value
                : 6.283 - _animation.value; // Counter clockwise after 3 seconds
            return Transform.rotate(
                angle: angle,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                )
                // Container(
                //   width: 100,
                //   height: 100,
                //   color: Colors.blue,
                //   child: Center(child: Image.asset("assets/images/logo2.png")
                //       // Text(
                //       //   'Rotate',
                //       //   style: TextStyle(
                //       //     fontSize: 20,
                //       //     color: Colors.white,
                //       //   ),
                //       // ),
                //       ),
                // ),
                );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
