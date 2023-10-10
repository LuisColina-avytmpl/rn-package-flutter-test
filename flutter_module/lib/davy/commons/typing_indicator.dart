import 'package:flutter/material.dart';
import 'dart:math';
import '../controllers/animation_utils.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

const dotHeight = 4.0;

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  static const double separation = 2.0; // Adjust the separation here
  static const int numberOfDots = 3; // Adjust the number of dots here

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();
    _animation1 = createAnimation(_controller, 0.0, 0.33);
    _animation2 = createAnimation(_controller, 0.33, 0.66);
    _animation3 = createAnimation(_controller, 0.66, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(
        (dotHeight + separation) * numberOfDots -
            separation, // Calculate the total width
        dotHeight, // Fixed height of the dots
      ),
      child: Center(
        // Center the Row vertically
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Dot(animation: _animation1),
            Dot(animation: _animation2),
            Dot(animation: _animation3),
          ],
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

class Dot extends StatelessWidget {
  final Animation<double> animation;

  const Dot({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = Offset(
          0.0,
          dotHeight * (1.0 + 0.2 * sin(animation.value * pi / 180)),
        );
        return Transform.translate(
          offset: offset,
          child: Container(
            width: dotHeight,
            height: dotHeight,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff333333),
            ),
          ),
        );
      },
    );
  }
}
