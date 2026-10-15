import 'package:flutter/animation.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
  static const Duration gradient = Duration(seconds: 4);
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration pulse = Duration(milliseconds: 2000);
  static const Duration float = Duration(seconds: 3);

  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve elastic = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve decelerate = Curves.decelerate;

  static const Offset slideUpBegin = Offset(0, 0.3);
  static const Offset slideRightBegin = Offset(-0.3, 0);
  static const Offset slideLeftBegin = Offset(0.3, 0);
  static const Offset slideDownBegin = Offset(0, -0.3);
  static const Offset slideEnd = Offset.zero;

  static const double scaleFrom = 0.9;
  static const double scaleTo = 1.0;
  static const double scaleInFrom = 0.7;
}

class AnimConstants {
  AnimConstants._();

  static const Duration appearDuration = Duration(milliseconds: 500);
  static const Curve appearCurve = Curves.easeOutCubic;
  static const double pulseMin = 0.95;
  static const double pulseMax = 1.05;
  static const double glowMin = 0.4;
  static const double glowMax = 0.9;
}
