import 'package:flutter/material.dart';

Animation<double> createAnimation(
  AnimationController controller,
  double startInterval,
  double endInterval,
) {
  return Tween<double>(begin: 0, end: 360).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(startInterval, endInterval, curve: Curves.linear),
    ),
  );
}
